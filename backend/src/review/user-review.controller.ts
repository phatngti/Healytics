import { Post, Body } from '@nestjs/common';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiBadRequestResponse,
  ApiConflictResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { ReviewService } from './review.service';
import { CreateTreatmentReviewDto } from './dto/create-treatment-review.dto';
import { CreateSpecialistReviewDto } from './dto/create-specialist-review.dto';
import { CreateFacilityReviewDto } from './dto/create-facility-review.dto';
import { TreatmentReviewResponseDto } from './dto/treatment-review-response.dto';
import { SpecialistReviewResponseDto } from './dto/specialist-review-response.dto';
import { FacilityReviewResponseDto } from './dto/facility-review-response.dto';

/**
 * User controller for review endpoints.
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/reviews
 */
@UserApi('reviews')
export class UserReviewController {
  constructor(private readonly reviewService: ReviewService) {}

  /**
   * Submit a treatment/service review for a completed appointment.
   */
  @Post('treatment')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Submit a treatment review for a completed appointment',
  })
  @ApiCreatedResponse({
    description: 'Treatment review submitted successfully.',
    type: TreatmentReviewResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Validation error or appointment not completed',
  })
  @ApiNotFoundResponse({ description: 'Appointment not found' })
  @ApiConflictResponse({ description: 'Treatment review already submitted' })
  async submitTreatmentReview(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateTreatmentReviewDto,
  ): Promise<TreatmentReviewResponseDto> {
    return this.reviewService.submitTreatmentReview(userId, dto);
  }

  /**
   * Submit a specialist/provider review for a completed appointment.
   */
  @Post('specialist')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Submit a specialist review for a completed appointment',
  })
  @ApiCreatedResponse({
    description: 'Specialist review submitted successfully.',
    type: SpecialistReviewResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Validation error or appointment not completed',
  })
  @ApiNotFoundResponse({ description: 'Appointment not found' })
  @ApiConflictResponse({ description: 'Specialist review already submitted' })
  async submitSpecialistReview(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSpecialistReviewDto,
  ): Promise<SpecialistReviewResponseDto> {
    return this.reviewService.submitSpecialistReview(userId, dto);
  }

  /**
   * Submit a facility/clinic review for a completed appointment.
   */
  @Post('facility')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @ApiOperation({
    summary: 'Submit a facility review for a completed appointment',
  })
  @ApiCreatedResponse({
    description: 'Facility review submitted successfully.',
    type: FacilityReviewResponseDto,
  })
  @ApiBadRequestResponse({
    description: 'Validation error or appointment not completed',
  })
  @ApiNotFoundResponse({ description: 'Appointment not found' })
  @ApiConflictResponse({ description: 'Facility review already submitted' })
  async submitFacilityReview(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateFacilityReviewDto,
  ): Promise<FacilityReviewResponseDto> {
    return this.reviewService.submitFacilityReview(userId, dto);
  }
}
