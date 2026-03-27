import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmployeesService } from './employees.service';
import { PartnerEmployeesController } from './partner-employees.controller';
import { UserEmployeesController } from './user-employees.controller';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([Employee, Partner, DoctorProfile, TherapistProfile]),
  ],
  controllers: [PartnerEmployeesController, UserEmployeesController],
  providers: [
    EmployeesService,
    CreateDoctorHandler,
    CreateTherapistHandler,
    UpdateEmployeeHandler,
    RemoveEmployeeHandler,
  ],
  exports: [EmployeesService],
})
export class EmployeesModule {}
