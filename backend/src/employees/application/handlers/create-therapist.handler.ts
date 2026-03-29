import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateSpaTherapistDto, CreateMassageTherapistDto } from '../../dto/create-therapist.dto';
import { Employee } from '@/common/entities/employee.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';

type CreateTherapistCommand = CreateSpaTherapistDto | CreateMassageTherapistDto;

/**
 * Handler for creating therapist employees with transactional boundaries.
 * Supports both SPA and MASSAGE therapist types.
 * Maps flat DTO fields into Employee + TherapistProfile entities.
 */
@Injectable()
export class CreateTherapistHandler {
  private readonly logger = new Logger(CreateTherapistHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create therapist command within a transaction.
   * @param command - Flat therapist creation data
   * @param therapistType - 'SPA' or 'MASSAGE'
   * @returns The created employee with therapist profile
   */
  async execute(
    command: CreateTherapistCommand,
    therapistType: 'SPA' | 'MASSAGE',
  ): Promise<Employee> {
    this.logger.log(
      `Executing CreateTherapistHandler (${therapistType}) for: ${command.email}`,
    );
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
        workHistory: command.workHistory,
        avatarUrl: command.avatar,
        verificationDocuments: command.verificationDocuments,
        status: command.status,
        description: command.description,
        jobTitle: command.jobTitle,
        partnerId: command.partnerId,
        role: EmployeeRole.THERAPIST,
      });
      const savedEmployee = await queryRunner.manager.save(Employee, employee);

      // 2. Map flat DTO → TherapistProfile entity fields
      const profileData: Partial<TherapistProfile> = {
        employeeId: savedEmployee.id,
        level: command.therapistLevel,
        type: therapistType,
        commissionRate: command.commissionRate,
        healthCheckDate: command.healthCheckDate
          ? new Date(command.healthCheckDate)
          : undefined,
        skills: command.skills,
      };

      // SPA-specific: deviceProficiency
      if (therapistType === 'SPA' && 'deviceProficiency' in command) {
        profileData.deviceProficiency = (command as CreateSpaTherapistDto).deviceProficiency;
      }

      // MASSAGE-specific: strengthLevel
      if (therapistType === 'MASSAGE' && 'strengthLevel' in command) {
        profileData.strengthLevel = (command as CreateMassageTherapistDto).strengthLevel;
      }

      const therapistProfile = queryRunner.manager.create(
        TherapistProfile,
        profileData,
      );
      await queryRunner.manager.save(TherapistProfile, therapistProfile);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(
        `${therapistType} therapist created successfully: ${savedEmployee.id}`,
      );

      // 4. Return complete aggregate
      const completeEmployee = await this.dataSource.manager.findOne(Employee, {
        where: { id: savedEmployee.id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      return completeEmployee!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create ${therapistType} therapist: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        `Transaction failed during ${therapistType} therapist creation`,
      );
    } finally {
      await queryRunner.release();
    }
  }
}
