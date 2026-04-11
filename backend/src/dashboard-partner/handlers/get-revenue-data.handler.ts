import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '../dto/query/dashboard-period-query.dto';
import { RevenueDataPointDto } from '../dto/response/revenue-data-point.dto';
import {
  resolveDateRange,
  resolveGranularity,
} from '../helpers/date-range.helper';

@Injectable()
export class GetRevenueDataHandler {
  private readonly logger = new Logger(GetRevenueDataHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    period: DashboardTimePeriod,
  ): Promise<RevenueDataPointDto[]> {
    this.logger.log(
      `Getting revenue data for partner: ${partnerId}, period: ${period}`,
    );

    const { startDate, endDate } = resolveDateRange(period);
    const granularity = resolveGranularity(period);

    // Time-bucket aggregation query
    const rows: { bucket: Date; revenue: string }[] =
      await this.dataSource.query(
        `SELECT
          date_trunc($1, p.paid_at) AS bucket,
          COALESCE(SUM(p.amount), 0) AS revenue
        FROM payments p
        JOIN bookings b ON p.booking_id = b.id
        JOIN employees e ON b.staff_id = e.id
        WHERE e.partner_id = $2
          AND p.payment_status IN ('PAID', 'DEPOSITED')
          AND p.paid_at BETWEEN $3 AND $4
          AND p.deleted_at IS NULL
        GROUP BY bucket
        ORDER BY bucket ASC`,
        [granularity, partnerId, startDate, endDate],
      );

    // Build a map of existing buckets for fast lookup
    const revenueMap = new Map<string, number>();
    for (const row of rows) {
      const key = new Date(row.bucket).toISOString();
      revenueMap.set(key, parseFloat(row.revenue) || 0);
    }

    // Generate complete time series and zero-fill gaps
    const allBuckets = this.generateTimeBuckets(
      startDate,
      endDate,
      granularity,
    );

    return allBuckets.map((bucketDate) => {
      const key = bucketDate.toISOString();
      const dto = new RevenueDataPointDto();
      dto.date = key;
      dto.revenue = revenueMap.get(key) || 0;
      return dto;
    });
  }

  /**
   * Generates a complete series of time buckets between start and end dates
   * at the specified granularity, ensuring the chart has continuous data.
   */
  private generateTimeBuckets(
    startDate: Date,
    endDate: Date,
    granularity: 'hour' | 'day' | 'week' | 'month',
  ): Date[] {
    const buckets: Date[] = [];
    const current = new Date(startDate);

    while (current <= endDate) {
      buckets.push(new Date(current));

      switch (granularity) {
        case 'hour':
          current.setHours(current.getHours() + 1);
          break;
        case 'day':
          current.setDate(current.getDate() + 1);
          break;
        case 'week':
          current.setDate(current.getDate() + 7);
          break;
        case 'month':
          current.setMonth(current.getMonth() + 1);
          break;
      }
    }

    return buckets;
  }
}
