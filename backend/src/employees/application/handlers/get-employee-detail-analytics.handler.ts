import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';
import {
  resolveDateRange,
  resolveGranularity,
} from '@/dashboard-partner/helpers/date-range.helper';
import { EmployeeDetailAnalyticsResponseDto } from '../../dto/analytics/employee-detail-analytics.dto';
import { EmployeeTrendPointDto } from '../../dto/analytics/employee-trend-point.dto';
import { EmployeeMixMetricDto } from '../../dto/analytics/employee-mix-metric.dto';
import { EmployeeScheduleLoadDto } from '../../dto/analytics/employee-schedule-load.dto';
import { EmployeeQualityMetricDto } from '../../dto/analytics/employee-quality-metric.dto';
import { EmployeeComplianceItemDto } from '../../dto/analytics/employee-compliance-item.dto';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { EmployeeStatus } from '../../enum/employee-status.enum';

/** ISO weekday number → label */
const ISO_DOW_LABELS: Record<number, string> = {
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

/** Day name used in employee schedule JSONB → ISO weekday number */
const DAY_NAME_TO_ISO: Record<string, number> = {
  Monday: 1,
  Tuesday: 2,
  Wednesday: 3,
  Thursday: 4,
  Friday: 5,
  Saturday: 6,
  Sunday: 7,
};

@Injectable()
export class GetEmployeeDetailAnalyticsHandler {
  private readonly logger = new Logger(
    GetEmployeeDetailAnalyticsHandler.name,
  );

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    employeeId: string,
    period: DashboardTimePeriod,
  ): Promise<EmployeeDetailAnalyticsResponseDto> {
    this.logger.log(
      `Getting detail analytics for employee: ${employeeId}, ` +
        `partner: ${partnerId}, period: ${period}`,
    );

    // 1. Verify ownership + load employee profile
    const employee = await this.loadEmployee(
      employeeId,
      partnerId,
    );

    const { startDate, endDate, prevStartDate, prevEndDate } =
      resolveDateRange(period);

    // 2. Parallel queries
    const [
      currentStats,
      previousStats,
      reviewStats,
      trendRows,
      mixMetrics,
      scheduleLoad,
      recommendStats,
    ] = await Promise.all([
      this.getSessionStats(employeeId, startDate, endDate),
      this.getSessionStats(
        employeeId,
        prevStartDate,
        prevEndDate,
      ),
      this.getReviewStats(employeeId, startDate, endDate),
      this.getTrendData(employeeId, period, startDate, endDate),
      this.getMixMetrics(employeeId, startDate, endDate, employee),
      this.getScheduleLoad(
        employee,
        employeeId,
        startDate,
        endDate,
      ),
      this.getRecommendationStats(
        employeeId,
        startDate,
        endDate,
      ),
    ]);

    // Compute utilization
    const schedule = employee.schedule || [];
    const weeklyHours =
      this.computeWeeklyAvailableHours(schedule);
    const periodWeeks = this.countWeeksInPeriod(
      startDate,
      endDate,
    );
    const availableHours = weeklyHours * periodWeeks;
    const prevPeriodWeeks = this.countWeeksInPeriod(
      prevStartDate,
      prevEndDate,
    );
    const prevAvailableHours = weeklyHours * prevPeriodWeeks;

    const utilizationRate =
      availableHours > 0
        ? this.round1(
            (currentStats.bookedHours / availableHours) * 100,
          )
        : 0;
    const prevUtilization =
      prevAvailableHours > 0
        ? (previousStats.bookedHours / prevAvailableHours) * 100
        : 0;

    // Build response
    const dto = new EmployeeDetailAnalyticsResponseDto();
    dto.employeeId = employeeId;

    // ── Session KPIs ──────────────────────────────
    dto.completedSessions = currentStats.completedSessions;
    dto.sessionsDelta = this.delta(
      currentStats.completedSessions,
      previousStats.completedSessions,
    );
    dto.contributionValue = currentStats.contributionValue;
    dto.contributionDelta = this.delta(
      currentStats.contributionValue,
      previousStats.contributionValue,
    );

    // ── Utilization ───────────────────────────────
    dto.utilizationRate = utilizationRate;
    dto.utilizationDelta = this.delta(
      utilizationRate,
      prevUtilization,
    );

    // ── Rating ────────────────────────────────────
    dto.averageRating = reviewStats.avgRating;
    dto.reviewCount = reviewStats.count;

    // ── Trend ─────────────────────────────────────
    dto.trendPoints = trendRows;

    // ── Mix Metrics ───────────────────────────────
    dto.mixMetrics = mixMetrics;

    // ── Schedule Load ─────────────────────────────
    dto.scheduleLoad = scheduleLoad;

    // ── Quality Metrics ───────────────────────────
    dto.qualityMetrics = this.buildQualityMetrics(
      reviewStats,
      recommendStats,
      employee,
    );

    // ── Compliance ────────────────────────────────
    dto.complianceItems = this.buildComplianceItems(employee);

    return dto;
  }

  // ── Private query methods ──────────────────────────

  private async loadEmployee(
    employeeId: string,
    partnerId: string,
  ): Promise<any> {
    const result = await this.dataSource.query(
      `SELECT
        e.*,
        dp.consultation_fee,
        dp.specializations,
        tp.type AS therapist_type,
        tp.skills,
        tp.device_proficiency,
        tp.commission_rate,
        tp.health_check_date
      FROM employees e
      LEFT JOIN doctor_profiles dp ON dp.employee_id = e.id
      LEFT JOIN therapist_profiles tp ON tp.employee_id = e.id
      WHERE e.id = $1
        AND e.partner_id = $2
        AND e.deleted_at IS NULL`,
      [employeeId, partnerId],
    );

    if (!result || result.length === 0) {
      throw new NotFoundException(
        `Employee ${employeeId} not found for this partner`,
      );
    }
    return result[0];
  }

  private async getSessionStats(
    employeeId: string,
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
      FROM bookings b
      LEFT JOIN payments pay
        ON pay.booking_id = b.id
        AND pay.deleted_at IS NULL
      WHERE b.staff_id = $1
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL
        AND b.status IN (
          '${BookingStatus.COMPLETED}',
          '${BookingStatus.CONFIRMED}',
          '${BookingStatus.PENDING_PAYMENT}'
        )`,
      [employeeId, start, end],
    );
    const row = result[0] || {};
    return {
      completedSessions: parseInt(row.completed_sessions) || 0,
      contributionValue:
        parseFloat(row.contribution_value) || 0,
      bookedHours: parseFloat(row.booked_hours) || 0,
    };
  }

  private async getReviewStats(
    employeeId: string,
    start: Date,
    end: Date,
  ): Promise<{
    avgRating: number;
    count: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COALESCE(AVG(rating), 0) AS avg_rating,
        COUNT(*) AS review_count
      FROM specialist_reviews
      WHERE specialist_id = $1
        AND created_at BETWEEN $2 AND $3`,
      [employeeId, start, end],
    );
    const row = result[0] || {};
    return {
      avgRating:
        Math.round((parseFloat(row.avg_rating) || 0) * 10) / 10,
      count: parseInt(row.review_count) || 0,
    };
  }

  private async getRecommendationStats(
    employeeId: string,
    start: Date,
    end: Date,
  ): Promise<{
    total: number;
    recommendCount: number;
  }> {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*) AS total,
        COUNT(*) FILTER (WHERE would_recommend = true) AS recommend_count
      FROM specialist_reviews
      WHERE specialist_id = $1
        AND created_at BETWEEN $2 AND $3`,
      [employeeId, start, end],
    );
    const row = result[0] || {};
    return {
      total: parseInt(row.total) || 0,
      recommendCount: parseInt(row.recommend_count) || 0,
    };
  }

  private async getTrendData(
    employeeId: string,
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
      LEFT JOIN payments pay ON pay.booking_id = b.id
        AND pay.deleted_at IS NULL
      WHERE b.staff_id = $2
        AND b.start_time BETWEEN $3 AND $4
        AND b.deleted_at IS NULL
      GROUP BY bucket
      ORDER BY bucket ASC`,
      [granularity, employeeId, start, end],
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

  private async getMixMetrics(
    employeeId: string,
    start: Date,
    end: Date,
    employee: any,
  ): Promise<EmployeeMixMetricDto[]> {
    const rows = await this.dataSource.query(
      `SELECT
        COALESCE(c.name, p.name, 'Uncategorized') AS label,
        COUNT(*) AS value
      FROM bookings b
      LEFT JOIN products p ON p.id = b.product_id
      LEFT JOIN categories c ON c.id = p.category_id
      WHERE b.staff_id = $1
        AND b.start_time BETWEEN $2 AND $3
        AND b.status = '${BookingStatus.COMPLETED}'
        AND b.deleted_at IS NULL
      GROUP BY label
      ORDER BY value DESC
      LIMIT 6`,
      [employeeId, start, end],
    );

    if (rows.length > 0) {
      const total = rows.reduce(
        (sum: number, r: any) => sum + (parseInt(r.value) || 0),
        0,
      );
      return rows.map((row: any) => {
        const dto = new EmployeeMixMetricDto();
        dto.label = row.label;
        dto.value = parseInt(row.value) || 0;
        dto.share =
          total > 0
            ? Math.round((dto.value / total) * 100) / 100
            : 0;
        return dto;
      });
    }

    // Fallback: use profile metadata
    return this.getMixMetricsFallback(employee);
  }

  private getMixMetricsFallback(
    employee: any,
  ): EmployeeMixMetricDto[] {
    const role = employee.role;

    if (role === 'DOCTOR' && employee.specializations) {
      const specs: string[] = Array.isArray(
        employee.specializations,
      )
        ? employee.specializations
        : [];
      return specs.map((spec) => {
        const dto = new EmployeeMixMetricDto();
        dto.label = spec;
        dto.value = 0;
        dto.share = 0;
        return dto;
      });
    }

    if (role === 'THERAPIST' && employee.skills) {
      const skills: string[] = Array.isArray(employee.skills)
        ? employee.skills
        : [];
      return skills.map((skill) => {
        const dto = new EmployeeMixMetricDto();
        dto.label = skill;
        dto.value = 0;
        dto.share = 0;
        return dto;
      });
    }

    return [];
  }

  private async getScheduleLoad(
    employee: any,
    employeeId: string,
    start: Date,
    end: Date,
  ): Promise<EmployeeScheduleLoadDto[]> {
    const schedule = employee.schedule || [];

    // Count occurrences of each weekday in the period
    const weekdayCounts = new Map<number, number>();
    const current = new Date(start);
    while (current <= end) {
      // Convert JS day (0=Sun) to ISO day (7=Sun)
      const jsDay = current.getDay();
      const isoDow = jsDay === 0 ? 7 : jsDay;
      weekdayCounts.set(
        isoDow,
        (weekdayCounts.get(isoDow) || 0) + 1,
      );
      current.setDate(current.getDate() + 1);
    }

    // Parse schedule → available hours per ISO weekday
    const scheduleByIsoDow = new Map<number, number>();
    for (const entry of schedule) {
      if (!entry.isWorking || !entry.start || !entry.end)
        continue;
      const isoDow = DAY_NAME_TO_ISO[entry.day];
      if (!isoDow) continue;
      const [sh, sm] = entry.start.split(':').map(Number);
      const [eh, em] = entry.end.split(':').map(Number);
      const hours = (eh * 60 + em - (sh * 60 + sm)) / 60;
      if (hours > 0) scheduleByIsoDow.set(isoDow, hours);
    }

    // Load booked hours grouped by weekday
    const bookedRows = await this.dataSource.query(
      `SELECT
        EXTRACT(ISODOW FROM b.start_time)::int AS iso_dow,
        COALESCE(SUM(
          EXTRACT(EPOCH FROM (
            COALESCE(b.end_time, b.start_time + INTERVAL '30 minutes') - b.start_time
          )) / 3600
        ), 0) AS booked_hours
      FROM bookings b
      WHERE b.staff_id = $1
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL
        AND b.status IN (
          '${BookingStatus.COMPLETED}',
          '${BookingStatus.CONFIRMED}',
          '${BookingStatus.PENDING_PAYMENT}'
        )
      GROUP BY iso_dow`,
      [employeeId, start, end],
    );

    const bookedByDow = new Map<number, number>();
    for (const row of bookedRows) {
      bookedByDow.set(
        parseInt(row.iso_dow),
        parseFloat(row.booked_hours) || 0,
      );
    }

    // Build 7-element result
    const result: EmployeeScheduleLoadDto[] = [];
    for (let isoDow = 1; isoDow <= 7; isoDow++) {
      const dto = new EmployeeScheduleLoadDto();
      dto.label = ISO_DOW_LABELS[isoDow];
      const dayCount = weekdayCounts.get(isoDow) || 0;
      const dailyHours = scheduleByIsoDow.get(isoDow) || 0;
      dto.availableHours = this.round1(dailyHours * dayCount);
      dto.bookedHours = this.round1(
        bookedByDow.get(isoDow) || 0,
      );
      result.push(dto);
    }

    return result;
  }

  // ── Quality metrics builder ───────────────────────

  private buildQualityMetrics(
    reviewStats: { avgRating: number; count: number },
    recommendStats: { total: number; recommendCount: number },
    employee: any,
  ): EmployeeQualityMetricDto[] {
    const metrics: EmployeeQualityMetricDto[] = [];

    // 1. Client sentiment
    const sentiment = new EmployeeQualityMetricDto();
    sentiment.label = 'Client sentiment';
    sentiment.value = reviewStats.avgRating.toFixed(1);
    sentiment.detail = `${reviewStats.count} reviews across recent services`;
    sentiment.tone =
      reviewStats.avgRating >= 4.5 ? 'positive' : 'warning';
    metrics.push(sentiment);

    // 2. Recommendation rate
    const recommendation = new EmployeeQualityMetricDto();
    recommendation.label = 'Recommendation rate';
    const recRate =
      recommendStats.total > 0
        ? Math.round(
            (recommendStats.recommendCount /
              recommendStats.total) *
              100,
          )
        : 0;
    recommendation.value = `${recRate}%`;
    recommendation.detail = `${recommendStats.recommendCount} of ${recommendStats.total} clients would recommend`;
    if (recRate >= 85) {
      recommendation.tone = 'positive';
    } else if (recRate >= 70) {
      recommendation.tone = 'warning';
    } else {
      recommendation.tone = recommendStats.total > 0 ? 'critical' : 'neutral';
    }
    metrics.push(recommendation);

    // 3. Documentation
    const docs = new EmployeeQualityMetricDto();
    docs.label = 'Documentation';
    const verificationDocs =
      employee.verification_documents || [];
    const hasDocs =
      Array.isArray(verificationDocs) &&
      verificationDocs.length > 0;
    docs.value = hasDocs ? 'Complete' : 'Missing';
    docs.detail = hasDocs
      ? 'Verification documents are on file.'
      : 'No verification documents uploaded.';
    docs.tone = hasDocs ? 'positive' : 'critical';
    metrics.push(docs);

    return metrics;
  }

  // ── Compliance builder ────────────────────────────

  private buildComplianceItems(
    employee: any,
  ): EmployeeComplianceItemDto[] {
    const items: EmployeeComplianceItemDto[] = [];
    const roleLabel = this.mapRoleLabel(
      employee.role,
      employee.therapist_type,
    );

    // 1. Profile status
    const profileItem = new EmployeeComplianceItemDto();
    profileItem.title = 'Profile status';
    if (employee.status === EmployeeStatus.ACTIVE) {
      profileItem.detail = `${roleLabel} profile is active.`;
      profileItem.tone = 'positive';
    } else {
      profileItem.detail = `${roleLabel} profile is ${(employee.status || 'unknown').toLowerCase()}.`;
      profileItem.tone = 'warning';
    }
    items.push(profileItem);

    // 2. Verification posture
    const verItem = new EmployeeComplianceItemDto();
    verItem.title = 'Verification posture';
    const verDocs = employee.verification_documents || [];
    const hasDocs =
      Array.isArray(verDocs) && verDocs.length > 0;
    if (hasDocs) {
      verItem.detail =
        'Verification documents are on file.';
      verItem.tone = 'positive';
    } else {
      verItem.detail =
        'No verification documents uploaded.';
      verItem.tone = 'critical';
    }
    items.push(verItem);

    // 3. Emergency readiness
    const emergencyItem = new EmployeeComplianceItemDto();
    emergencyItem.title = 'Emergency readiness';
    const hasEmergency =
      employee.emergency_contact_phone &&
      employee.emergency_contact_phone.trim() !== '';
    if (hasEmergency) {
      emergencyItem.detail =
        'Emergency contact information is on file.';
      emergencyItem.tone = 'positive';
    } else {
      emergencyItem.detail =
        'No emergency contact information available.';
      emergencyItem.tone = 'warning';
    }
    items.push(emergencyItem);

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

  private delta(current: number, previous: number): number {
    if (previous <= 0) return current > 0 ? 100 : 0;
    return (
      Math.round(
        ((current - previous) / previous) * 100 * 10,
      ) / 10
    );
  }

  private round1(value: number): number {
    return Math.round(value * 10) / 10;
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
        return '';
      case DashboardTimePeriod.THIS_QUARTER:
      case DashboardTimePeriod.THIS_YEAR: {
        return months[date.getMonth()];
      }
    }
  }
}
