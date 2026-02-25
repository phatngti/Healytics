import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Account } from '@/common/entities/account.entity';
import { Category } from '@/common/entities/category.entity';
import { ServiceTag } from '@/common/entities/service-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { Product } from '@/common/entities/product.entity';
import { ServiceDefinition } from '@/common/entities/service-definition.entity';
import { ServiceResourceRequirement } from '@/common/entities/service-resource-requirement.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ServiceEmployeeEligibility } from '@/common/entities/service-employee-eligibility.entity';
import { Partner } from '@/common/entities/partner.entity';
import { ProductReview } from '@/common/entities/product-review.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { UserSeeder } from './users/user.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { SeederService } from './seeder.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Account,
      Category,
      ServiceTag,
      ProductTag,
      Employee,
      DoctorProfile,
      TherapistProfile,
      Product,
      ServiceDefinition,
      ServiceResourceRequirement,
      ResourceType,
      ServiceEmployeeEligibility,
      Partner,
      ProductReview,
      ProductFacilityImage,
    ]),
  ],
  providers: [
    UserSeeder,
    CategorySeeder,
    ServiceTagSeeder,
    EmployeeSeeder,
    ProductSeeder,
    PartnerSeeder,
    SeederService,
  ],
  exports: [SeederService],
})
export class SeederModule {}
