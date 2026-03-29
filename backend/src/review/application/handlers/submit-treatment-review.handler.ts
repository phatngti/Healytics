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
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { S3Service } from '@/s3/s3.service';
import { CreateTreatmentReviewDto } from '../../dto/create-treatment-review.dto';
import { TreatmentReviewResponseDto } from '../../dto/treatment-review-response.dto';

@Injectable()
export class SubmitTreatmentReviewHandler {
  private readonly logger = new Logger(SubmitTreatmentReviewHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly s3Service: S3Service,
  ) {}

  async execute(
    userId: string,
    dto: CreateTreatmentReviewDto,
  ): Promise<TreatmentReviewResponseDto> {
    this.logger.log(
      `Submitting treatment review: user=${userId}, appointment=${dto.appointmentId}`,
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

      // ── 4. Invariant Check: Duplicate prevention ────────────────
      const existingReview = await queryRunner.manager.findOne(
        TreatmentReview,
        { where: { appointmentId: dto.appointmentId } },
      );

      if (existingReview) {
        throw new ConflictException('Treatment review already submitted');
      }

      // ── 5. Resolve photo keys → URLs ────────────────────────────
      const photoUrls: string[] = [];
      if (dto.photoKeys?.length) {
        for (const key of dto.photoKeys) {
          const url = await this.s3Service.getFileUrl(key);
          photoUrls.push(url);
        }
      }

      // ── 6. Domain Action: Create review ─────────────────────────
      const review = queryRunner.manager.create(TreatmentReview, {
        appointmentId: dto.appointmentId,
        userId,
        rating: dto.rating,
        comment: dto.comment?.trim() || null,
        tags: dto.tags ?? [],
        photoUrls,
      });

      const saved = await queryRunner.manager.save(TreatmentReview, review);

      // ── 7. Side Effect: Mark appointment as reviewed ────────────
      await queryRunner.manager.update(Booking, dto.appointmentId, {
        isReviewed: true,
      });

      // ── 8. Commit ───────────────────────────────────────────────
      await queryRunner.commitTransaction();
      this.logger.log(`Treatment review created: ${saved.id}`);

      return TreatmentReviewResponseDto.fromEntity(saved);
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
        `Failed to submit treatment review: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException('Failed to submit treatment review');
    } finally {
      await queryRunner.release();
    }
  }
}
