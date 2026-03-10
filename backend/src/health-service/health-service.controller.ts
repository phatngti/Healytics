import {
  Controller,
  Get,
  Param,
  UseInterceptors,
  ClassSerializerInterceptor,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { HealthServiceService } from './health-service.service';
import { PublicHealthServiceResponseDto } from './dto/public/public-health-service-response.dto';
import { PublicHealthServiceInfoResponseDto } from './dto/public/public-health-service-info-response.dto';
import { PublicHealthServiceEmployeeResponseDto } from './dto/public/public-health-service-employee-response.dto';
import { PublicHealthServiceReviewResponseDto } from './dto/public/public-health-service-review-response.dto';
import { PublicHealthServiceRecommendedResponseDto } from './dto/public/public-health-service-recommended-response.dto';
import { PublicHealthServiceCardResponseDto } from './dto/public/public-health-service-card-response.dto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * Public controller for health service browsing endpoints.
 * All endpoints are publicly accessible (no auth required).
 * API Version 1.
 */
@ApiTags('Health Services')
@Controller({ path: 'health-services', version: '1' })
@UseInterceptors(ClassSerializerInterceptor)
export class HealthServiceController {
  constructor(private readonly healthServiceService: HealthServiceService) {}

  // ─── Public Listing Endpoints ───────────────────────────────

  /**
   * Returns a list of premium treatment services.
   */
  @Get('premium-treatments')
  @Public()
  @ApiOperation({ summary: 'Get premium treatments' })
  @ApiOkResponse({
    description: 'Return list of premium treatments.',
    type: [PublicHealthServiceCardResponseDto],
  })
  getPremiumTreatments(): Promise<PublicHealthServiceCardResponseDto[]> {
    return this.healthServiceService.getPremiumTreatments();
  }

  /**
   * Returns a list of home-recommended services.
   */
  @Get('home-recommend')
  @Public()
  @ApiOperation({ summary: 'Get home recommendations' })
  @ApiOkResponse({
    description: 'Return list of home recommended services.',
    type: [PublicHealthServiceCardResponseDto],
  })
  getHomeRecommend(): Promise<PublicHealthServiceCardResponseDto[]> {
    return this.healthServiceService.getHomeRecommend();
  }

  // ─── User-facing Detail Endpoints ───────────────────

  /**
   * Retrieves service info by ID.
   */
  @Get(':id/info')
  @Public()
  @LogResponse()
  @ApiOperation({ summary: 'Get service info by ID' })
  @ApiOkResponse({
    description: 'Return service info for the detail screen.',
    type: PublicHealthServiceInfoResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  getProductInfo(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicHealthServiceInfoResponseDto> {
    return this.healthServiceService.getProductInfo(id);
  }

  /**
   * Retrieves eligible employees for a service.
   */
  
  @Get(':id/employees')
  @Public()
  @LogResponse()
  @ApiOperation({ summary: 'Get employees for a service' })
  @ApiOkResponse({
    description: 'Return list of eligible employees.',
    type: [PublicHealthServiceEmployeeResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  getProductEmployees(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicHealthServiceEmployeeResponseDto[]> {
    return this.healthServiceService.getProductEmployees(id);
  }

  /**
   * Retrieves reviews for a service.
   */
  @Get(':id/reviews')
  @Public()
  @ApiOperation({ summary: 'Get reviews for a service' })
  @ApiOkResponse({
    description: 'Return list of reviews.',
    type: [PublicHealthServiceReviewResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  getProductReviews(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicHealthServiceReviewResponseDto[]> {
    return this.healthServiceService.getProductReviews(id);
  }

  /**
   * Retrieves recommended services from the same category.
   */
  @Get(':id/recommended')
  @Public()
  @ApiOperation({ summary: 'Get recommended services' })
  @ApiOkResponse({
    description: 'Return list of recommended services.',
    type: [PublicHealthServiceRecommendedResponseDto],
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  getRecommendedProducts(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicHealthServiceRecommendedResponseDto[]> {
    return this.healthServiceService.getRecommendedProducts(id);
  }

  /**
   * Retrieves a service by ID.
   */
  @Get(':id')
  @Public()
  @ApiOperation({ summary: 'Get a service by id' })
  @ApiOkResponse({
    description: 'Return the service.',
    type: PublicHealthServiceResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<PublicHealthServiceResponseDto> {
    return this.healthServiceService.findOne(id);
  }
}
