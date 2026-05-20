import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';
import {
  resolveDateRange,
  resolveGranularity,
} from '@/dashboard-partner/helpers/date-range.helper';
import { HealthServiceDetailAnalyticsResponseDto } from '../../dto/partner/analytics/health-service-detail-analytics.dto';
import { AnalyticsTrendPointDto } from '../../dto/partner/analytics/analytics-trend-point.dto';
import { AnalyticsReviewBucketDto } from '../../dto/partner/analytics/analytics-review-bucket.dto';
import { AnalyticsOperationalMetricDto } from '../../dto/partner/analytics/analytics-operational-metric.dto';
import { AnalyticsServicePerformanceDto } from '../../dto/partner/analytics/analytics-service-performance.dto';
import { AnalyticsAlertDto } from '../../dto/partner/analytics/analytics-alert.dto';

@Injectable()
export class GetDetailAnalyticsHandler {
  private readonly logger = new Logger(
    GetDetailAnalyticsHandler.name,
  );

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    productId: string,
    period: DashboardTimePeriod,
  ): Promise<HealthServiceDetailAnalyticsResponseDto> {
    this.logger.log(
      `Getting detail analytics for product: ${productId}, ` +
      `partner: ${partnerId}, period: ${period}`,
    );

    // Verify product belongs to partner
    const product = await this.loadProduct(
      partnerId, productId,
    );

    const { startDate, endDate, prevStartDate, prevEndDate } =
      resolveDateRange(period);

    const [
      currentBookings,
      previousBookings,
      currentRevenue,
      previousRevenue,
      reviewDistribution,
      eligibilityCount,
      trendRows,
      peerRows,
    ] = await Promise.all([
      this.getBookingStats(productId, startDate, endDate),
      this.getBookingStats(
        productId, prevStartDate, prevEndDate,
      ),
      this.getRevenue(productId, startDate, endDate),
      this.getRevenue(productId, prevStartDate, prevEndDate),
      this.getReviewDistribution(productId),
      this.getEligibleStaffCount(productId),
      this.getTrendData(
        productId, partnerId, period, startDate, endDate,
      ),
      this.getPeerRanking(
        partnerId, startDate, endDate,
      ),
    ]);

    const dto = new HealthServiceDetailAnalyticsResponseDto();
    dto.productId = productId;

    // ── KPIs ───────────────────────────────────────
    dto.bookings = currentBookings.completed;
    dto.bookingsDelta = this.delta(
      currentBookings.completed,
      previousBookings.completed,
    );
    dto.revenue = currentRevenue;
    dto.revenueDelta = this.delta(
      currentRevenue, previousRevenue,
    );

    const currentCompletionRate = currentBookings.total > 0
      ? (currentBookings.completed / currentBookings.total) * 100
      : 0;
    const previousCompletionRate = previousBookings.total > 0
      ? (previousBookings.completed / previousBookings.total)
        * 100
      : 0;
    dto.completionRate =
      Math.round(currentCompletionRate * 10) / 10;
    dto.completionRateDelta = this.delta(
      currentCompletionRate,
      previousCompletionRate,
    );

    const totalReviews = reviewDistribution.reduce(
      (sum, bucket) => sum + bucket.count, 0,
    );
    const ratingSum = reviewDistribution.reduce(
      (sum, bucket) => sum + bucket.stars * bucket.count, 0,
    );
    dto.averageRating = totalReviews > 0
      ? Math.round((ratingSum / totalReviews) * 10) / 10
      : 0;
    dto.reviewCount = totalReviews;

    // ── Trend ──────────────────────────────────────
    dto.trendPoints = trendRows;

    // ── Review Distribution ────────────────────────
    dto.reviewDistribution = reviewDistribution;

    // ── Operational Readiness ──────────────────────
    dto.operationalMetrics = this.buildOperationalMetrics(
      product, eligibilityCount,
    );

    // ── Peer Ranking ───────────────────────────────
    dto.peerRanking = peerRows;

    // ── Alerts ─────────────────────────────────────
    dto.alerts = this.buildAlerts(
      product, eligibilityCount,
    );

    return dto;
  }

  // ── Private query methods ──────────────────────────

  private async loadProduct(
    partnerId: string,
    productId: string,
  ): Promise<ProductRow> {
    const rows = await this.dataSource.query(
      `SELECT
        p.id,
        p.name,
        p.status,
        p.is_visible_online,
        p.description,
        p.service_manual,
        pd.duration_minutes,
        pd.buffer_minutes,
        pd.max_capacity,
        pd.min_lead_time_hours,
        pd.staff_assignment_type,
        (SELECT COUNT(*) FROM product_media pm
         WHERE pm.product_id = p.id) AS media_count
      FROM products p
      LEFT JOIN product_definitions pd
        ON pd.product_id = p.id
      WHERE p.id = $1
        AND p.partner_id = $2
        AND p.deleted_at IS NULL`,
      [productId, partnerId],
    );

    if (!rows.length) {
      throw new NotFoundException(
        `Product ${productId} not found for this partner`,
      );
    }

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      status: row.status,
      isVisibleOnline: row.is_visible_online,
      description: row.description,
      serviceManual: row.service_manual,
      durationMinutes: parseInt(row.duration_minutes) || 0,
      bufferMinutes: parseInt(row.buffer_minutes) || 0,
      maxCapacity: parseInt(row.max_capacity) || 1,
      minLeadTimeHours:
        parseInt(row.min_lead_time_hours) || 0,
      staffAssignmentType:
        row.staff_assignment_type || 'any',
      mediaCount: parseInt(row.media_count) || 0,
    };
  }

  private async getBookingStats(
    productId: string,
    start: Date,
    end: Date,
  ): Promise<{ total: number; completed: number }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                   AS total,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')            AS completed
      FROM bookings b
      WHERE b.product_id = $1
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL`,
      [productId, start, end],
    );
    const row = result[0] || {};
    return {
      total: parseInt(row.total) || 0,
      completed: parseInt(row.completed) || 0,
    };
  }

  private async getRevenue(
    productId: string,
    start: Date,
    end: Date,
  ): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT COALESCE(SUM(pay.amount), 0) AS revenue
      FROM payments pay
      JOIN bookings b ON pay.booking_id = b.id
      WHERE b.product_id = $1
        AND pay.payment_status IN ('PAID', 'DEPOSITED')
        AND pay.paid_at BETWEEN $2 AND $3`,
      [productId, start, end],
    );
    return parseFloat(result[0]?.revenue) || 0;
  }

  private async getReviewDistribution(
    productId: string,
  ): Promise<AnalyticsReviewBucketDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        tr.rating AS stars,
        COUNT(*)  AS count
      FROM product_treatment_reviews tr
      JOIN bookings b ON tr.appointment_id = b.id
      WHERE b.product_id = $1
      GROUP BY tr.rating
      ORDER BY tr.rating DESC`,
      [productId],
    );

    // Ensure all 5 star levels are present
    const bucketMap = new Map<number, number>();
    for (const row of rows) {
      bucketMap.set(
        parseInt(row.stars),
        parseInt(row.count) || 0,
      );
    }

    return [5, 4, 3, 2, 1].map((stars) => {
      const dto = new AnalyticsReviewBucketDto();
      dto.stars = stars;
      dto.count = bucketMap.get(stars) ?? 0;
      return dto;
    });
  }

  private async getEligibleStaffCount(
    productId: string,
  ): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT COUNT(*) AS cnt
      FROM product_employee_eligibility
      WHERE product_id = $1`,
      [productId],
    );
    return parseInt(result[0]?.cnt) || 0;
  }

  private async getTrendData(
    productId: string,
    partnerId: string,
    period: DashboardTimePeriod,
    start: Date,
    end: Date,
  ): Promise<AnalyticsTrendPointDto[]> {
    const granularity = resolveGranularity(period);

    const rows: {
      bucket: Date;
      bookings: string;
      revenue: string;
    }[] = await this.dataSource.query(
      `SELECT
        date_trunc($1, b.start_time)            AS bucket,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')         AS bookings,
        COALESCE(SUM(
          CASE WHEN pay.payment_status
            IN ('PAID', 'DEPOSITED')
            THEN pay.amount ELSE 0 END
        ), 0)                                   AS revenue
      FROM bookings b
      LEFT JOIN payments pay ON pay.booking_id = b.id
      WHERE b.product_id = $2
        AND b.start_time BETWEEN $3 AND $4
        AND b.deleted_at IS NULL
      GROUP BY bucket
      ORDER BY bucket ASC`,
      [granularity, productId, start, end],
    );

    const dataMap = new Map<string, {
      bookings: number;
      revenue: number;
    }>();
    for (const row of rows) {
      const key = new Date(row.bucket).toISOString();
      dataMap.set(key, {
        bookings: parseInt(row.bookings) || 0,
        revenue: parseFloat(row.revenue) || 0,
      });
    }

    const allBuckets = this.generateTimeBuckets(
      start, end, granularity,
    );

    return allBuckets.map((bucketDate) => {
      const key = bucketDate.toISOString();
      const data = dataMap.get(key);
      const dto = new AnalyticsTrendPointDto();
      dto.label = this.formatBucketLabel(bucketDate, period);
      dto.bookings = data?.bookings ?? 0;
      dto.revenue = data?.revenue ?? 0;
      return dto;
    });
  }

  private async getPeerRanking(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<AnalyticsServicePerformanceDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        p.name                                   AS service_name,
        COALESCE(c.name, 'Uncategorized')        AS category_name,
        COUNT(*) FILTER (
          WHERE b.status = 'COMPLETED')          AS bookings,
        COALESCE(SUM(
          CASE WHEN pay.payment_status
            IN ('PAID', 'DEPOSITED')
            THEN pay.amount ELSE 0 END
        ), 0)                                    AS revenue,
        COALESCE(AVG(tr.rating), 0)              AS avg_rating
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
      ORDER BY avg_rating DESC
      LIMIT 4`,
      [partnerId, start, end],
    );

    return rows.map((row: any) => {
      const dto = new AnalyticsServicePerformanceDto();
      dto.name = row.service_name;
      dto.categoryName = row.category_name;
      dto.bookings = parseInt(row.bookings) || 0;
      dto.revenue = parseFloat(row.revenue) || 0;
      dto.averageRating =
        Math.round(
          (parseFloat(row.avg_rating) || 0) * 10,
        ) / 10;
      return dto;
    });
  }

  // ── Helpers ────────────────────────────────────────

  private buildOperationalMetrics(
    product: ProductRow,
    eligibilityCount: number,
  ): AnalyticsOperationalMetricDto[] {
    const metrics: AnalyticsOperationalMetricDto[] = [];

    // Visibility
    const visibility = new AnalyticsOperationalMetricDto();
    visibility.label = 'Visibility';
    visibility.value = product.isVisibleOnline
      ? 'Public'
      : 'Internal';
    visibility.detail = product.isVisibleOnline
      ? 'Eligible for online discovery'
      : 'Hidden from public booking';
    visibility.tone = product.isVisibleOnline
      ? 'positive'
      : 'warning';
    metrics.push(visibility);

    // Staff coverage
    const staffCoverage = new AnalyticsOperationalMetricDto();
    staffCoverage.label = 'Staff coverage';
    const isSpecific =
      product.staffAssignmentType === 'specific';
    if (isSpecific) {
      staffCoverage.value = `${eligibilityCount} assigned`;
      staffCoverage.detail =
        'Named staff required for fulfillment';
      staffCoverage.tone =
        eligibilityCount === 0 ? 'critical' : 'positive';
    } else {
      staffCoverage.value = 'Flexible';
      staffCoverage.detail =
        'Any qualified employee can deliver';
      staffCoverage.tone = 'positive';
    }
    metrics.push(staffCoverage);

    // Scheduling
    const scheduling = new AnalyticsOperationalMetricDto();
    scheduling.label = 'Scheduling';
    scheduling.value =
      `${product.durationMinutes}m / ` +
      `${product.bufferMinutes}m buffer`;
    scheduling.detail =
      `Capacity ${product.maxCapacity}, ` +
      `lead ${product.minLeadTimeHours}h`;
    scheduling.tone = product.durationMinutes > 0
      ? 'neutral'
      : 'warning';
    metrics.push(scheduling);

    // Content completeness
    const completenessChecks = [
      product.description !== null &&
        product.description !== '',
      product.mediaCount > 0,
      product.serviceManual !== null,
    ];
    const completeness = completenessChecks.filter(
      Boolean,
    ).length;
    const contentMetric = new AnalyticsOperationalMetricDto();
    contentMetric.label = 'Content completeness';
    contentMetric.value = `${completeness} / 3`;
    contentMetric.detail =
      'Description, gallery, and service manual readiness';
    contentMetric.tone = completeness === 3
      ? 'positive'
      : completeness === 2
        ? 'warning'
        : 'critical';
    metrics.push(contentMetric);

    return metrics;
  }

  private buildAlerts(
    product: ProductRow,
    eligibilityCount: number,
  ): AnalyticsAlertDto[] {
    const alerts: AnalyticsAlertDto[] = [];

    if (!product.isVisibleOnline) {
      const alert = new AnalyticsAlertDto();
      alert.title = 'Online visibility disabled';
      alert.detail =
        'This service is hidden from the public ' +
        'booking experience.';
      alert.tone = 'warning';
      alerts.push(alert);
    }

    if (product.serviceManual === null) {
      const alert = new AnalyticsAlertDto();
      alert.title = 'Service manual is incomplete';
      alert.detail =
        'Document treatment steps and ' +
        'contraindications for staff.';
      alert.tone = 'critical';
      alerts.push(alert);
    }

    if (
      product.staffAssignmentType === 'specific' &&
      eligibilityCount === 0
    ) {
      const alert = new AnalyticsAlertDto();
      alert.title = 'No assigned staff';
      alert.detail =
        'Bookings may fail when a service ' +
        'requires named staff.';
      alert.tone = 'critical';
      alerts.push(alert);
    }

    return alerts;
  }

  private delta(current: number, previous: number): number {
    if (previous <= 0) return 0;
    return (
      Math.round(
        ((current - previous) / previous) * 100 * 10,
      ) / 10
    );
  }

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
          'Sun', 'Mon', 'Tue', 'Wed',
          'Thu', 'Fri', 'Sat',
        ];
        return days[date.getDay()];
      }
      case DashboardTimePeriod.THIS_MONTH: {
        const dayOfMonth = date.getDate();
        const weekNum = Math.ceil(dayOfMonth / 7);
        return `Wk ${weekNum}`;
      }
      case DashboardTimePeriod.THIS_QUARTER:
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

/** Internal type for product metadata row. */
interface ProductRow {
  id: string;
  name: string;
  status: string;
  isVisibleOnline: boolean;
  description: string | null;
  serviceManual: unknown | null;
  durationMinutes: number;
  bufferMinutes: number;
  maxCapacity: number;
  minLeadTimeHours: number;
  staffAssignmentType: string;
  mediaCount: number;
}
