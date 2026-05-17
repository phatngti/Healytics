import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
  ConflictException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { CreateSpecialistReviewDto } from '../../dto/create-specialist-review.dto';
import { SpecialistReviewResponseDto } from '../../dto/specialist-review-response.dto';
import { SpecialistReviewAggregateService } from '../services/specialist-review-aggregate.service';

@Injectable()
export class SubmitSpecialistReviewHandler {
  private readonly logger = new Logger(SubmitSpecialistReviewHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly specialistReviewAggregateService: SpecialistReviewAggregateService,
  ) {}

  async execute(
    userId: string,
    dto: CreateSpecialistReviewDto,
  ): Promise<SpecialistReviewResponseDto> {
    this.logger.log(
      `Submitting specialist review: user=${userId}, appointment=${dto.appointmentId}, specialist=${dto.specialistId}`,
    );

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();
    let transactionCommitted = false;

    try {
      // ── 1. Invariant Check: Booking exists ──────────────────────
      const booking = await queryRunner.manager.findOne(Booking, {
        where: { id: dto.appointmentId },
      });

      if (!booking) {
        throw new NotFoundException('Appointment not found');
      }

      // ── 2. Invariant Check: Ownership ───────────────────────────
      if (booking.userId !== userId) {
        throw new ForbiddenException('Unauthorized');
      }

      // ── 3. Invariant Check: Status ──────────────────────────────
      if (booking.status !== BookingStatus.COMPLETED) {
        throw new BadRequestException(
          'Only completed appointments can be reviewed',
        );
      }

      // ── 4. Invariant Check: Specialist matches appointment ──────
      if (booking.staffId !== dto.specialistId) {
        throw new BadRequestException(
          'Specialist not found for this appointment',
        );
      }

      // ── 5. Invariant Check: Duplicate prevention ────────────────
      const existingReview = await queryRunner.manager.findOne(
        SpecialistReview,
        { where: { appointmentId: dto.appointmentId } },
      );

      if (existingReview) {
        throw new ConflictException('Specialist review already submitted');
      }

      // ── 6. Domain Action: Create review ─────────────────────────
      const review = queryRunner.manager.create(SpecialistReview, {
        appointmentId: dto.appointmentId,
        specialistId: dto.specialistId,
        userId,
        rating: dto.rating,
        comment: dto.comment?.trim() || null,
        tags: dto.tags ?? [],
        wouldRecommend: dto.wouldRecommend,
      });

      const saved = await queryRunner.manager.save(SpecialistReview, review);

      // ── 7. Commit ───────────────────────────────────────────────
      await queryRunner.commitTransaction();
      transactionCommitted = true;
      this.logger.log(`Specialist review created: ${saved.id}`);

      // Recompute the denormalized employee aggregate outside the write
      // transaction. The 5-minute reconciliation job is the safety net.
      try {
        this.specialistReviewAggregateService.enqueueSpecialistRefresh(
          saved.specialistId,
        );
      } catch (aggregateError) {
        this.logger.warn(
          `Specialist review aggregate enqueue failed for ${saved.specialistId}: ${(aggregateError as Error).message}`,
        );
      }

      return SpecialistReviewResponseDto.fromEntity(saved);
    } catch (error) {
      if (!transactionCommitted) {
        await queryRunner.rollbackTransaction();
      }

      // Re-throw domain exceptions
      if (
        error instanceof NotFoundException ||
        error instanceof ForbiddenException ||
        error instanceof BadRequestException ||
        error instanceof ConflictException
      ) {
        throw error;
      }

      this.logger.error(
        `Failed to submit specialist review: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Failed to submit specialist review',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
