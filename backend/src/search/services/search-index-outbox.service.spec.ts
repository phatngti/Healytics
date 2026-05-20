import {
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

  beforeEach(() => {
    jest.clearAllMocks();
    service = new SearchIndexOutboxService();
    manager.create.mockImplementation((_, payload) => payload);
    manager.save.mockResolvedValue(undefined);
  });

  it('enqueues product index events with pending status', async () => {
    await service.enqueueProduct(
      manager as any,
      'product-id',
      SearchIndexOperation.UPSERT,
      { employeeIds: ['employee-id'] },
    );

    expect(manager.create).toHaveBeenCalledWith(SearchIndexOutbox, {
      entityType: SearchIndexEntityType.PRODUCT,
      entityId: 'product-id',
      operation: SearchIndexOperation.UPSERT,
      payload: { employeeIds: ['employee-id'] },
      status: SearchIndexOutboxStatus.PENDING,
      attemptCount: 0,
    });
    expect(manager.save).toHaveBeenCalledWith(
      SearchIndexOutbox,
      expect.objectContaining({ entityId: 'product-id' }),
    );
  });

  it('deduplicates employee index events', async () => {
    await service.enqueueEmployees(manager as any, [
      'employee-1',
      'employee-1',
      'employee-2',
    ]);

    expect(manager.save).toHaveBeenCalledTimes(2);
    expect(manager.create).toHaveBeenNthCalledWith(
      1,
      SearchIndexOutbox,
      expect.objectContaining({ entityId: 'employee-1' }),
    );
    expect(manager.create).toHaveBeenNthCalledWith(
      2,
      SearchIndexOutbox,
      expect.objectContaining({ entityId: 'employee-2' }),
    );
  });
});
