import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateTherapistDto } from '../../dto/create-therapist.dto';
import { Employee } from '@/common/entities/employee.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';

/**
 * Handler for creating therapist employees with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class CreateTherapistHandler {
  private readonly logger = new Logger(CreateTherapistHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create therapist command within a transaction.
   * @param command - The therapist creation data
   * @returns The created employee with therapist profile
   */
  async execute(command: CreateTherapistDto): Promise<Employee> {
    this.logger.log(`Executing CreateTherapistHandler for: ${command.email}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const { profile, ...employeeData } = command;

      // 1. Domain Action: Create Employee entity
      const employee = queryRunner.manager.create(Employee, {
        ...employeeData,
        role: EmployeeRole.THERAPIST,
      });
      const savedEmployee = await queryRunner.manager.save(Employee, employee);

      // 2. Domain Action: Create TherapistProfile entity
      const therapistProfile = queryRunner.manager.create(TherapistProfile, {
        ...profile,
        employeeId: savedEmployee.id,
      });
      await queryRunner.manager.save(TherapistProfile, therapistProfile);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Therapist created successfully: ${savedEmployee.id}`);

      // 4. Return complete aggregate
      const completeEmployee = await this.dataSource.manager.findOne(Employee, {
        where: { id: savedEmployee.id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      return completeEmployee!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create therapist: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during therapist creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
