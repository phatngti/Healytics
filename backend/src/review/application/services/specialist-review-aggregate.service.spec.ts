import { SpecialistReviewAggregateService } from './specialist-review-aggregate.service';

describe('SpecialistReviewAggregateService', () => {
  let dataSource: { query: jest.Mock };
  let service: SpecialistReviewAggregateService;

  beforeEach(() => {
    dataSource = {
      query: jest.fn((sql: string) => {
        if (sql.includes('pg_try_advisory_lock')) {
          return Promise.resolve([{ locked: true }]);
        }
        return Promise.resolve([]);
      }),
    };
    service = new SpecialistReviewAggregateService(dataSource as any);
  });

  afterEach(() => {
    service.onModuleDestroy();
    jest.clearAllMocks();
  });

  it('deduplicates queued specialist refreshes before recomputing', async () => {
    service.enqueueSpecialistRefresh('emp-1');
    service.enqueueSpecialistRefresh('emp-1');
    service.enqueueSpecialistRefresh('emp-2');

    await service.flushPendingSpecialists();

    expect(dataSource.query).toHaveBeenCalledTimes(1);
    expect(dataSource.query).toHaveBeenCalledWith(expect.any(String), [
      ['emp-1', 'emp-2'],
    ]);
  });

  it('recomputes specialist aggregates from specialist_reviews', async () => {
    await service.refreshSpecialists(['emp-1', 'emp-1', '']);

    expect(dataSource.query).toHaveBeenCalledTimes(1);
    const [sql, params] = dataSource.query.mock.calls[0];
    expect(sql).toContain('FROM specialist_reviews sr');
    expect(sql).toContain('ROUND(AVG(sr.rating)::numeric, 2)');
    expect(sql).toContain('COUNT(sr.id)::int');
    expect(params).toEqual([['emp-1']]);
  });

  it('flushes queued refreshes before the five-minute reconciliation query', async () => {
    service.enqueueSpecialistRefresh('emp-1');

    await service.reconcileAllSpecialistAggregates();

    expect(dataSource.query).toHaveBeenCalledTimes(4);
    expect(dataSource.query.mock.calls[0][1]).toEqual([['emp-1']]);
    expect(dataSource.query.mock.calls[1][0]).toContain('pg_try_advisory_lock');
    expect(dataSource.query.mock.calls[2][0]).toContain(
      'WITH review_aggregates AS',
    );
    expect(dataSource.query.mock.calls[3][0]).toContain('pg_advisory_unlock');
  });

  it('skips full reconciliation when another worker holds the advisory lock', async () => {
    dataSource.query.mockImplementation((sql: string) => {
      if (sql.includes('pg_try_advisory_lock')) {
        return Promise.resolve([{ locked: false }]);
      }
      return Promise.resolve([]);
    });

    await service.reconcileAllSpecialistAggregates();

    expect(dataSource.query).toHaveBeenCalledTimes(1);
    expect(dataSource.query.mock.calls[0][0]).toContain('pg_try_advisory_lock');
  });
});
