import { Injectable, Logger } from '@nestjs/common';
import { SubmitTreatmentReviewHandler } from './application/handlers/submit-treatment-review.handler';
import { SubmitSpecialistReviewHandler } from './application/handlers/submit-specialist-review.handler';
import { CreateTreatmentReviewDto } from './dto/create-treatment-review.dto';
import { CreateSpecialistReviewDto } from './dto/create-specialist-review.dto';
import { TreatmentReviewResponseDto } from './dto/treatment-review-response.dto';
import { SpecialistReviewResponseDto } from './dto/specialist-review-response.dto';

/**
 * Review service facade — delegates all operations to domain handlers.
 */
@Injectable()
export class ReviewService {
  private readonly logger = new Logger(ReviewService.name);

  constructor(
    private readonly submitTreatmentReviewHandler: SubmitTreatmentReviewHandler,
    private readonly submitSpecialistReviewHandler: SubmitSpecialistReviewHandler,
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
}
