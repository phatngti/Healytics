import { DataSource } from 'typeorm';
import { PartnerStatisticsRefreshService } from './partner-statistics-refresh.service';

describe('PartnerStatisticsRefreshService', () => {
  let query: jest.Mock;
  let service: PartnerStatisticsRefreshService;

  beforeEach(() => {
    query = jest.fn();
    service = new PartnerStatisticsRefreshService({
      query,
    } as unknown as DataSource);
  });

  it('skips refresh when another worker holds the advisory lock', async () => {
    query.mockResolvedValueOnce([{ locked: false }]);

    await service.refreshAllPartnerStatistics();

    expect(query).toHaveBeenCalledTimes(1);
    expect(query.mock.calls[0][0]).toContain('pg_try_advisory_lock');
  });

  it('runs one bulk upsert query and releases the lock', async () => {
    query
      .mockResolvedValueOnce([{ locked: true }])
      .mockResolvedValueOnce(undefined)
      .mockResolvedValueOnce(undefined);

    await service.refreshAllPartnerStatistics();

    expect(query).toHaveBeenCalledTimes(3);
    expect(query.mock.calls[1][0]).toContain('INSERT INTO partner_statistics');
    expect(query.mock.calls[1][0]).toContain('product_treatment_reviews');
    expect(query.mock.calls[1][0]).toContain('specialist_reviews');
    expect(query.mock.calls[1][0]).toContain(
      'ON CONFLICT (partner_id) DO UPDATE',
    );
    expect(query.mock.calls[2][0]).toContain('pg_advisory_unlock');
  });

  it('uses the same optimized SQL for direct upsert calls', async () => {
    query.mockResolvedValueOnce(undefined);

    await service.upsertAllPartnerStatistics();

    const sql = query.mock.calls[0][0];
    expect(sql).toContain('COALESCE(e.partner_id, p.partner_id)');
    expect(sql).toContain('COUNT(*) FILTER');
  });
});
