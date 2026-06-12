import {
  SearchIndexEnvironment,
  SearchIndexEntityType,
  SearchIndexOperation,
  SearchIndexOutbox,
  SearchIndexOutboxStatus,
} from '../entities/search-index-outbox.entity';
import { SearchIndexOutboxService } from './search-index-outbox.service';

describe('SearchIndexOutboxService', () => {
  let service: SearchIndexOutboxService;
  const manager = {
    create: jest.fn(),
    save: jest.fn(),
  };
  const mockConfigService = {
    get: jest.fn(),
  };

  beforeEach(() => {
    jest.clearAllMocks();
    mockConfigService.get.mockReturnValue(undefined);
    service = new SearchIndexOutboxService(mockConfigService as any);
    manager.create.mockImplementation((_, payload) => payload);
    manager.save.mockResolvedValue(undefined);
  });

  it('enqueues product index events for each target environment with pending status', async () => {
    await service.enqueueProduct(
      manager as any,
      'product-id',
      SearchIndexOperation.UPSERT,
      { employeeIds: ['employee-id'] },
    );

    expect(manager.create).toHaveBeenCalledTimes(3);
    expect(manager.save).toHaveBeenCalledTimes(3);
    expect(manager.create).toHaveBeenNthCalledWith(1, SearchIndexOutbox, {
      entityType: SearchIndexEntityType.PRODUCT,
      entityId: 'product-id',
      operation: SearchIndexOperation.UPSERT,
      targetEnvironment: SearchIndexEnvironment.PRODUCTION,
      payload: { employeeIds: ['employee-id'] },
      status: SearchIndexOutboxStatus.PENDING,
      attemptCount: 0,
    });
    expect(manager.create).toHaveBeenNthCalledWith(
      2,
      SearchIndexOutbox,
      expect.objectContaining({
        targetEnvironment: SearchIndexEnvironment.DEV,
      }),
    );
    expect(manager.create).toHaveBeenNthCalledWith(
      3,
      SearchIndexOutbox,
      expect.objectContaining({
        targetEnvironment: SearchIndexEnvironment.UAT,
      }),
    );
  });

  it('deduplicates employee index events', async () => {
    mockConfigService.get.mockImplementation((key: string) =>
      key === 'SEARCH_INDEX_TARGET_ENVIRONMENTS' ? 'dev' : undefined,
    );

    await service.enqueueEmployees(manager as any, [
      'employee-1',
      'employee-1',
      'employee-2',
    ]);

    expect(manager.save).toHaveBeenCalledTimes(2);
    expect(manager.create).toHaveBeenNthCalledWith(
      1,
      SearchIndexOutbox,
      expect.objectContaining({
        entityId: 'employee-1',
        targetEnvironment: SearchIndexEnvironment.DEV,
      }),
    );
    expect(manager.create).toHaveBeenNthCalledWith(
      2,
      SearchIndexOutbox,
      expect.objectContaining({
        entityId: 'employee-2',
        targetEnvironment: SearchIndexEnvironment.DEV,
      }),
    );
  });

  it('deduplicates configured target environments and ignores invalid values', async () => {
    mockConfigService.get.mockImplementation((key: string) =>
      key === 'SEARCH_INDEX_TARGET_ENVIRONMENTS'
        ? 'UAT,DEV,uat,invalid'
        : undefined,
    );

    await service.enqueueProduct(manager as any, 'product-id');

    expect(manager.save).toHaveBeenCalledTimes(2);
    expect(manager.create).toHaveBeenNthCalledWith(
      1,
      SearchIndexOutbox,
      expect.objectContaining({
        targetEnvironment: SearchIndexEnvironment.UAT,
      }),
    );
    expect(manager.create).toHaveBeenNthCalledWith(
      2,
      SearchIndexOutbox,
      expect.objectContaining({
        targetEnvironment: SearchIndexEnvironment.DEV,
      }),
    );
  });
});
