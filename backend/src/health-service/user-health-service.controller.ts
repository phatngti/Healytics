import { Get, Param, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { HealthServiceService } from './health-service.service';
import { PublicHealthServiceResponseDto } from './dto/public/public-health-service-response.dto';
import { PublicHealthServiceInfoResponseDto } from './dto/public/public-health-service-info-response.dto';
import { PublicHealthServiceEmployeeResponseDto } from './dto/public/public-health-service-employee-response.dto';
import { PublicHealthServiceReviewResponseDto } from './dto/public/public-health-service-review-response.dto';
import { PublicHealthServiceRecommendedResponseDto } from './dto/public/public-health-service-recommended-response.dto';
import { PublicHealthServiceCardResponseDto } from './dto/public/public-health-service-card-response.dto';
import { PublicClinicInfoResponseDto } from './dto/public/public-clinic-info-response.dto';
import { UserEligibilityDetailResponseDto } from './dto/public/user-eligibility-detail-response.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * User-authenticated controller for health service endpoints.
 * All routes require a valid JWT with USER role.
 *
 * Routes: /v1/user/health-services/...
 *
 * Note: Previously, browsing endpoints lived in HealthServiceController (@Public).
 * They have been consolidated here and secured under the USER role.
 */
@UserApi('health-services')
export class UserHealthServiceController {
  constructor(private readonly healthServiceService: HealthServiceService) {}

  // ─── Listing Endpoints ────────────────────────────────────

  /**
   * Returns a list of premium treatment services.
   */
  @Get('premium-treatments')
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
  @ApiOperation({ summary: 'Get home recommendations' })
  @ApiOkResponse({
    description: 'Return list of home recommended services.',
    type: [PublicHealthServiceCardResponseDto],
  })
  getHomeRecommend(): Promise<PublicHealthServiceCardResponseDto[]> {
    return this.healthServiceService.getHomeRecommend();
  }

  // ─── Eligibility Detail ───────────────────────────────────

  /**
   * Returns enriched eligibility detail by eligibility ID.
   * Includes the linked category info, health service (product) info,
   * and assigned employee info in a single response — useful for
   * building booking summary or appointment detail screens.
   */
  @Get('eligibilities/:id')
  @ApiOperation({
    summary: 'Get eligibility detail by ID',
    description:
      'Returns the full eligibility record enriched with category, service, and employee information, ' +
      'looked up by the surrogate primary key on the product_employee_eligibility table.',
  })
  @ApiOkResponse({
    description:
      'Returns eligibility detail with category, product, and employee info.',
    type: UserEligibilityDetailResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Eligibility not found.' })
  getEligibilityDetail(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<UserEligibilityDetailResponseDto> {
    return this.healthServiceService.getEligibilityDetail(id);
  }

  // ─── Clinic Info Endpoint ─────────────────────────────────

  /**
   * Returns public clinic profile by partner (clinic) ID.
   */
  @Get('clinics/:id/info')
  @ApiOperation({ summary: 'Get public clinic info by ID' })
  @ApiOkResponse({
    description: 'Return clinic info for the clinic detail screen.',
    type: PublicClinicInfoResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  getClinicInfo(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicClinicInfoResponseDto> {
    return this.healthServiceService.getClinicInfo(id);
  }

  // ─── Service Detail Endpoints ─────────────────────────────

  /**
   * Retrieves service info by ID.
   */
  @Get(':id/info')
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
   * Retrieves a health service by ID.
   */
  @Get(':id')
  @ApiOperation({ summary: 'Get a service by ID' })
  @ApiOkResponse({
    description: 'Return the service.',
    type: PublicHealthServiceResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Service not found.' })
  findOne(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<PublicHealthServiceResponseDto> {
    return this.healthServiceService.findOne(id);
  }
}
