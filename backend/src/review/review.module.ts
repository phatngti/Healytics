import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { Booking } from '@/common/entities/booking.entity';
import { Employee } from '@/common/entities/employee.entity';
import { S3Module } from '@/s3/s3.module';
import { UserReviewController } from './user-review.controller';
import { ReviewService } from './review.service';
import { SubmitTreatmentReviewHandler } from './application/handlers/submit-treatment-review.handler';
import { SubmitSpecialistReviewHandler } from './application/handlers/submit-specialist-review.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      TreatmentReview,
      SpecialistReview,
      Booking,
      Employee,
    ]),
    S3Module,
  ],
  controllers: [UserReviewController],
  providers: [
    ReviewService,
    SubmitTreatmentReviewHandler,
    SubmitSpecialistReviewHandler,
  ],
  exports: [ReviewService],
})
export class ReviewModule {}
