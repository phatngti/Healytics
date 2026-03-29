import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Account } from '@/common/entities/account.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Category } from '@/common/entities/category.entity';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { Location } from '@/common/entities/location.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Payment } from '@/common/entities/payment.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { UserSeeder } from './users/user.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { AppointmentSeeder } from './appointments/appointment.seeder';
import { SeederService } from './seeder.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Account,
      UserProfile,
      Category,
      ProductFeatureTag,
      ProductTag,
      Employee,
      DoctorProfile,
      TherapistProfile,
      Product,
      ProductDefinition,
      ProductResourceRequirement,
      ResourceType,
      ProductEmployeeEligibility,
      Partner,
      LegalRepresentative,
      PartnerDocument,
      Location,
      TreatmentReview,
      SpecialistReview,
      Booking,
      BookingStatusLog,
      Payment,
      ProductFacilityImage,
      ProductMedia,
    ]),
  ],
  providers: [
    UserSeeder,
    ServiceTagSeeder,
    EmployeeSeeder,
    ProductSeeder,
    PartnerSeeder,
    CategorySeeder,
    AppointmentSeeder,
    SeederService,
  ],
  exports: [SeederService],
})
export class SeederModule {}
