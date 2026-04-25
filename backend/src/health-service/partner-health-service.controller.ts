import {
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
  Get,
  Query,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { HealthServiceService } from './health-service.service';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { PartnerHealthServiceResponseDto } from './dto/partner/partner-health-service-response.dto';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { PartnerHealthServiceDetailResponseDto } from './dto/partner/partner-health-service-detail-response.dto';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { HealthServiceAnalyticsQueryDto } from './dto/partner/health-service-analytics-query.dto';
import { HealthServiceOverviewAnalyticsResponseDto } from './dto/partner/analytics/health-service-overview-analytics.dto';
import { HealthServiceDetailAnalyticsResponseDto } from './dto/partner/analytics/health-service-detail-analytics.dto';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';

/**
 * Partner controller for health service management.
 * All endpoints require HEALTH_PARTNER authentication.
 * Route prefix: /v1/partner/health-services
 */
@PartnerApi('health-services')
export class PartnerHealthServiceController {
  constructor(private readonly healthServiceService: HealthServiceService) {}

  // ─── Analytics Endpoints (must precede :slug routes) ─────

  /**
   * Returns overview analytics for all partner services.
   */
  @Get('analytics/overview')
  @ApiOperation({
    summary: 'Get health service overview analytics',
  })
  @ApiOkResponse({
    type: HealthServiceOverviewAnalyticsResponseDto,
  })
  getOverviewAnalytics(
    @CurrentUser('id') userId: string,
    @Query() query: HealthServiceAnalyticsQueryDto,
  ): Promise<HealthServiceOverviewAnalyticsResponseDto> {
    return this.healthServiceService.getOverviewAnalytics(
      userId,
      query.period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  /**
   * Returns per-service detail analytics for a product.
   */
  @Get('analytics/:productId')
  @ApiOperation({
    summary: 'Get per-service detail analytics',
  })
  @ApiOkResponse({
    type: HealthServiceDetailAnalyticsResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Product not found.' })
  getDetailAnalytics(
    @CurrentUser('id') userId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
    @Query() query: HealthServiceAnalyticsQueryDto,
  ): Promise<HealthServiceDetailAnalyticsResponseDto> {
    return this.healthServiceService.getDetailAnalytics(
      userId,
      productId,
      query.period ?? DashboardTimePeriod.THIS_MONTH,
    );
  }

  // ─── CRUD Endpoints ──────────────────────────────────────

  /**
   * Retrieves all health services.
   */
  @Get()
  @ApiOperation({ summary: 'Get all health services' })
  @ApiOkResponse({
    description: 'Return all health services.',
    type: [PartnerHealthServiceResponseDto],
  })
  findAll(): Promise<PartnerHealthServiceResponseDto[]> {
    return this.healthServiceService.findAll();
  }

  /**
   * Retrieves full health service details by slug (enriched response).
   */
  @Get('slug/:slug/details')
  @ApiOperation({ summary: 'Get full health service details by slug' })
  @ApiOkResponse({
    description: 'Return enriched health service details.',
    type: PartnerHealthServiceDetailResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Health service not found.' })
  getDetails(
    @Param('slug') slug: string,
  ): Promise<PartnerHealthServiceDetailResponseDto> {
    return this.healthServiceService.getProductDetails(slug);
  }

  /**
   * Retrieves a health service by slug.
   */
  @Get('slug/:slug')
  @ApiOperation({ summary: 'Get a health service by slug' })
  @ApiOkResponse({
    description: 'Return the health service.',
    type: PartnerHealthServiceResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Health service not found.' })
  findBySlug(
    @Param('slug') slug: string,
  ): Promise<PartnerHealthServiceResponseDto> {
    return this.healthServiceService.findBySlug(slug);
  }

  /**
   * Creates a new health service.
   */
  @Post()
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Create a new health service' })
  @ApiCreatedResponse({
    description: 'The health service has been successfully created.',
    type: PartnerHealthServiceResponseDto,
  })
  create(
    @Body() createDto: CreatePartnerHealthServiceDto,
  ): Promise<PartnerHealthServiceResponseDto> {
    return this.healthServiceService.create(createDto);
  }

  /**
   * Updates a health service.
   */
  @Patch(':id')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Update a health service' })
  @ApiOkResponse({
    description: 'The health service has been successfully updated.',
    type: PartnerHealthServiceResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Health service not found.' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() updateDto: UpdatePartnerHealthServiceDto,
  ): Promise<PartnerHealthServiceResponseDto> {
    return this.healthServiceService.update(id, updateDto);
  }

  /**
   * Deletes a health service (soft delete).
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Delete a health service' })
  @ApiNoContentResponse({
    description: 'The health service has been successfully deleted.',
  })
  @ApiNotFoundResponse({ description: 'Health service not found.' })
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.healthServiceService.remove(id);
  }
}
