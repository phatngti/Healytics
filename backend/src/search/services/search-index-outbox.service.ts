import { Injectable } from '@nestjs/common';
import { EntityManager } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import {
  SearchIndexEnvironment,
  SearchIndexEntityType,
  SearchIndexOperation,
  SearchIndexOutbox,
  SearchIndexOutboxStatus,
} from '../entities/search-index-outbox.entity';

@Injectable()
export class SearchIndexOutboxService {
  private static readonly DEFAULT_TARGET_ENVIRONMENTS = [
    SearchIndexEnvironment.PRODUCTION,
    SearchIndexEnvironment.DEV,
    SearchIndexEnvironment.UAT,
  ];

  constructor(private readonly configService: ConfigService) {}

  async enqueue(
    manager: EntityManager,
    entityType: SearchIndexEntityType,
    entityId: string,
    operation: SearchIndexOperation = SearchIndexOperation.UPSERT,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    if (!entityId) return;

    for (const targetEnvironment of this.getTargetEnvironments()) {
      const event = manager.create(SearchIndexOutbox, {
        entityType,
        entityId,
        operation,
        targetEnvironment,
        payload: payload ?? null,
        status: SearchIndexOutboxStatus.PENDING,
        attemptCount: 0,
      });
      await manager.save(SearchIndexOutbox, event);
    }
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

  private getTargetEnvironments(): SearchIndexEnvironment[] {
    const configured = this.configService.get<string>(
      'SEARCH_INDEX_TARGET_ENVIRONMENTS',
    );
    if (!configured) {
      return SearchIndexOutboxService.DEFAULT_TARGET_ENVIRONMENTS;
    }

    const validEnvironments = new Set<string>(
      SearchIndexOutboxService.DEFAULT_TARGET_ENVIRONMENTS,
    );
    const environments = configured
      .split(',')
      .map((environment) => environment.trim().toLowerCase())
      .filter((environment): environment is SearchIndexEnvironment =>
        validEnvironments.has(environment),
      );

    return environments.length > 0
      ? [...new Set(environments)]
      : SearchIndexOutboxService.DEFAULT_TARGET_ENVIRONMENTS;
  }
}
