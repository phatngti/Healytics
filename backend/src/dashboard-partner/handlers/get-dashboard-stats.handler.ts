import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardTimePeriod } from '../dto/query/dashboard-period-query.dto';
import { DashboardStatsResponseDto } from '../dto/response/dashboard-stats-response.dto';
import { resolveDateRange } from '../helpers/date-range.helper';

@Injectable()
export class GetDashboardStatsHandler {
  private readonly logger = new Logger(GetDashboardStatsHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    period: DashboardTimePeriod,
  ): Promise<DashboardStatsResponseDto> {
    this.logger.log(
      `Getting dashboard stats for partner: ${partnerId}, period: ${period}`,
    );

    const { startDate, endDate, prevStartDate, prevEndDate } =
      resolveDateRange(period);

    // Run all independent queries in parallel
    const [appointmentStats, revenueStats, serviceStats, employeeStats, ratingStats] =
      await Promise.all([
        this.getAppointmentStats(partnerId, startDate, endDate),
        this.getRevenueStats(partnerId, startDate, endDate, prevStartDate, prevEndDate),
        this.getServiceStats(partnerId),
        this.getEmployeeStats(partnerId),
        this.getRatingStats(partnerId),
      ]);

    const dto = new DashboardStatsResponseDto();
    dto.totalAppointments = parseInt(appointmentStats.total) || 0;
    dto.completedAppointments = parseInt(appointmentStats.completed) || 0;
    dto.cancelledAppointments = parseInt(appointmentStats.cancelled) || 0;
    dto.pendingAppointments = parseInt(appointmentStats.pending) || 0;
    dto.totalRevenue = parseFloat(revenueStats.currentRevenue) || 0;
    dto.revenueGrowthPercent = revenueStats.growthPercent;
    dto.totalServices = parseInt(serviceStats.total) || 0;
    dto.activeServices = parseInt(serviceStats.active) || 0;
    dto.totalEmployees = parseInt(employeeStats.total) || 0;
    dto.activeEmployees = parseInt(employeeStats.active) || 0;
    dto.averageRating = ratingStats.averageRating;
    dto.totalReviews = ratingStats.totalReviews;

    return dto;
  }

  private async getAppointmentStats(
    partnerId: string,
    startDate: Date,
    endDate: Date,
  ) {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                                    AS total,
        COUNT(*) FILTER (WHERE b.status = 'COMPLETED')              AS completed,
        COUNT(*) FILTER (WHERE b.status IN ('CANCELLED', 'NO_SHOW'))AS cancelled,
        COUNT(*) FILTER (WHERE b.status IN ('PENDING_PAYMENT', 'CONFIRMED'))
                                                                    AS pending
      FROM bookings b
      JOIN employees e ON b.staff_id = e.id
      WHERE e.partner_id = $1
        AND b.start_time BETWEEN $2 AND $3
        AND b.deleted_at IS NULL`,
      [partnerId, startDate, endDate],
    );
    return result[0] || { total: '0', completed: '0', cancelled: '0', pending: '0' };
  }

  private async getRevenueStats(
    partnerId: string,
    startDate: Date,
    endDate: Date,
    prevStartDate: Date,
    prevEndDate: Date,
  ) {
    const [currentResult, previousResult] = await Promise.all([
      this.dataSource.query(
        `SELECT COALESCE(SUM(p.amount), 0) AS revenue
        FROM payments p
        JOIN bookings b ON p.booking_id = b.id
        JOIN employees e ON b.staff_id = e.id
        WHERE e.partner_id = $1
          AND p.payment_status IN ('PAID', 'DEPOSITED')
          AND p.paid_at BETWEEN $2 AND $3`,
        [partnerId, startDate, endDate],
      ),
      this.dataSource.query(
        `SELECT COALESCE(SUM(p.amount), 0) AS revenue
        FROM payments p
        JOIN bookings b ON p.booking_id = b.id
        JOIN employees e ON b.staff_id = e.id
        WHERE e.partner_id = $1
          AND p.payment_status IN ('PAID', 'DEPOSITED')
          AND p.paid_at BETWEEN $2 AND $3`,
        [partnerId, prevStartDate, prevEndDate],
      ),
    ]);

    const currentRevenue = parseFloat(currentResult[0]?.revenue) || 0;
    const previousRevenue = parseFloat(previousResult[0]?.revenue) || 0;

    const growthPercent =
      previousRevenue > 0
        ? Math.round(
            ((currentRevenue - previousRevenue) / previousRevenue) * 100 * 100,
          ) / 100
        : 0;

    return { currentRevenue: currentRevenue.toString(), growthPercent };
  }

  private async getServiceStats(partnerId: string) {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                        AS total,
        COUNT(*) FILTER (WHERE status = 'active')       AS active
      FROM products
      WHERE partner_id = $1
        AND deleted_at IS NULL`,
      [partnerId],
    );
    return result[0] || { total: '0', active: '0' };
  }

  private async getEmployeeStats(partnerId: string) {
    const result = await this.dataSource.query(
      `SELECT
        COUNT(*)                                        AS total,
        COUNT(*) FILTER (WHERE status = 'ACTIVE')       AS active
      FROM employees
      WHERE partner_id = $1
        AND deleted_at IS NULL`,
      [partnerId],
    );
    return result[0] || { total: '0', active: '0' };
  }

  private async getRatingStats(partnerId: string) {
    const [treatmentResult, specialistResult] = await Promise.all([
      this.dataSource.query(
        `SELECT AVG(r.rating) AS avg, COUNT(*) AS cnt
        FROM product_treatment_reviews r
        JOIN bookings b ON r.appointment_id = b.id
        JOIN employees e ON b.staff_id = e.id
        WHERE e.partner_id = $1`,
        [partnerId],
      ),
      this.dataSource.query(
        `SELECT AVG(r.rating) AS avg, COUNT(*) AS cnt
        FROM specialist_reviews r
        JOIN employees e ON r.specialist_id = e.id
        WHERE e.partner_id = $1`,
        [partnerId],
      ),
    ]);

    const tAvg = parseFloat(treatmentResult[0]?.avg) || 0;
    const tCnt = parseInt(treatmentResult[0]?.cnt) || 0;
    const sAvg = parseFloat(specialistResult[0]?.avg) || 0;
    const sCnt = parseInt(specialistResult[0]?.cnt) || 0;

    const totalReviews = tCnt + sCnt;
    const averageRating =
      totalReviews > 0
        ? Math.round(((tAvg * tCnt + sAvg * sCnt) / totalReviews) * 10) / 10
        : 0;

    return { averageRating, totalReviews };
  }
}
