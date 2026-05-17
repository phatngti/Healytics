import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';
import {
  resolveDateRange,
  resolveGranularity,
} from '@/dashboard-partner/helpers/date-range.helper';
import { EmployeeOverviewAnalyticsResponseDto } from '../../dto/analytics/employee-overview-analytics.dto';
import { EmployeeTrendPointDto } from '../../dto/analytics/employee-trend-point.dto';
import { EmployeeRoleDistributionDto } from '../../dto/analytics/employee-role-distribution.dto';
import { EmployeePerformanceSummaryDto } from '../../dto/analytics/employee-performance-summary.dto';
import { EmployeeComplianceItemDto } from '../../dto/analytics/employee-compliance-item.dto';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { EmployeeStatus } from '../../enum/employee-status.enum';

@Injectable()
export class GetEmployeeOverviewAnalyticsHandler {
  private readonly logger = new Logger(
    GetEmployeeOverviewAnalyticsHandler.name,
  );

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    period: DashboardTimePeriod,
  ): Promise<EmployeeOverviewAnalyticsResponseDto> {
    this.logger.log(
      `Getting employee overview analytics for partner: ${partnerId}, ` +
        `period: ${period}`,
    );

    const { startDate, endDate, prevStartDate, prevEndDate } =
      resolveDateRange(period);

    const [
      rosterStats,
      currentWorkload,
      previousWorkload,
      currentReviews,
      previousReviews,
      trendRows,
      roleDistribution,
      topPerformers,
      complianceStats,
    ] = await Promise.all([
      this.getRosterStats(partnerId),
      this.getWorkload(partnerId, startDate, endDate),
      this.getWorkload(partnerId, prevStartDate, prevEndDate),
      this.getReviewStats(partnerId, startDate, endDate),
      this.getReviewStats(partnerId, prevStartDate, prevEndDate),
      this.getTrendData(partnerId, period, startDate, endDate),
      this.getRoleDistribution(partnerId),
      this.getTopPerformers(partnerId, startDate, endDate),
      this.getComplianceStats(partnerId),
    ]);

    // Compute utilization from schedule
    const availableHours = await this.getAvailableHours(
      partnerId,
      startDate,
      endDate,
    );
    const prevAvailableHours = await this.getAvailableHours(
      partnerId,
      prevStartDate,
      prevEndDate,
    );

    const utilizationRate =
      availableHours > 0
        ? this.round1(
            (currentWorkload.bookedHours / availableHours) * 100,
          )
        : 0;
    const prevUtilization =
      prevAvailableHours > 0
        ? (previousWorkload.bookedHours / prevAvailableHours) * 100
        : 0;

    const dto = new EmployeeOverviewAnalyticsResponseDto();

    // ── Roster KPIs ───────────────────────────────
    dto.totalEmployees = rosterStats.total;
    dto.activeEmployees = rosterStats.active;
    dto.onLeaveEmployees = rosterStats.onLeave;
    dto.inactiveEmployees = rosterStats.inactive;

    // ── Utilization KPIs ──────────────────────────
    dto.utilizationRate = utilizationRate;
    dto.utilizationDelta = this.delta(utilizationRate, prevUtilization);

    // ── Rating KPIs ───────────────────────────────
    dto.averageRating = currentReviews.avgRating;
    dto.ratingDelta = this.delta(
      currentReviews.avgRating,
      previousReviews.avgRating,
    );
    dto.reviewCount = currentReviews.count;

    // ── Trend ─────────────────────────────────────
    dto.trendPoints = trendRows;

    // ── Role Distribution ─────────────────────────
    dto.roleDistribution = roleDistribution;

    // ── Top Performers ────────────────────────────
    dto.topPerformers = topPerformers;

    // ── Compliance ────────────────────────────────
    dto.complianceItems = this.buildComplianceItems(complianceStats);

    return dto;
  }

  // ── Private query methods ──────────────────────────

  private async getRosterStats(
    partnerId: string,
  ): Promise<{
    total: number;
    active: number;
    onLeave: number;
    inactive: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*) AS total,
        COUNT(*) FILTER (WHERE status = '${EmployeeStatus.ACTIVE}') AS active,
        COUNT(*) FILTER (WHERE status = '${EmployeeStatus.ON_LEAVE}') AS on_leave,
        COUNT(*) FILTER (WHERE status = '${EmployeeStatus.INACTIVE}') AS inactive
      FROM employees
      WHERE partner_id = $1
        AND deleted_at IS NULL`,
      [partnerId],
    );
    const row = result[0] || {};
    return {
      total: parseInt(row.total) || 0,
      active: parseInt(row.active) || 0,
      onLeave: parseInt(row.on_leave) || 0,
      inactive: parseInt(row.inactive) || 0,
    };
  }

  private async getWorkload(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<{
    completedSessions: number;
    contributionValue: number;
    bookedHours: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*) FILTER (
          WHERE b.status = '${BookingStatus.COMPLETED}'
        ) AS completed_sessions,
        COALESCE(SUM(
          CASE WHEN pay.payment_status IN ('${PaymentStatus.PAID}', '${PaymentStatus.DEPOSITED}')
               THEN pay.amount ELSE 0 END
        ), 0) AS contribution_value,
        COALESCE(SUM(
          EXTRACT(EPOCH FROM (
            COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
          )) / 3600
        ) FILTER (
          WHERE b.status IN (
            '${BookingStatus.COMPLETED}',
            '${BookingStatus.CONFIRMED}',
            '${BookingStatus.PENDING_PAYMENT}'
          )
        ), 0) AS booked_hours
      FROM employees e
      LEFT JOIN bookings b
        ON b.staff_id = e.id
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL
        AND b.status IN (
          '${BookingStatus.COMPLETED}',
          '${BookingStatus.CONFIRMED}',
          '${BookingStatus.PENDING_PAYMENT}'
        )
      LEFT JOIN payments pay
        ON pay.booking_id = b.id
        AND pay.deleted_at IS NULL
      WHERE e.partner_id = $1
        AND e.deleted_at IS NULL`,
      [partnerId, start, end],
    );
    const row = result[0] || {};
    return {
      completedSessions: parseInt(row.completed_sessions) || 0,
      contributionValue: parseFloat(row.contribution_value) || 0,
      bookedHours: parseFloat(row.booked_hours) || 0,
    };
  }

  private async getReviewStats(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<{ avgRating: number; count: number }> {
    const result = await this.dataSource.query(
      `SELECT
        COALESCE(AVG(sr.rating), 0) AS avg_rating,
        COUNT(*) AS review_count
      FROM specialist_reviews sr
      JOIN employees e ON e.id = sr.specialist_id
      WHERE e.partner_id = $1
        AND e.deleted_at IS NULL
        AND sr.created_at BETWEEN $2 AND $3`,
      [partnerId, start, end],
    );
    const row = result[0] || {};
    return {
      avgRating:
        Math.round((parseFloat(row.avg_rating) || 0) * 10) / 10,
      count: parseInt(row.review_count) || 0,
    };
  }

  private async getTrendData(
    partnerId: string,
    period: DashboardTimePeriod,
    start: Date,
    end: Date,
  ): Promise<EmployeeTrendPointDto[]> {
    const granularity = resolveGranularity(period);

    const rows: {
      bucket: Date;
      sessions: string;
      contribution_value: string;
    }[] = await this.dataSource.query(
      `SELECT
        date_trunc($1, b.start_time) AS bucket,
        COUNT(*) FILTER (
          WHERE b.status = '${BookingStatus.COMPLETED}'
        ) AS sessions,
        COALESCE(SUM(
          CASE WHEN pay.payment_status
            IN ('${PaymentStatus.PAID}', '${PaymentStatus.DEPOSITED}')
            THEN pay.amount ELSE 0 END
        ), 0) AS contribution_value
      FROM bookings b
      JOIN employees e ON e.id = b.staff_id
      LEFT JOIN payments pay ON pay.booking_id = b.id
        AND pay.deleted_at IS NULL
      WHERE e.partner_id = $2
        AND e.deleted_at IS NULL
        AND b.start_time BETWEEN $3 AND $4
        AND b.deleted_at IS NULL
      GROUP BY bucket
      ORDER BY bucket ASC`,
      [granularity, partnerId, start, end],
    );

    if (period === DashboardTimePeriod.THIS_MONTH) {
      const aggregated = [
        { label: 'Wk 1', sessions: 0, contributionValue: 0 },
        { label: 'Wk 2', sessions: 0, contributionValue: 0 },
        { label: 'Wk 3', sessions: 0, contributionValue: 0 },
        { label: 'Wk 4', sessions: 0, contributionValue: 0 },
      ];
      for (const row of rows) {
        const d = new Date(row.bucket);
        const dayOfMonth = d.getDate();
        const weekIndex = Math.min(
          Math.ceil(dayOfMonth / 7) - 1,
          3,
        );
        aggregated[weekIndex].sessions +=
          parseInt(row.sessions) || 0;
        aggregated[weekIndex].contributionValue +=
          parseFloat(row.contribution_value) || 0;
      }
      return aggregated.map((a) => {
        const dto = new EmployeeTrendPointDto();
        dto.label = a.label;
        dto.sessions = a.sessions;
        dto.contributionValue = a.contributionValue;
        return dto;
      });
    }

    // Build granularity-aware key
    const bucketKey = (d: Date): string => {
      if (granularity === 'month') {
        return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
      }
      if (granularity === 'day' || granularity === 'week') {
        return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
      }
      return d.toISOString();
    };

    const sqlBucketKey = (bucket: Date): string => {
      const d = new Date(bucket);
      if (granularity === 'month') {
        return `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}`;
      }
      if (granularity === 'day' || granularity === 'week') {
        return `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}-${String(d.getUTCDate()).padStart(2, '0')}`;
      }
      return d.toISOString();
    };

    // Build map of existing buckets
    const dataMap = new Map<
      string,
      { sessions: number; contributionValue: number }
    >();
    for (const row of rows) {
      const key = sqlBucketKey(row.bucket);
      dataMap.set(key, {
        sessions: parseInt(row.sessions) || 0,
        contributionValue:
          parseFloat(row.contribution_value) || 0,
      });
    }

    // Generate complete time series with zero-fill
    const allBuckets = this.generateTimeBuckets(
      start,
      end,
      granularity,
    );

    return allBuckets.map((bucketDate) => {
      const key = bucketKey(bucketDate);
      const data = dataMap.get(key);
      const dto = new EmployeeTrendPointDto();
      dto.label = this.formatBucketLabel(bucketDate, period);
      dto.sessions = data?.sessions ?? 0;
      dto.contributionValue = data?.contributionValue ?? 0;
      return dto;
    });
  }

  private async getRoleDistribution(
    partnerId: string,
  ): Promise<EmployeeRoleDistributionDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        e.role,
        tp.type AS therapist_type,
        COUNT(*) AS count
      FROM employees e
      LEFT JOIN therapist_profiles tp ON tp.employee_id = e.id
      WHERE e.partner_id = $1
        AND e.deleted_at IS NULL
      GROUP BY e.role, tp.type
      ORDER BY count DESC`,
      [partnerId],
    );

    return rows.map((row: any) => {
      const dto = new EmployeeRoleDistributionDto();
      dto.role = this.mapRoleLabel(row.role, row.therapist_type);
      dto.count = parseInt(row.count) || 0;
      return dto;
    });
  }

  private async getTopPerformers(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<EmployeePerformanceSummaryDto[]> {
    // Load all employees with pre-aggregated workload and review stats.
    const rows = await this.dataSource.query(
      `WITH booking_stats AS (
        SELECT
          e.id AS employee_id,
          COUNT(*) FILTER (
            WHERE b.status = '${BookingStatus.COMPLETED}'
          ) AS completed_sessions,
          COALESCE(SUM(
            CASE WHEN pay.payment_status IN ('${PaymentStatus.PAID}', '${PaymentStatus.DEPOSITED}')
                 THEN pay.amount ELSE 0 END
          ), 0) AS contribution_value,
          COALESCE(SUM(
            EXTRACT(EPOCH FROM (
              COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
            )) / 3600
          ) FILTER (
            WHERE b.status IN (
              '${BookingStatus.COMPLETED}',
              '${BookingStatus.CONFIRMED}',
              '${BookingStatus.PENDING_PAYMENT}'
            )
          ), 0) AS booked_hours
        FROM employees e
        LEFT JOIN bookings b
          ON b.staff_id = e.id
          AND b.start_time BETWEEN $2 AND $3
          AND b.deleted_at IS NULL
          AND b.status IN (
            '${BookingStatus.COMPLETED}',
            '${BookingStatus.CONFIRMED}',
            '${BookingStatus.PENDING_PAYMENT}'
          )
        LEFT JOIN payments pay
          ON pay.booking_id = b.id
          AND pay.deleted_at IS NULL
        WHERE e.partner_id = $1
          AND e.deleted_at IS NULL
        GROUP BY e.id
      ),
      review_stats AS (
        SELECT
          sr.specialist_id AS employee_id,
          COALESCE(AVG(sr.rating), 0) AS avg_rating
        FROM specialist_reviews sr
        INNER JOIN employees e
          ON e.id = sr.specialist_id
          AND e.partner_id = $1
          AND e.deleted_at IS NULL
        WHERE sr.created_at BETWEEN $2 AND $3
        GROUP BY sr.specialist_id
      )
      SELECT
        e.id,
        e.full_name,
        e.role,
        e.schedule,
        e.rating AS cached_rating,
        e.review_count AS cached_review_count,
        tp.type AS therapist_type,
        COALESCE(bs.completed_sessions, 0) AS completed_sessions,
        COALESCE(bs.contribution_value, 0) AS contribution_value,
        COALESCE(bs.booked_hours, 0) AS booked_hours,
        COALESCE(rs.avg_rating, 0) AS avg_rating
      FROM employees e
      LEFT JOIN therapist_profiles tp ON tp.employee_id = e.id
      LEFT JOIN booking_stats bs ON bs.employee_id = e.id
      LEFT JOIN review_stats rs ON rs.employee_id = e.id
      WHERE e.partner_id = $1
        AND e.deleted_at IS NULL`,
      [partnerId, start, end],
    );

    if (rows.length === 0) return [];

    // Compute scores
    const maxContribution = Math.max(
      ...rows.map(
        (r: any) => parseFloat(r.contribution_value) || 0,
      ),
      1,
    );

    const scored = rows.map((row: any) => {
      const rating = parseFloat(row.avg_rating) || parseFloat(row.cached_rating) || 0;
      const contribution = parseFloat(row.contribution_value) || 0;
      const bookedHours = parseFloat(row.booked_hours) || 0;
      const schedule = row.schedule || [];
      const weeklyAvailable = this.computeWeeklyAvailableHours(schedule);
      const periodWeeks = this.countWeeksInPeriod(start, end);
      const totalAvailable = weeklyAvailable * periodWeeks;
      const utilization =
        totalAvailable > 0
          ? Math.min((bookedHours / totalAvailable) * 100, 100)
          : 0;

      const ratingScore = rating / 5;
      const utilizationScore = Math.min(utilization, 100) / 100;
      const contributionScore = contribution / maxContribution;
      const compositeScore =
        ratingScore * 0.45 +
        utilizationScore * 0.3 +
        contributionScore * 0.25;

      return {
        fullName: row.full_name,
        role: row.role,
        therapistType: row.therapist_type,
        rating: this.round1(rating),
        utilizationRate: this.round1(utilization),
        contributionValue: contribution,
        compositeScore,
      };
    });

    // Sort by composite score descending, take top 4
    scored.sort(
      (a: any, b: any) => b.compositeScore - a.compositeScore,
    );

    return scored.slice(0, 4).map((item: any) => {
      const dto = new EmployeePerformanceSummaryDto();
      dto.employeeName = item.fullName;
      dto.roleLabel = this.mapRoleLabel(
        item.role,
        item.therapistType,
      );
      dto.rating = item.rating;
      dto.utilizationRate = item.utilizationRate;
      dto.contributionValue = item.contributionValue;
      return dto;
    });
  }

  private async getComplianceStats(
    partnerId: string,
  ): Promise<{
    missingDocs: number;
    missingEmergency: number;
    active: number;
    total: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*) FILTER (
          WHERE verification_documents IS NULL
             OR jsonb_array_length(COALESCE(verification_documents, '[]'::jsonb)) = 0
        ) AS missing_docs,
        COUNT(*) FILTER (
          WHERE emergency_contact_phone IS NULL
             OR btrim(emergency_contact_phone) = ''
        ) AS missing_emergency,
        COUNT(*) FILTER (WHERE status = '${EmployeeStatus.ACTIVE}') AS active,
        COUNT(*) AS total
      FROM employees
      WHERE partner_id = $1
        AND deleted_at IS NULL`,
      [partnerId],
    );
    const row = result[0] || {};
    return {
      missingDocs: parseInt(row.missing_docs) || 0,
      missingEmergency: parseInt(row.missing_emergency) || 0,
      active: parseInt(row.active) || 0,
      total: parseInt(row.total) || 0,
    };
  }

  private async getAvailableHours(
    partnerId: string,
    start: Date,
    end: Date,
  ): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT id, schedule
      FROM employees
      WHERE partner_id = $1
        AND deleted_at IS NULL
        AND status = '${EmployeeStatus.ACTIVE}'`,
      [partnerId],
    );

    let totalAvailable = 0;
    for (const row of result) {
      const schedule = row.schedule || [];
      const weeklyHours =
        this.computeWeeklyAvailableHours(schedule);
      const periodWeeks = this.countWeeksInPeriod(start, end);
      totalAvailable += weeklyHours * periodWeeks;
    }
    return totalAvailable;
  }

  // ── Compliance builder ────────────────────────────

  private buildComplianceItems(stats: {
    missingDocs: number;
    missingEmergency: number;
    active: number;
    total: number;
  }): EmployeeComplianceItemDto[] {
    const items: EmployeeComplianceItemDto[] = [];

    // 1. Verification coverage
    const docItem = new EmployeeComplianceItemDto();
    docItem.title = 'Verification coverage';
    if (stats.missingDocs === 0) {
      docItem.detail =
        'All visible profiles have supporting documents.';
      docItem.tone = 'positive';
    } else {
      docItem.detail =
        `${stats.missingDocs} employee(s) are missing verification documents.`;
      docItem.tone = 'warning';
    }
    items.push(docItem);

    // 2. Emergency readiness
    const emergencyItem = new EmployeeComplianceItemDto();
    emergencyItem.title = 'Emergency readiness';
    if (stats.missingEmergency === 0) {
      emergencyItem.detail =
        'All employees have emergency contact information on file.';
      emergencyItem.tone = 'positive';
    } else {
      emergencyItem.detail =
        `${stats.missingEmergency} employee(s) are missing emergency contact information.`;
      emergencyItem.tone = 'critical';
    }
    items.push(emergencyItem);

    // 3. Active roster readiness
    const rosterItem = new EmployeeComplianceItemDto();
    rosterItem.title = 'Active roster readiness';
    const activeRate =
      stats.total > 0 ? (stats.active / stats.total) * 100 : 0;
    if (activeRate >= 80) {
      rosterItem.detail =
        `${stats.active} of ${stats.total} employees are active (${Math.round(activeRate)}%).`;
      rosterItem.tone = 'positive';
    } else if (activeRate >= 50) {
      rosterItem.detail =
        `Only ${stats.active} of ${stats.total} employees are active (${Math.round(activeRate)}%).`;
      rosterItem.tone = 'warning';
    } else {
      rosterItem.detail =
        `Only ${stats.active} of ${stats.total} employees are active (${Math.round(activeRate)}%).`;
      rosterItem.tone = 'critical';
    }
    items.push(rosterItem);

    return items;
  }

  // ── Helpers ────────────────────────────────────────

  private mapRoleLabel(
    role: string,
    therapistType?: string | null,
  ): string {
    if (role === 'DOCTOR') return 'Doctor';
    if (role === 'THERAPIST') {
      if (therapistType === 'SPA') return 'Spa therapist';
      if (therapistType === 'MASSAGE')
        return 'Massage therapist';
      return 'Therapist';
    }
    if (role === 'RECEPTIONIST') return 'Receptionist';
    if (role === 'MANAGER') return 'Manager';
    return role;
  }

  private computeWeeklyAvailableHours(
    schedule: {
      day: string;
      start: string;
      end: string;
      isWorking: boolean;
    }[],
  ): number {
    let total = 0;
    for (const entry of schedule) {
      if (!entry.isWorking || !entry.start || !entry.end)
        continue;
      const [sh, sm] = entry.start.split(':').map(Number);
      const [eh, em] = entry.end.split(':').map(Number);
      const hours = (eh * 60 + em - (sh * 60 + sm)) / 60;
      if (hours > 0) total += hours;
    }
    return total;
  }

  private countWeeksInPeriod(start: Date, end: Date): number {
    const msPerWeek = 7 * 24 * 60 * 60 * 1000;
    const durationMs = end.getTime() - start.getTime();
    return Math.max(Math.ceil(durationMs / msPerWeek), 1);
  }

  /** Computes % change between current and previous values. */
  private delta(current: number, previous: number): number {
    if (previous <= 0) return current > 0 ? 100 : 0;
    return (
      Math.round(
        ((current - previous) / previous) * 100 * 10,
      ) / 10
    );
  }

  /** Rounds to one decimal place. */
  private round1(value: number): number {
    return Math.round(value * 10) / 10;
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
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

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
      case DashboardTimePeriod.THIS_MONTH:
        return ''; // Handled manually in getTrendData
      case DashboardTimePeriod.THIS_QUARTER:
      case DashboardTimePeriod.THIS_YEAR: {
        return months[date.getMonth()];
      }
    }
  }
}
