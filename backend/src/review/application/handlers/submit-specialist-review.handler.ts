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
import { Employee } from '@/common/entities/employee.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { CreateSpecialistReviewDto } from '../../dto/create-specialist-review.dto';
import { SpecialistReviewResponseDto } from '../../dto/specialist-review-response.dto';

@Injectable()
export class SubmitSpecialistReviewHandler {
  private readonly logger = new Logger(SubmitSpecialistReviewHandler.name);

  constructor(private readonly dataSource: DataSource) {}

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

      // ── 7. Side Effect: Update specialist rating aggregate ──────
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { id: dto.specialistId },
      });

      if (employee) {
        const newReviewCount = (employee.reviewCount || 0) + 1;
        const currentTotal =
          (Number(employee.rating) || 0) * (employee.reviewCount || 0);
        const newRating = (currentTotal + dto.rating) / newReviewCount;

        await queryRunner.manager.update(Employee, dto.specialistId, {
          rating: Math.round(newRating * 100) / 100,
          reviewCount: newReviewCount,
        });
      }

      // ── 8. Commit ───────────────────────────────────────────────
      await queryRunner.commitTransaction();
      this.logger.log(`Specialist review created: ${saved.id}`);

      return SpecialistReviewResponseDto.fromEntity(saved);
    } catch (error) {
      await queryRunner.rollbackTransaction();

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
