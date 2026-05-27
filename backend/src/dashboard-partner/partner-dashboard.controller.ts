import { Get, Query } from '@nestjs/common';
import { ApiOperation, ApiOkResponse } from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnerDashboardService } from './partner-dashboard.service';
import { DashboardPeriodQueryDto } from './dto/query/dashboard-period-query.dto';
import { DashboardLimitQueryDto } from './dto/query/dashboard-limit-query.dto';
import { StaffScheduleQueryDto } from './dto/query/staff-schedule-query.dto';
import { DashboardStatsResponseDto } from './dto/response/dashboard-stats-response.dto';
import { RevenueDataPointDto } from './dto/response/revenue-data-point.dto';
import { UpcomingAppointmentDto } from './dto/response/upcoming-appointment.dto';
import { ServicePerformanceDto } from './dto/response/service-performance.dto';
import { EmployeeDistributionDto } from './dto/response/employee-distribution.dto';
import { DashboardReviewDto } from './dto/response/dashboard-review.dto';
import { StaffScheduleEntryDto } from './dto/response/staff-schedule-entry.dto';
import { DashboardNotificationDto } from './dto/response/dashboard-notification.dto';
import { InventoryAlertDto } from './dto/response/inventory-alert.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

@PartnerApi('dashboard')
export class PartnerDashboardController {
  constructor(private readonly dashboardService: PartnerDashboardService) {}

  @Get('stats')
  @ApiOperation({ summary: 'Get aggregated KPI statistics' })
  @ApiOkResponse({ type: DashboardStatsResponseDto })
  getStats(
    @CurrentUser('id') userId: string,
    @Query() query: DashboardPeriodQueryDto,
  ): Promise<DashboardStatsResponseDto> {
    return this.dashboardService.getStats(userId, query.period);
  }

  @Get('revenue')
  @ApiOperation({ summary: 'Get revenue time-series data' })
  @ApiOkResponse({ type: [RevenueDataPointDto] })
  getRevenue(
    @CurrentUser('id') userId: string,
    @Query() query: DashboardPeriodQueryDto,
  ): Promise<RevenueDataPointDto[]> {
    return this.dashboardService.getRevenueData(userId, query.period);
  }

  @Get('appointments/upcoming')
  @ApiOperation({ summary: 'Get upcoming appointments' })
  @ApiOkResponse({ type: [UpcomingAppointmentDto] })
  getUpcomingAppointments(
    @CurrentUser('id') userId: string,
    @Query() query: DashboardLimitQueryDto,
  ): Promise<UpcomingAppointmentDto[]> {
    return this.dashboardService.getUpcomingAppointments(
      userId,
      query.limit ?? 5,
    );
  }

  @Get('services/performance')
  @ApiOperation({ summary: 'Get service performance metrics' })
  @ApiOkResponse({ type: [ServicePerformanceDto] })
  getServicePerformance(
    @CurrentUser('id') userId: string,
  ): Promise<ServicePerformanceDto[]> {
    return this.dashboardService.getServicePerformance(userId);
  }

  @Get('employees/distribution')
  @ApiOperation({ summary: 'Get employee role distribution' })
  @ApiOkResponse({ type: [EmployeeDistributionDto] })
  getEmployeeDistribution(
    @CurrentUser('id') userId: string,
  ): Promise<EmployeeDistributionDto[]> {
    return this.dashboardService.getEmployeeDistribution(userId);
  }

  @Get('reviews/recent')
  @ApiOperation({ summary: 'Get recent customer reviews' })
  @ApiOkResponse({ type: [DashboardReviewDto] })
  getRecentReviews(
    @CurrentUser('id') userId: string,
    @Query() query: DashboardLimitQueryDto,
  ): Promise<DashboardReviewDto[]> {
    return this.dashboardService.getRecentReviews(userId, query.limit ?? 5);
  }

  @Get('staff/schedule')
  @ApiOperation({ summary: 'Get staff schedule for a date' })
  @ApiOkResponse({ type: [StaffScheduleEntryDto] })
  getStaffSchedule(
    @CurrentUser('id') userId: string,
    @Query() query: StaffScheduleQueryDto,
  ): Promise<StaffScheduleEntryDto[]> {
    return this.dashboardService.getStaffSchedule(userId, query.date);
  }

  @Get('notifications')
  @ApiOperation({ summary: 'Get dashboard notifications' })
  @ApiOkResponse({ type: [DashboardNotificationDto] })
  getNotifications(
    @CurrentUser('id') userId: string,
    @Query() query: DashboardLimitQueryDto,
  ): Promise<DashboardNotificationDto[]> {
    return this.dashboardService.getNotifications(userId, query.limit ?? 5);
  }

  @Get('inventory/alerts')
  @ApiOperation({ summary: 'Get inventory alerts' })
  @ApiOkResponse({ type: [InventoryAlertDto] })
  getInventoryAlerts(
    @CurrentUser('id') userId: string,
  ): Promise<InventoryAlertDto[]> {
    return this.dashboardService.getInventoryAlerts(userId);
  }
}
