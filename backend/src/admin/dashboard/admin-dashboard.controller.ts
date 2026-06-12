import { Get, Query } from '@nestjs/common';
import { ApiOkResponse, ApiOperation } from '@nestjs/swagger';
import { AdminDashboardApi } from './decorators/admin-dashboard-api.decorator';
import { AdminDashboardService } from './admin-dashboard.service';
import {
  AdminDashboardPeriodQueryDto,
  AdminDashboardRankingQueryDto,
  AdminDashboardLimitQueryDto,
} from './dto/admin-dashboard-query.dto';
import {
  AdminDashboardOverviewDto,
  AdminDashboardRevenueTrendPointDto,
  AdminDashboardBookingOutcomeSummaryDto,
  AdminDashboardTransactionHealthDto,
  AdminPartnerRankingItemDto,
  AdminServiceRankingItemDto,
  AdminDashboardNotificationItemDto,
  AdminCategoryHealthDto,
} from './dto/admin-dashboard-response.dto';

@AdminDashboardApi()
export class AdminDashboardController {
  constructor(private readonly service: AdminDashboardService) {}

  @Get('overview')
  @ApiOperation({
    summary: 'Get admin dashboard overview metrics',
  })
  @ApiOkResponse({ type: AdminDashboardOverviewDto })
  getOverview(
    @Query() query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardOverviewDto> {
    return this.service.getOverview(query);
  }

  @Get('revenue-trend')
  @ApiOperation({
    summary: 'Get admin revenue trend data points',
  })
  @ApiOkResponse({
    type: [AdminDashboardRevenueTrendPointDto],
  })
  getRevenueTrend(
    @Query() query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardRevenueTrendPointDto[]> {
    return this.service.getRevenueTrend(query);
  }

  @Get('booking-outcomes')
  @ApiOperation({
    summary: 'Get booking outcome summary',
  })
  @ApiOkResponse({
    type: AdminDashboardBookingOutcomeSummaryDto,
  })
  getBookingOutcomeSummary(
    @Query() query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardBookingOutcomeSummaryDto> {
    return this.service.getBookingOutcomeSummary(query);
  }

  @Get('transaction-health')
  @ApiOperation({
    summary: 'Get transaction health breakdown',
  })
  @ApiOkResponse({
    type: AdminDashboardTransactionHealthDto,
  })
  getTransactionHealth(
    @Query() query: AdminDashboardPeriodQueryDto,
  ): Promise<AdminDashboardTransactionHealthDto> {
    return this.service.getTransactionHealth(query);
  }

  @Get('top-partners')
  @ApiOperation({
    summary: 'Get top performing partners by revenue',
  })
  @ApiOkResponse({
    type: [AdminPartnerRankingItemDto],
  })
  getTopPartners(
    @Query() query: AdminDashboardRankingQueryDto,
  ): Promise<AdminPartnerRankingItemDto[]> {
    return this.service.getTopPartners(query);
  }

  @Get('top-services')
  @ApiOperation({
    summary: 'Get top performing services by revenue',
  })
  @ApiOkResponse({
    type: [AdminServiceRankingItemDto],
  })
  getTopServices(
    @Query() query: AdminDashboardRankingQueryDto,
  ): Promise<AdminServiceRankingItemDto[]> {
    return this.service.getTopServices(query);
  }

  @Get('notifications')
  @ApiOperation({
    summary: 'Get admin dashboard notifications',
  })
  @ApiOkResponse({
    type: [AdminDashboardNotificationItemDto],
  })
  getNotifications(
    @Query() query: AdminDashboardLimitQueryDto,
  ): Promise<AdminDashboardNotificationItemDto[]> {
    return this.service.getNotifications(query);
  }

  @Get('category-health')
  @ApiOperation({
    summary: 'Get service category health overview',
  })
  @ApiOkResponse({ type: AdminCategoryHealthDto })
  getCategoryHealth(): Promise<AdminCategoryHealthDto> {
    return this.service.getCategoryHealth();
  }
}
