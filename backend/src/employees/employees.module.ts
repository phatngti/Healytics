import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EmployeesService } from './employees.service';
import { EmployeesController } from './employees.controller';
import { Employee } from './entities/employee.entity';
import { DoctorProfile } from './entities/doctor-profile.entity';
import { TherapistProfile } from './entities/therapist-profile.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Employee, DoctorProfile, TherapistProfile]),
  ],
  controllers: [EmployeesController],
  providers: [EmployeesService],
  exports: [EmployeesService],
})
export class EmployeesModule {}
