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
import { FacilityReview } from '@/common/entities/facility-review.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { S3Service } from '@/s3/s3.service';
import { CreateFacilityReviewDto } from '../../dto/create-facility-review.dto';
import { FacilityReviewResponseDto } from '../../dto/facility-review-response.dto';

@Injectable()
export class SubmitFacilityReviewHandler {
  private readonly logger = new Logger(SubmitFacilityReviewHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly s3Service: S3Service,
  ) {}

  async execute(
    userId: string,
    dto: CreateFacilityReviewDto,
  ): Promise<FacilityReviewResponseDto> {
    this.logger.log(
      `Submitting facility review: user=${userId}, appointment=${dto.appointmentId}, facility=${dto.facilityId}`,
    );

    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const booking = await queryRunner.manager.findOne(Booking, {
        where: { id: dto.appointmentId },
        relations: { product: true },
      });

      if (!booking) {
        throw new NotFoundException('Appointment not found');
      }

      if (booking.userId !== userId) {
        throw new ForbiddenException('Unauthorized');
      }

      if (booking.status !== BookingStatus.COMPLETED) {
        throw new BadRequestException(
          'Only completed appointments can be reviewed',
        );
      }

      if (!booking.product?.partnerId) {
        throw new BadRequestException(
          'Facility not found for this appointment',
        );
      }

      if (booking.product.partnerId !== dto.facilityId) {
        throw new BadRequestException(
          'Facility not found for this appointment',
        );
      }

      const existingReview = await queryRunner.manager.findOne(FacilityReview, {
        where: { appointmentId: dto.appointmentId },
      });

      if (existingReview) {
        throw new ConflictException('Facility review already submitted');
      }

      const photoUrls: string[] = [];
      if (dto.photoKeys?.length) {
        for (const key of dto.photoKeys) {
          const url = await this.s3Service.getFileUrl(key);
          photoUrls.push(url);
        }
      }

      const review = queryRunner.manager.create(FacilityReview, {
        appointmentId: dto.appointmentId,
        facilityId: dto.facilityId,
        userId,
        rating: dto.rating,
        comment: dto.comment?.trim() || null,
        tags: dto.tags ?? [],
        photoUrls,
      });

      const saved = await queryRunner.manager.save(FacilityReview, review);

      await queryRunner.commitTransaction();
      this.logger.log(`Facility review created: ${saved.id}`);

      return FacilityReviewResponseDto.fromEntity(saved);
    } catch (error) {
      await queryRunner.rollbackTransaction();

      if (
        error instanceof NotFoundException ||
        error instanceof ForbiddenException ||
        error instanceof BadRequestException ||
        error instanceof ConflictException
      ) {
        throw error;
      }

      this.logger.error(
        `Failed to submit facility review: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Failed to submit facility review',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
