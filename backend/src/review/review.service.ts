import { Injectable, Logger } from '@nestjs/common';
import { SubmitTreatmentReviewHandler } from './application/handlers/submit-treatment-review.handler';
import { SubmitSpecialistReviewHandler } from './application/handlers/submit-specialist-review.handler';
import { SubmitFacilityReviewHandler } from './application/handlers/submit-facility-review.handler';
import { CreateTreatmentReviewDto } from './dto/create-treatment-review.dto';
import { CreateSpecialistReviewDto } from './dto/create-specialist-review.dto';
import { CreateFacilityReviewDto } from './dto/create-facility-review.dto';
import { TreatmentReviewResponseDto } from './dto/treatment-review-response.dto';
import { SpecialistReviewResponseDto } from './dto/specialist-review-response.dto';
import { FacilityReviewResponseDto } from './dto/facility-review-response.dto';

/**
 * Review service facade — delegates all operations to domain handlers.
 */
@Injectable()
export class ReviewService {
  private readonly logger = new Logger(ReviewService.name);

  constructor(
    private readonly submitTreatmentReviewHandler: SubmitTreatmentReviewHandler,
    private readonly submitSpecialistReviewHandler: SubmitSpecialistReviewHandler,
    private readonly submitFacilityReviewHandler: SubmitFacilityReviewHandler,
  ) {}

  // ── Treatment Review ────────────────────────────────────────────

  async submitTreatmentReview(
    userId: string,
    dto: CreateTreatmentReviewDto,
  ): Promise<TreatmentReviewResponseDto> {
    this.logger.log(`submitTreatmentReview: user=${userId}`);
    return this.submitTreatmentReviewHandler.execute(userId, dto);
  }

  // ── Specialist Review ───────────────────────────────────────────

  async submitSpecialistReview(
    userId: string,
    dto: CreateSpecialistReviewDto,
  ): Promise<SpecialistReviewResponseDto> {
    this.logger.log(`submitSpecialistReview: user=${userId}`);
    return this.submitSpecialistReviewHandler.execute(userId, dto);
  }

  // ── Facility Review ────────────────────────────────────────────

  async submitFacilityReview(
    userId: string,
    dto: CreateFacilityReviewDto,
  ): Promise<FacilityReviewResponseDto> {
    this.logger.log(`submitFacilityReview: user=${userId}`);
    return this.submitFacilityReviewHandler.execute(userId, dto);
  }
}
