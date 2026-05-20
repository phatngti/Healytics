import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmployeesService } from './employees.service';
import { PartnerEmployeesController } from './partner-employees.controller';
import { UserEmployeesController } from './user-employees.controller';
import { EmployeeProfileController } from './employee-profile.controller';
import { EmployeeRevenueController } from './employee-revenue.controller';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { SkillCatalog } from '@/common/entities/skill-catalog.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { Booking } from '@/common/entities/booking.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { PartnersModule } from '@/partners/partners.module';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';
import { GetEmployeeOverviewAnalyticsHandler } from './application/handlers/get-employee-overview-analytics.handler';
import { GetEmployeeDetailAnalyticsHandler } from './application/handlers/get-employee-detail-analytics.handler';
import { GetEmployeeProfileHandler } from './application/handlers/get-employee-profile.handler';
import { UpdateEmployeeProfileHandler } from './application/handlers/update-employee-profile.handler';
import { GetEmployeeRevenueSummaryHandler } from './application/handlers/get-employee-revenue-summary.handler';
import { GetEmployeeRevenueTrendHandler } from './application/handlers/get-employee-revenue-trend.handler';
import { GetEmployeeRevenueBreakdownHandler } from './application/handlers/get-employee-revenue-breakdown.handler';
import { SearchModule } from '@/search/search.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Employee,
      Partner,
      DoctorProfile,
      TherapistProfile,
      SkillCatalog,
      ProductEmployeeEligibility,
      Product,
      ProductDefinition,
      Booking,
      SpecialistReview,
    ]),
    PartnersModule,
    SearchModule,
  ],
  controllers: [
    PartnerEmployeesController,
    UserEmployeesController,
    EmployeeProfileController,
    EmployeeRevenueController,
  ],
  providers: [
    EmployeesService,
    CreateDoctorHandler,
    CreateTherapistHandler,
    UpdateEmployeeHandler,
    RemoveEmployeeHandler,
    GetEmployeeOverviewAnalyticsHandler,
    GetEmployeeDetailAnalyticsHandler,
    // Employee self-service handlers
    GetEmployeeProfileHandler,
    UpdateEmployeeProfileHandler,
    // Employee revenue handlers
    GetEmployeeRevenueSummaryHandler,
    GetEmployeeRevenueTrendHandler,
    GetEmployeeRevenueBreakdownHandler,
  ],
  exports: [EmployeesService],
})
export class EmployeesModule {}
