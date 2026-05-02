import { Get, Query } from '@nestjs/common';
import { ApiOperation, ApiOkResponse, ApiNotFoundResponse } from '@nestjs/swagger';
import { EmployeeApi } from '@/common/decorators/api/employee-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { EmployeeRevenueQueryDto } from './dto/employee/employee-revenue-query.dto';
import {
  EmployeeRevenueSummaryResponseDto,
  EmployeeRevenueTrendPointDto,
  EmployeeRevenueBreakdownItemDto,
} from './dto/employee/employee-revenue-response.dto';
import { GetEmployeeRevenueSummaryHandler } from './application/handlers/get-employee-revenue-summary.handler';
import { GetEmployeeRevenueTrendHandler } from './application/handlers/get-employee-revenue-trend.handler';
import { GetEmployeeRevenueBreakdownHandler } from './application/handlers/get-employee-revenue-breakdown.handler';

/**
 * Employee revenue analytics controller.
 * All endpoints require EMPLOYEE authentication.
 * Route prefix: /v1/employee/revenue
 */
@EmployeeApi('revenue')
export class EmployeeRevenueController {
  constructor(
    private readonly summaryHandler: GetEmployeeRevenueSummaryHandler,
    private readonly trendHandler: GetEmployeeRevenueTrendHandler,
    private readonly breakdownHandler: GetEmployeeRevenueBreakdownHandler,
  ) {}

  /**
   * Gets revenue summary for the authenticated employee.
   */
  @Get('summary')
  @ApiOperation({ summary: 'Get revenue summary' })
  @ApiOkResponse({
    description: 'Revenue summary for the period.',
    type: EmployeeRevenueSummaryResponseDto,
  })
  @ApiNotFoundResponse({
    description: 'No employee profile linked to this account.',
  })
  async getSummary(
    @CurrentUser('id') accountId: string,
    @Query() query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueSummaryResponseDto> {
    return this.summaryHandler.execute(accountId, query);
  }

  /**
   * Gets revenue trend data for chart rendering.
   */
  @Get('trend')
  @ApiOperation({ summary: 'Get revenue trend data' })
  @ApiOkResponse({
    description: 'Array of trend data points.',
    type: [EmployeeRevenueTrendPointDto],
  })
  @ApiNotFoundResponse({
    description: 'No employee profile linked to this account.',
  })
  async getTrend(
    @CurrentUser('id') accountId: string,
    @Query() query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueTrendPointDto[]> {
    return this.trendHandler.execute(accountId, query);
  }

  /**
   * Gets revenue breakdown by service category.
   */
  @Get('breakdown')
  @ApiOperation({ summary: 'Get revenue breakdown by service' })
  @ApiOkResponse({
    description: 'Array of breakdown items.',
    type: [EmployeeRevenueBreakdownItemDto],
  })
  @ApiNotFoundResponse({
    description: 'No employee profile linked to this account.',
  })
  async getBreakdown(
    @CurrentUser('id') accountId: string,
    @Query() query: EmployeeRevenueQueryDto,
  ): Promise<EmployeeRevenueBreakdownItemDto[]> {
    return this.breakdownHandler.execute(accountId, query);
  }
}
