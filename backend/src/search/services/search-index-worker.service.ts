import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, In, LessThan, Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import {
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

  private readonly logger = new Logger(SearchIndexWorkerService.name);

  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(SearchIndexOutbox)
    private readonly outboxRepository: Repository<SearchIndexOutbox>,
    private readonly indexer: BookingSearchIndexerService,
    private readonly configService: ConfigService,
  ) {}

  @Cron(CronExpression.EVERY_10_SECONDS)
  async processPending(): Promise<void> {
    if (this.configService.get<string>('NODE_ENV') !== 'production') {
      return;
    }
    this.logger.log('Processing pending search index events...');
    const hasLock = await this.tryAcquireLock(
      SearchIndexWorkerService.PROCESS_LOCK_ID,
    );
    if (!hasLock) return;

    try {
      const events = await this.outboxRepository.find({
        where: [
          { status: SearchIndexOutboxStatus.PENDING },
          {
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
      await this.releaseLock(SearchIndexWorkerService.PROCESS_LOCK_ID);
    }
  }

  @Cron(CronExpression.EVERY_5_MINUTES)
  async reconcile(): Promise<void> {
    if (this.configService.get<string>('NODE_ENV') !== 'production') {
      return;
    }
    this.logger.log('Reconciling search index events...');

    const hasLock = await this.tryAcquireLock(
      SearchIndexWorkerService.RECONCILE_LOCK_ID,
    );
    if (!hasLock) return;

    try {
      await this.processPending();
      await this.indexer.refreshAll();
    } catch (error) {
      this.logger.warn(
        `Booking search reconciliation failed: ${(error as Error).message}`,
      );
    } finally {
      await this.releaseLock(SearchIndexWorkerService.RECONCILE_LOCK_ID);
    }
  }

  async reindexAllNow(): Promise<void> {
    this.logger.log('Reindexing all search index events...');
    await this.indexer.refreshAll();
  }

  private async processEvent(event: SearchIndexOutbox): Promise<void> {
    this.logger.log('Processing search index event...');
    await this.outboxRepository.update(
      {
        id: event.id,
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

    try {
      await this.indexer.syncEntity(
        event.entityType,
        event.entityId,
        event.operation,
        event.payload,
      );
      await this.outboxRepository.update(event.id, {
        status: SearchIndexOutboxStatus.DONE,
        processedAt: new Date(),
        lastError: null,
      });
    } catch (error) {
      await this.outboxRepository.update(event.id, {
        status: SearchIndexOutboxStatus.FAILED,
        lastError: (error as Error).message.slice(0, 4000),
      });
      this.logger.warn(
        `Search index event ${event.id} failed: ${(error as Error).message}`,
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
}
