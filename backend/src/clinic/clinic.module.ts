import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClinicService } from './clinic.service';
import { UserClinicController } from './user-clinic.controller';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { PartnerCertification } from './entities/partner-certification.entity';
import { ClinicReviewResponse } from './entities/clinic-review-response.entity';
import { PartnersModule } from '@/partners/partners.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      Employee,
      Booking,
      TreatmentReview,
      PartnerCertification,
      ClinicReviewResponse,
    ]),
    PartnersModule,
  ],
  controllers: [UserClinicController],
  providers: [ClinicService],
  exports: [ClinicService],
})
export class ClinicModule {}
