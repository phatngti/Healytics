import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';
import {
  resolveDateRange,
  resolveGranularity,
} from '@/dashboard-partner/helpers/date-range.helper';
import { HealthServiceOverviewAnalyticsResponseDto } from '../../dto/partner/analytics/health-service-overview-analytics.dto';
import { AnalyticsBookingMetricsDto, BookingStatusBreakdownDto } from '../../dto/partner/analytics/analytics-booking-metrics.dto';
import { AnalyticsTrendPointDto } from '../../dto/partner/analytics/analytics-trend-point.dto';
import { AnalyticsCategoryPerformanceDto } from '../../dto/partner/analytics/analytics-category-performance.dto';
import { AnalyticsServicePerformanceDto } from '../../dto/partner/analytics/analytics-service-performance.dto';
import { AnalyticsAlertDto } from '../../dto/partner/analytics/analytics-alert.dto';

/** Subquery that selects product IDs for a given partner. */
const PARTNER_PRODUCTS_SUBQUERY =
  `(SELECT id FROM products WHERE partner_id = $1 AND deleted_at IS NULL)`;

@Injectable()
export class GetOverviewAnalyticsHandler {
  private readonly logger = new Logger(
    GetOverviewAnalyticsHandler.name,
  );

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    period: DashboardTimePeriod,
  ): Promise<HealthServiceOverviewAnalyticsResponseDto> {
    this.logger.log(
      `Getting overview analytics for partner: ${partnerId}, ` +
      `period: ${period}`,
    );

    const { startDate, endDate, prevStartDate, prevEndDate } =
      resolveDateRange(period);

    const [
      catalogStats,
      currentBookings,
      previousBookings,
      currentRevenue,
      previousRevenue,
      currentReviews,
      previousReviews,
      delayedStats,
      trendRows,
      categoryRows,
      topServiceRows,
    ] = await Promise.all([
      this.getCatalogStats(partnerId),
      this.getBookingStats(partnerId, startDate, endDate),
      this.getBookingStats(partnerId, prevStartDate, prevEndDate),
      this.getRevenue(partnerId, startDate, endDate),
      this.getRevenue(partnerId, prevStartDate, prevEndDate),
      this.getReviewStats(partnerId, startDate, endDate),
      this.getReviewStats(partnerId, prevStartDate, prevEndDate),
      this.getDelayedBookings(partnerId, startDate, endDate),
      this.getTrendData(partnerId, period, startDate, endDate),
      this.getCategoryPerformance(
        partnerId, startDate, endDate,
      ),
      this.getTopServices(partnerId, startDate, endDate),
    ]);

    const dto = new HealthServiceOverviewAnalyticsResponseDto();

    // ── Catalog KPIs ───────────────────────────────
    dto.totalProducts = catalogStats.total;
    dto.activeProducts = catalogStats.active;

    // ── Booking KPIs ───────────────────────────────
    dto.bookings = currentBookings.completed;
    dto.bookingsDelta = this.delta(
      currentBookings.completed,
      previousBookings.completed,
    );
    dto.revenue = currentRevenue;
    dto.revenueDelta = this.delta(currentRevenue, previousRevenue);
    dto.averageRating = currentReviews.avgRating;
    dto.ratingDelta = this.delta(
      currentReviews.avgRating,
      previousReviews.avgRating,
    );
    dto.reviewCount = currentReviews.count;

    // ── Booking Operations ─────────────────────────
    dto.bookingMetrics = this.buildBookingMetrics(
      currentBookings,
      delayedStats,
    );

    // ── Trend ──────────────────────────────────────
    dto.trendPoints = trendRows;

    // ── Category Performance ───────────────────────
    dto.categoryPerformance = categoryRows;

    // ── Top Services ───────────────────────────────
    dto.topServices = topServiceRows;

    return dto;
  }

  // ── Private query methods ──────────────────────────

  private async getCatalogStats(
    partnerId: string,
  ): Promise<{ total: number; active: number }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                    AS total,
        COUNT(*) FILTER (WHERE status = 'active')   AS active
      FROM products
      WHERE partner_id = $1
        AND deleted_at IS NULL`,
      [partnerId],
    );
    const row = result[0] || { total: '0', active: '0' };
    return {
      total: parseInt(row.total) || 0,
      active: parseInt(row.active) || 0,
    };
  }

  private async getBookingStats(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<{
    total: number;
    completed: number;
    pending: number;
    confirmed: number;
    cancelled: number;
    noShow: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                      AS total,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')               AS completed,
        COUNT(*) FILTER (
          WHERE b.status IN (
            'PENDING_PAYMENT', 'CONFIRMED'))           AS pending,
        COUNT(*) FILTER (
          WHERE b.status = 'CONFIRMED')                AS confirmed,
        COUNT(*) FILTER (
          WHERE b.status = 'CANCELLED')                AS cancelled,
        COUNT(*) FILTER (
          WHERE b.status = 'NO_SHOW')                  AS no_show
      FROM bookings b
      WHERE b.product_id IN ${PARTNER_PRODUCTS_SUBQUERY}
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL`,
      [partnerId, start, end],
    );
    const row = result[0] || {};
    return {
      total: parseInt(row.total) || 0,
      completed: parseInt(row.completed) || 0,
      pending: parseInt(row.pending) || 0,
      confirmed: parseInt(row.confirmed) || 0,
      cancelled: parseInt(row.cancelled) || 0,
      noShow: parseInt(row.no_show) || 0,
    };
  }

  private async getRevenue(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT COALESCE(SUM(pay.amount), 0) AS revenue
      FROM payments pay
      JOIN bookings b ON pay.booking_id = b.id
      WHERE b.product_id IN ${PARTNER_PRODUCTS_SUBQUERY}
        AND pay.payment_status IN ('PAID', 'DEPOSITED')
        AND pay.paid_at BETWEEN $2 AND $3`,
      [partnerId, start, end],
    );
    return parseFloat(result[0]?.revenue) || 0;
  }

  private async getReviewStats(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<{ avgRating: number; count: number }> {
    const result = await this.dataSource.query(
      `SELECT
        COALESCE(AVG(tr.rating), 0) AS avg_rating,
        COUNT(*)                     AS review_count
      FROM product_treatment_reviews tr
      JOIN bookings b ON tr.appointment_id = b.id
      WHERE b.product_id IN ${PARTNER_PRODUCTS_SUBQUERY}
        AND tr.created_at BETWEEN $2 AND $3`,
      [partnerId, start, end],
    );
    const row = result[0] || {};
    return {
      avgRating:
        Math.round((parseFloat(row.avg_rating) || 0) * 10) / 10,
      count: parseInt(row.review_count) || 0,
    };
  }

  private async getDelayedBookings(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT COUNT(*) AS delayed_count
      FROM bookings b
      JOIN product_definitions pd
        ON pd.product_id = b.product_id
      WHERE b.product_id IN ${PARTNER_PRODUCTS_SUBQUERY}
        AND b.start_time BETWEEN $2 AND $3
        AND b.status = 'COMPLETED'
        AND b.end_time IS NOT NULL
        AND b.end_time > (
          b.start_time
          + INTERVAL '1 minute'
            * (pd.duration_minutes + 15)
        )
        AND b.deleted_at IS NULL`,
      [partnerId, start, end],
    );
    return parseInt(result[0]?.delayed_count) || 0;
  }

  private async getTrendData(
    partnerId: string,
    period: DashboardTimePeriod,
    start: Date,
    end: Date,
  ): Promise<AnalyticsTrendPointDto[]> {
    const granularity = resolveGranularity(period);

    const rows: { bucket: Date; bookings: string; revenue: string }[] =
      await this.dataSource.query(
        `SELECT
          date_trunc($1, b.start_time)             AS bucket,
          COUNT(*) FILTER (
            WHERE b.status = 'COMPLETED')          AS bookings,
          COALESCE(SUM(
            CASE WHEN pay.payment_status
              IN ('PAID', 'DEPOSITED')
              THEN pay.amount ELSE 0 END
          ), 0)                                    AS revenue
        FROM bookings b
        LEFT JOIN payments pay ON pay.booking_id = b.id
        WHERE b.product_id IN (SELECT id FROM products WHERE partner_id = $2 AND deleted_at IS NULL)
          AND b.start_time BETWEEN $3 AND $4
          AND b.deleted_at IS NULL
        GROUP BY bucket
        ORDER BY bucket ASC`,
        [granularity, partnerId, start, end],
      );

    // Build map of existing buckets
    const revenueMap = new Map<string, {
      bookings: number;
      revenue: number;
    }>();
    for (const row of rows) {
      const key = new Date(row.bucket).toISOString();
      revenueMap.set(key, {
        bookings: parseInt(row.bookings) || 0,
        revenue: parseFloat(row.revenue) || 0,
      });
    }

    // Generate complete time series and zero-fill
    const allBuckets = this.generateTimeBuckets(
      start, end, granularity,
    );

    return allBuckets.map((bucketDate) => {
      const key = bucketDate.toISOString();
      const data = revenueMap.get(key);
      const dto = new AnalyticsTrendPointDto();
      dto.label = this.formatBucketLabel(bucketDate, period);
      dto.bookings = data?.bookings ?? 0;
      dto.revenue = data?.revenue ?? 0;
      return dto;
    });
  }

  private async getCategoryPerformance(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<AnalyticsCategoryPerformanceDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        c.name                                    AS category_name,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')           AS bookings,
        COALESCE(SUM(
          CASE WHEN pay.payment_status
            IN ('PAID', 'DEPOSITED')
            THEN pay.amount ELSE 0 END
        ), 0)                                     AS revenue,
        COALESCE(AVG(tr.rating), 0)               AS avg_rating
      FROM products p
      JOIN categories c ON c.id = p.category_id
      LEFT JOIN bookings b ON b.product_id = p.id
          AND b.start_time BETWEEN $2 AND $3
          AND b.deleted_at IS NULL
      LEFT JOIN payments pay ON pay.booking_id = b.id
      LEFT JOIN product_treatment_reviews tr
          ON tr.appointment_id = b.id
      WHERE p.partner_id = $1
        AND p.deleted_at IS NULL
      GROUP BY c.id, c.name
      ORDER BY revenue DESC`,
      [partnerId, start, end],
    );

    return rows.map((row: any) => {
      const dto = new AnalyticsCategoryPerformanceDto();
      dto.categoryName = row.category_name;
      dto.bookings = parseInt(row.bookings) || 0;
      dto.revenue = parseFloat(row.revenue) || 0;
      dto.averageRating =
        Math.round((parseFloat(row.avg_rating) || 0) * 10) / 10;
      return dto;
    });
  }

  private async getTopServices(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<AnalyticsServicePerformanceDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        p.name                                    AS service_name,
        COALESCE(c.name, 'Uncategorized')         AS category_name,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')           AS bookings,
        COALESCE(SUM(
          CASE WHEN pay.payment_status
            IN ('PAID', 'DEPOSITED')
            THEN pay.amount ELSE 0 END
        ), 0)                                     AS revenue,
        COALESCE(AVG(tr.rating), 0)               AS avg_rating
      FROM products p
      LEFT JOIN categories c ON c.id = p.category_id
      LEFT JOIN bookings b ON b.product_id = p.id
          AND b.start_time BETWEEN $2 AND $3
          AND b.deleted_at IS NULL
      LEFT JOIN payments pay ON pay.booking_id = b.id
      LEFT JOIN product_treatment_reviews tr
          ON tr.appointment_id = b.id
      WHERE p.partner_id = $1
        AND p.deleted_at IS NULL
        AND p.status = 'active'
      GROUP BY p.id, p.name, c.name
      ORDER BY revenue DESC
      LIMIT 5`,
      [partnerId, start, end],
    );

    return rows.map((row: any) => {
      const dto = new AnalyticsServicePerformanceDto();
      dto.name = row.service_name;
      dto.categoryName = row.category_name;
      dto.bookings = parseInt(row.bookings) || 0;
      dto.revenue = parseFloat(row.revenue) || 0;
      dto.averageRating =
        Math.round((parseFloat(row.avg_rating) || 0) * 10) / 10;
      return dto;
    });
  }

  // ── Helpers ────────────────────────────────────────

  private buildBookingMetrics(
    stats: {
      total: number;
      completed: number;
      pending: number;
      confirmed: number;
      cancelled: number;
      noShow: number;
    },
    delayed: number,
  ): AnalyticsBookingMetricsDto {
    const dto = new AnalyticsBookingMetricsDto();
    dto.totalBookings = stats.total;
    dto.delayedBookings = delayed;
    dto.delayThresholdMinutes = 15;
    dto.pendingBookings = stats.pending;
    dto.completedBookings = stats.completed;

    // Status breakdown (only include non-zero)
    const rawBreakdown: BookingStatusBreakdownDto[] = [
      {
        statusKey: 'confirmed',
        label: 'Confirmed',
        count: stats.confirmed,
      },
      {
        statusKey: 'cancelled',
        label: 'Cancelled',
        count: stats.cancelled,
      },
      {
        statusKey: 'no_show',
        label: 'No-show',
        count: stats.noShow,
      },
    ];
    dto.statusBreakdown = rawBreakdown.filter(
      (item) => item.count > 0,
    );

    // Alerts
    const alerts: AnalyticsAlertDto[] = [];
    if (delayed > 0) {
      const alert = new AnalyticsAlertDto();
      alert.title = 'Delayed bookings need intervention';
      alert.detail =
        `${delayed} bookings are running more than ` +
        `15 minutes behind schedule.`;
      alert.tone = 'critical';
      alerts.push(alert);
    }
    if (
      stats.pending > Math.max(6, Math.floor(stats.total / 8))
    ) {
      const alert = new AnalyticsAlertDto();
      alert.title =
        'Pending bookings are awaiting confirmation';
      alert.detail =
        `${stats.pending} bookings are still in the ` +
        `approval queue for this period.`;
      alert.tone = 'warning';
      alerts.push(alert);
    }
    const cancellationRisk = stats.cancelled + stats.noShow;
    if (
      cancellationRisk >
      Math.max(4, Math.floor(stats.total / 12))
    ) {
      const alert = new AnalyticsAlertDto();
      alert.title =
        'Cancellation and no-show risk is elevated';
      alert.detail =
        'Review reminder flows and staffing handoffs ' +
        'to protect the booking pipeline.';
      alert.tone = 'warning';
      alerts.push(alert);
    }
    dto.alerts = alerts;

    return dto;
  }

  /** Computes % change between current and previous values. */
  private delta(current: number, previous: number): number {
    if (previous <= 0) return 0;
    return (
      Math.round(
        ((current - previous) / previous) * 100 * 10,
      ) / 10
    );
  }

  /** Generates a complete series of time buckets. */
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

  /** Formats a bucket date into a human-readable label. */
  private formatBucketLabel(
    date: Date,
    period: DashboardTimePeriod,
  ): string {
    switch (period) {
      case DashboardTimePeriod.TODAY: {
        const hours = date.getHours();
        const suffix = hours >= 12 ? 'PM' : 'AM';
        const display = hours % 12 || 12;
        return `${display}${suffix}`;
      }
      case DashboardTimePeriod.THIS_WEEK: {
        const days = [
          'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
        ];
        return days[date.getDay()];
      }
      case DashboardTimePeriod.THIS_MONTH: {
        const dayOfMonth = date.getDate();
        const weekNum = Math.ceil(dayOfMonth / 7);
        return `Wk ${weekNum}`;
      }
      case DashboardTimePeriod.THIS_QUARTER: {
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        return months[date.getMonth()];
      }
      case DashboardTimePeriod.THIS_YEAR: {
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        return months[date.getMonth()];
      }
    }
  }
}
