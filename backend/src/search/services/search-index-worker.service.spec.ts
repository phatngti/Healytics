import { SearchIndexWorkerService } from './search-index-worker.service';
import {
  SearchIndexEnvironment,
  SearchIndexEntityType,
  SearchIndexOperation,
  SearchIndexOutbox,
  SearchIndexOutboxStatus,
} from '../entities/search-index-outbox.entity';

describe('SearchIndexWorkerService', () => {
  const dataSource = {
    query: jest.fn(),
  };
  const outboxRepository = {
    find: jest.fn(),
    update: jest.fn(),
  };
  const indexer = {
    syncEntity: jest.fn(),
    refreshAll: jest.fn(),
  };
  const configService = {
    get: jest.fn(),
  };

  let service: SearchIndexWorkerService;

  beforeEach(() => {
    jest.clearAllMocks();
    dataSource.query.mockImplementation((query: string) =>
      query.includes('pg_try_advisory_lock')
        ? Promise.resolve([{ locked: true }])
        : Promise.resolve([]),
    );
    outboxRepository.find.mockResolvedValue([]);
    outboxRepository.update.mockResolvedValue({ affected: 1 });
    indexer.syncEntity.mockResolvedValue(undefined);
    indexer.refreshAll.mockResolvedValue(undefined);
    configService.get.mockImplementation((key: string) => {
      if (key === 'SEARCH_INDEX_WORKER_ENABLED') return 'true';
      if (key === 'SEARCH_INDEX_WORKER_ENV') return SearchIndexEnvironment.DEV;
      return undefined;
    });

    service = new SearchIndexWorkerService(
      dataSource as any,
      outboxRepository as any,
      indexer as any,
      configService as any,
    );
  });

  it('fetches only rows for the configured worker environment', async () => {
    await service.processPending();

    expect(outboxRepository.find).toHaveBeenCalledWith({
      where: [
        {
          targetEnvironment: SearchIndexEnvironment.DEV,
          status: SearchIndexOutboxStatus.PENDING,
        },
        {
          targetEnvironment: SearchIndexEnvironment.DEV,
          status: SearchIndexOutboxStatus.FAILED,
          attemptCount: expect.any(Object),
        },
      ],
      order: { createdAt: 'ASC' },
      take: 50,
    });
    expect(dataSource.query).toHaveBeenNthCalledWith(
      1,
      'SELECT pg_try_advisory_lock($1, $2) AS locked',
      [1779200000, 101],
    );
    expect(dataSource.query).toHaveBeenNthCalledWith(
      2,
      'SELECT pg_advisory_unlock($1, $2)',
      [1779200000, 101],
    );
  });

  it('retries failed rows only for the matching environment', async () => {
    const event = makeEvent({
      status: SearchIndexOutboxStatus.FAILED,
      attemptCount: 1,
    });
    outboxRepository.find.mockResolvedValue([event]);

    await service.processPending();

    expect(outboxRepository.update).toHaveBeenNthCalledWith(
      1,
      expect.objectContaining({
        id: event.id,
        targetEnvironment: SearchIndexEnvironment.DEV,
        status: expect.any(Object),
      }),
      {
        status: SearchIndexOutboxStatus.PROCESSING,
        attemptCount: 2,
        lastError: null,
      },
    );
    expect(indexer.syncEntity).toHaveBeenCalledWith(
      event.entityType,
      event.entityId,
      event.operation,
      event.payload,
    );
    expect(outboxRepository.update).toHaveBeenNthCalledWith(
      2,
      {
        id: event.id,
        targetEnvironment: SearchIndexEnvironment.DEV,
      },
      expect.objectContaining({
        status: SearchIndexOutboxStatus.DONE,
        lastError: null,
      }),
    );
  });

  it('does not sync if another worker already claimed the row', async () => {
    outboxRepository.find.mockResolvedValue([makeEvent()]);
    outboxRepository.update.mockResolvedValueOnce({ affected: 0 });

    await service.processPending();

    expect(indexer.syncEntity).not.toHaveBeenCalled();
    expect(outboxRepository.update).toHaveBeenCalledTimes(1);
    expect(outboxRepository.update).toHaveBeenCalledWith(
      expect.objectContaining({
        targetEnvironment: SearchIndexEnvironment.DEV,
      }),
      expect.any(Object),
    );
  });

  it('maps NODE_ENV=development to the dev worker environment', async () => {
    configService.get.mockImplementation((key: string) => {
      if (key === 'SEARCH_INDEX_WORKER_ENABLED') return 'true';
      if (key === 'SEARCH_INDEX_WORKER_ENV') return undefined;
      if (key === 'NODE_ENV') return 'development';
      return undefined;
    });

    await service.processPending();

    expect(outboxRepository.find).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.arrayContaining([
          expect.objectContaining({
            targetEnvironment: SearchIndexEnvironment.DEV,
          }),
        ]),
      }),
    );
  });

  it('normalizes uppercase configured worker environments', async () => {
    configService.get.mockImplementation((key: string) => {
      if (key === 'SEARCH_INDEX_WORKER_ENABLED') return 'true';
      if (key === 'SEARCH_INDEX_WORKER_ENV') return 'UAT';
      return undefined;
    });

    await service.processPending();

    expect(outboxRepository.find).toHaveBeenCalledWith(
      expect.objectContaining({
        where: expect.arrayContaining([
          expect.objectContaining({
            targetEnvironment: SearchIndexEnvironment.UAT,
          }),
        ]),
      }),
    );
  });

  function makeEvent(
    overrides: Partial<SearchIndexOutbox> = {},
  ): SearchIndexOutbox {
    return {
      id: 'event-id',
      entityType: SearchIndexEntityType.PRODUCT,
      entityId: 'product-id',
      operation: SearchIndexOperation.UPSERT,
      targetEnvironment: SearchIndexEnvironment.DEV,
      payload: null,
      status: SearchIndexOutboxStatus.PENDING,
      attemptCount: 0,
      lastError: null,
      processedAt: null,
      createdAt: new Date('2026-05-31T00:00:00.000Z'),
      updatedAt: new Date('2026-05-31T00:00:00.000Z'),
      ...overrides,
    };
  }
});
