import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, In, LessThan, Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import {
  SearchIndexEnvironment,
  SearchIndexOutbox,
  SearchIndexOutboxStatus,
} from '../entities/search-index-outbox.entity';
import { BookingSearchIndexerService } from './booking-search-indexer.service';

@Injectable()
export class SearchIndexWorkerService {
  private static readonly PROCESS_LOCK_NAMESPACE = 1779200000;
  private static readonly PROCESS_LOCK_ID = 1;
  private static readonly RECONCILE_LOCK_ID = 2;
  private static readonly MAX_ATTEMPTS = 5;
  private static readonly LOCK_ENVIRONMENT_OFFSETS = {
    [SearchIndexEnvironment.PRODUCTION]: 0,
    [SearchIndexEnvironment.DEV]: 100,
    [SearchIndexEnvironment.UAT]: 200,
  } as const;

  private readonly logger = new Logger(SearchIndexWorkerService.name);

  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(SearchIndexOutbox)
    private readonly outboxRepository: Repository<SearchIndexOutbox>,
    private readonly indexer: BookingSearchIndexerService,
    private readonly configService: ConfigService,
  ) {}

  @Cron(CronExpression.EVERY_10_MINUTES)
  async processPending(): Promise<void> {
    if (!this.isWorkerEnabled()) return;

    const targetEnvironment = this.getWorkerEnvironment();
    this.logger.log(
      `Processing pending search index events for ${targetEnvironment}...`,
    );
    const processLockId = this.getEnvironmentLockId(
      SearchIndexWorkerService.PROCESS_LOCK_ID,
      targetEnvironment,
    );
    const hasLock = await this.tryAcquireLock(processLockId);
    if (!hasLock) return;

    try {
      const events = await this.outboxRepository.find({
        where: [
          {
            targetEnvironment,
            status: SearchIndexOutboxStatus.PENDING,
          },
          {
            targetEnvironment,
            status: SearchIndexOutboxStatus.FAILED,
            attemptCount: LessThan(SearchIndexWorkerService.MAX_ATTEMPTS),
          },
        ],
        order: { createdAt: 'ASC' },
        take: 50,
      });

      for (const event of events) {
        await this.processEvent(event);
      }
    } finally {
      await this.releaseLock(processLockId);
    }
  }

  @Cron(CronExpression.EVERY_10_MINUTES)
  async reconcile(): Promise<void> {
    if (!this.isWorkerEnabled()) return;

    this.logger.log('Start reconcile search index events');

    const targetEnvironment = this.getWorkerEnvironment();
    this.logger.log(
      `Reconciling search index events for ${targetEnvironment}...`,
    );

    const reconcileLockId = this.getEnvironmentLockId(
      SearchIndexWorkerService.RECONCILE_LOCK_ID,
      targetEnvironment,
    );
    const hasLock = await this.tryAcquireLock(reconcileLockId);
    if (!hasLock) return;

    try {
      await this.processPending();
      await this.indexer.refreshAll();
    } catch (error) {
      this.logger.warn(
        `Booking search reconciliation failed for ${targetEnvironment}: ${
          (error as Error).message
        }`,
      );
    } finally {
      await this.releaseLock(reconcileLockId);
    }
  }

  async reindexAllNow(): Promise<void> {
    this.logger.log(
      `Reindexing all search index events for ${this.getWorkerEnvironment()}...`,
    );
    await this.indexer.refreshAll();
  }

  private async processEvent(event: SearchIndexOutbox): Promise<void> {
    this.logger.log(
      `Processing search index event ${event.id} for ${event.targetEnvironment}...`,
    );
    const updateResult = await this.outboxRepository.update(
      {
        id: event.id,
        targetEnvironment: event.targetEnvironment,
        status: In([
          SearchIndexOutboxStatus.PENDING,
          SearchIndexOutboxStatus.FAILED,
        ]),
      },
      {
        status: SearchIndexOutboxStatus.PROCESSING,
        attemptCount: event.attemptCount + 1,
        lastError: null,
      },
    );
    if (updateResult.affected === 0) return;

    try {
      await this.indexer.syncEntity(
        event.entityType,
        event.entityId,
        event.operation,
        event.payload,
      );
      await this.outboxRepository.update(
        { id: event.id, targetEnvironment: event.targetEnvironment },
        {
          status: SearchIndexOutboxStatus.DONE,
          processedAt: new Date(),
          lastError: null,
        },
      );
    } catch (error) {
      await this.outboxRepository.update(
        { id: event.id, targetEnvironment: event.targetEnvironment },
        {
          status: SearchIndexOutboxStatus.FAILED,
          lastError: (error as Error).message.slice(0, 4000),
        },
      );
      this.logger.warn(
        `Search index event ${event.id} failed for ${
          event.targetEnvironment
        }: ${(error as Error).message}`,
      );
    }
  }

  private async tryAcquireLock(lockId: number): Promise<boolean> {
    const rows = await this.dataSource.query(
      'SELECT pg_try_advisory_lock($1, $2) AS locked',
      [SearchIndexWorkerService.PROCESS_LOCK_NAMESPACE, lockId],
    );
    return rows[0]?.locked === true;
  }

  private async releaseLock(lockId: number): Promise<void> {
    await this.dataSource.query('SELECT pg_advisory_unlock($1, $2)', [
      SearchIndexWorkerService.PROCESS_LOCK_NAMESPACE,
      lockId,
    ]);
  }

  private isWorkerEnabled(): boolean {
    const configured = this.configService.get<string>(
      'SEARCH_INDEX_WORKER_ENABLED',
    );
    if (configured !== undefined) {
      return configured !== 'false';
    }

    return this.configService.get<string>('NODE_ENV') !== 'test';
  }

  private getWorkerEnvironment(): SearchIndexEnvironment {
    const configured = this.configService.get<string>(
      'SEARCH_INDEX_WORKER_ENV',
    );
    const candidate = configured ?? this.configService.get<string>('NODE_ENV');
    return this.normalizeEnvironment(candidate);
  }

  private normalizeEnvironment(
    environment: string | undefined,
  ): SearchIndexEnvironment {
    const normalized = environment?.trim().toLowerCase();
    if (normalized === SearchIndexEnvironment.PRODUCTION) {
      return SearchIndexEnvironment.PRODUCTION;
    }
    if (normalized === SearchIndexEnvironment.UAT) {
      return SearchIndexEnvironment.UAT;
    }
    if (
      normalized === SearchIndexEnvironment.DEV ||
      normalized === 'development'
    ) {
      return SearchIndexEnvironment.DEV;
    }

    return SearchIndexEnvironment.DEV;
  }

  private getEnvironmentLockId(
    lockId: number,
    targetEnvironment: SearchIndexEnvironment,
  ): number {
    return (
      lockId +
      SearchIndexWorkerService.LOCK_ENVIRONMENT_OFFSETS[targetEnvironment]
    );
  }
}
