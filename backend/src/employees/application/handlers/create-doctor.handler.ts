import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateDoctorDto } from '../../dto/create-doctor.dto';
import { Employee } from '../../entities/employee.entity';
import { DoctorProfile } from '../../entities/doctor-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';

/**
 * Handler for creating doctor employees with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class CreateDoctorHandler {
  private readonly logger = new Logger(CreateDoctorHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create doctor command within a transaction.
   * @param command - The doctor creation data
   * @returns The created employee with doctor profile
   */
  async execute(command: CreateDoctorDto): Promise<Employee> {
    this.logger.log(`Executing CreateDoctorHandler for: ${command.email}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const { profile, ...employeeData } = command;

      // 1. Domain Action: Create Employee entity
      const employee = queryRunner.manager.create(Employee, {
        ...employeeData,
        role: EmployeeRole.DOCTOR,
      });
      const savedEmployee = await queryRunner.manager.save(Employee, employee);

      // 2. Domain Action: Create DoctorProfile entity
      const doctorProfile = queryRunner.manager.create(DoctorProfile, {
        ...profile,
        employeeId: savedEmployee.id,
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
