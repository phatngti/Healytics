import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateDoctorDto } from '../../dto/create-doctor.dto';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';

/**
 * Handler for creating doctor employees with transactional boundaries.
 * Maps flat DTO fields into Employee + DoctorProfile entities.
 */
@Injectable()
export class CreateDoctorHandler {
  private readonly logger = new Logger(CreateDoctorHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create doctor command within a transaction.
   * @param command - Flat doctor creation data
   * @returns The created employee with doctor profile
   */
  async execute(command: CreateDoctorDto): Promise<Employee> {
    this.logger.log(`Executing CreateDoctorHandler for: ${command.email}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Map flat DTO → Employee entity fields
      const employee = queryRunner.manager.create(Employee, {
        firstName: command.firstName,
        lastName: command.lastName,
        email: command.email,
        phone: command.phone,
        dob: command.dateOfBirth ? new Date(command.dateOfBirth) : undefined,
        gender: command.gender,
        emergencyContactName: command.emergencyContactName,
        emergencyContactPhone: command.emergencyContactPhone,
        employeeCode: command.employeeId,
        employmentType: command.employmentType,
        startDate: command.startDate ? new Date(command.startDate) : undefined,
        schedule: command.schedule,
        avatarUrl: command.avatar,
        idCardUrl: command.idCardUrl,
        status: command.status,
        branchId: command.branch || undefined,
        password: command.password,
        description: command.description,
        jobTitle: command.jobTitle,
        partnerId: command.partnerId,
        role: EmployeeRole.DOCTOR,
      });
      const savedEmployee = await queryRunner.manager.save(Employee, employee);

      // 2. Map flat DTO → DoctorProfile entity fields
      const doctorProfile = queryRunner.manager.create(DoctorProfile, {
        employeeId: savedEmployee.id,
        medicalTitles: command.medicalTitles,
        medicalLicenses: command.medicalLicenses,
        experienceYears: command.experienceYears,
        consultationFee: command.consultationFee,
        specializations: command.specializations,
        education: command.education,
        certifications: command.certifications,
      });
      await queryRunner.manager.save(DoctorProfile, doctorProfile);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Doctor created successfully: ${savedEmployee.id}`);

      // 4. Return complete aggregate
      const completeEmployee = await this.dataSource.manager.findOne(Employee, {
        where: { id: savedEmployee.id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      return completeEmployee!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create doctor: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during doctor creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
