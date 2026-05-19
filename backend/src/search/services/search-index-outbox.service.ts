import { Injectable } from '@nestjs/common';
import { EntityManager } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import {
  SearchIndexEntityType,
  SearchIndexOperation,
  SearchIndexOutbox,
  SearchIndexOutboxStatus,
} from '../entities/search-index-outbox.entity';

@Injectable()
export class SearchIndexOutboxService {
  constructor(private readonly configService: ConfigService) {}

  async enqueue(
    manager: EntityManager,
    entityType: SearchIndexEntityType,
    entityId: string,
    operation: SearchIndexOperation = SearchIndexOperation.UPSERT,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    if (!entityId) return;

    if (this.configService.get<string>('NODE_ENV') !== 'production') {
      return;
    }

    const event = manager.create(SearchIndexOutbox, {
      entityType,
      entityId,
      operation,
      payload: payload ?? null,
      status: SearchIndexOutboxStatus.PENDING,
      attemptCount: 0,
    });
    await manager.save(SearchIndexOutbox, event);
  }

  async enqueueProduct(
    manager: EntityManager,
    productId: string,
    operation: SearchIndexOperation = SearchIndexOperation.UPSERT,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    await this.enqueue(
      manager,
      SearchIndexEntityType.PRODUCT,
      productId,
      operation,
      payload,
    );
  }

  async enqueueEmployee(
    manager: EntityManager,
    employeeId: string,
    operation: SearchIndexOperation = SearchIndexOperation.UPSERT,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    await this.enqueue(
      manager,
      SearchIndexEntityType.EMPLOYEE,
      employeeId,
      operation,
      payload,
    );
  }

  async enqueueEmployees(
    manager: EntityManager,
    employeeIds: string[],
    operation: SearchIndexOperation = SearchIndexOperation.UPSERT,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    for (const employeeId of [...new Set(employeeIds.filter(Boolean))]) {
      await this.enqueueEmployee(manager, employeeId, operation, payload);
    }
  }
}
