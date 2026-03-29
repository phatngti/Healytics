import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthServiceService } from './health-service.service';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { PartnerHealthServiceController } from './partner-health-service.controller';
import { UserHealthServiceController } from './user-health-service.controller';
import { Product } from '@/common/entities/product.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { PartnersModule } from '@/partners/partners.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      TreatmentReview,
      ProductFacilityImage,
      ProductDefinition,
      ResourceType,
      ProductResourceRequirement,
      ProductEmployeeEligibility,
      Employee,
      Booking,
    ]),
    PartnersModule,
  ],
  controllers: [PartnerHealthServiceController, UserHealthServiceController],
  providers: [
    HealthServiceService,
    CreateHealthServiceHandler,
    UpdateHealthServiceHandler,
    RemoveHealthServiceHandler,
  ],
  exports: [HealthServiceService],
})
export class HealthServiceModule {}
