import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthServiceService } from './health-service.service';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { HealthServiceController } from './health-service.controller';
import { PartnerHealthServiceController } from './partner-health-service.controller';
import { Product } from '@/common/entities/product.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductReview } from '@/common/entities/product-review.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { PartnersModule } from '@/partners/partners.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      ProductReview,
      ProductFacilityImage,
      ProductDefinition,
      ResourceType,
      ProductResourceRequirement,
      ProductEmployeeEligibility,
      Employee,
    ]),
    PartnersModule,
  ],
  controllers: [HealthServiceController, PartnerHealthServiceController],
  providers: [
    HealthServiceService,
    CreateHealthServiceHandler,
    UpdateHealthServiceHandler,
    RemoveHealthServiceHandler,
  ],
  exports: [HealthServiceService],
})
export class HealthServiceModule {}
