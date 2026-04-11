import { Injectable, Logger } from '@nestjs/common';
import { PartnersService } from '@/partners/partners.service';
import { DashboardTimePeriod } from './dto/query/dashboard-period-query.dto';
import { DashboardStatsResponseDto } from './dto/response/dashboard-stats-response.dto';
import { RevenueDataPointDto } from './dto/response/revenue-data-point.dto';
import { UpcomingAppointmentDto } from './dto/response/upcoming-appointment.dto';
import { ServicePerformanceDto } from './dto/response/service-performance.dto';
import { EmployeeDistributionDto } from './dto/response/employee-distribution.dto';
import { DashboardReviewDto } from './dto/response/dashboard-review.dto';
import { StaffScheduleEntryDto } from './dto/response/staff-schedule-entry.dto';
import { DashboardNotificationDto } from './dto/response/dashboard-notification.dto';
import { InventoryAlertDto } from './dto/response/inventory-alert.dto';
import { GetDashboardStatsHandler } from './handlers/get-dashboard-stats.handler';
import { GetRevenueDataHandler } from './handlers/get-revenue-data.handler';
import { ListUpcomingAppointmentsHandler } from './handlers/list-upcoming-appointments.handler';
import { GetServicePerformanceHandler } from './handlers/get-service-performance.handler';
import { GetEmployeeDistributionHandler } from './handlers/get-employee-distribution.handler';
import { ListRecentReviewsHandler } from './handlers/list-recent-reviews.handler';
import { GetStaffScheduleHandler } from './handlers/get-staff-schedule.handler';
import { ListDashboardNotificationsHandler } from './handlers/list-dashboard-notifications.handler';
import { GetInventoryAlertsHandler } from './handlers/get-inventory-alerts.handler';

@Injectable()
export class PartnerDashboardService {
  private readonly logger = new Logger(PartnerDashboardService.name);

  constructor(
    private readonly partnersService: PartnersService,
    private readonly getStatsHandler: GetDashboardStatsHandler,
    private readonly getRevenueHandler: GetRevenueDataHandler,
    private readonly listAppointmentsHandler: ListUpcomingAppointmentsHandler,
    private readonly getPerformanceHandler: GetServicePerformanceHandler,
    private readonly getDistributionHandler: GetEmployeeDistributionHandler,
    private readonly listReviewsHandler: ListRecentReviewsHandler,
    private readonly getScheduleHandler: GetStaffScheduleHandler,
    private readonly listNotificationsHandler: ListDashboardNotificationsHandler,
    private readonly getAlertsHandler: GetInventoryAlertsHandler,
  ) {}

  /** Resolves partner ID from the JWT account ID */
  private async resolvePartnerId(accountId: string): Promise<string> {
    const partner = await this.partnersService.getPartnerProfile(accountId);
    return partner.id;
  }

  async getStats(
    accountId: string,
    period?: DashboardTimePeriod,
  ): Promise<DashboardStatsResponseDto> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getStatsHandler.execute(
      partnerId,
      period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  async getRevenueData(
    accountId: string,
    period?: DashboardTimePeriod,
  ): Promise<RevenueDataPointDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getRevenueHandler.execute(
      partnerId,
      period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  async getUpcomingAppointments(
    accountId: string,
    limit: number,
  ): Promise<UpcomingAppointmentDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.listAppointmentsHandler.execute(partnerId, limit);
  }

  async getServicePerformance(
    accountId: string,
  ): Promise<ServicePerformanceDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getPerformanceHandler.execute(partnerId);
  }

  async getEmployeeDistribution(
    accountId: string,
  ): Promise<EmployeeDistributionDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getDistributionHandler.execute(partnerId);
  }

  async getRecentReviews(
    accountId: string,
    limit: number,
  ): Promise<DashboardReviewDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.listReviewsHandler.execute(partnerId, limit);
  }

  async getStaffSchedule(
    accountId: string,
    date: string,
  ): Promise<StaffScheduleEntryDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getScheduleHandler.execute(partnerId, date);
  }

  async getNotifications(
    accountId: string,
    limit: number,
  ): Promise<DashboardNotificationDto[]> {
    // Notifications use accountId directly (recipient_id = account UUID)
    return this.listNotificationsHandler.execute(accountId, limit);
  }

  async getInventoryAlerts(
    accountId: string,
  ): Promise<InventoryAlertDto[]> {
    const partnerId = await this.resolvePartnerId(accountId);
    return this.getAlertsHandler.execute(partnerId);
  }
}
