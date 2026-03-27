import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpdateEmployeeDto } from '../../dto/update-employee.dto';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';

/**
 * Handler for updating employees with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class UpdateEmployeeHandler {
  private readonly logger = new Logger(UpdateEmployeeHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the update employee command within a transaction.
   * @param id - The employee ID to update
   * @param command - The update data
   * @returns The updated employee with relations
   */
  async execute(id: string, command: UpdateEmployeeDto): Promise<Employee> {
    this.logger.log(`Executing UpdateEmployeeHandler for: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration: Load employee
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      if (!employee) {
        throw new NotFoundException(`Employee with ID ${id} not found`);
      }

      const { doctorProfile, therapistProfile, ...employeeData } = command;

      // 2. Domain Action: Update Employee entity
      Object.assign(employee, employeeData);
      await queryRunner.manager.save(Employee, employee);

      // 3. Domain Action: Update Doctor Profile if applicable
      if (doctorProfile && employee.role === EmployeeRole.DOCTOR) {
        let profile = await queryRunner.manager.findOne(DoctorProfile, {
          where: { employeeId: id },
        });
        if (profile) {
          Object.assign(profile, doctorProfile);
        } else {
          profile = queryRunner.manager.create(DoctorProfile, {
            ...doctorProfile,
            employeeId: id,
          });
        }
        await queryRunner.manager.save(DoctorProfile, profile);
      }

      // 4. Domain Action: Update Therapist Profile if applicable
      if (therapistProfile && employee.role === EmployeeRole.THERAPIST) {
        let profile = await queryRunner.manager.findOne(TherapistProfile, {
          where: { employeeId: id },
        });
        if (profile) {
          Object.assign(profile, therapistProfile);
        } else {
          profile = queryRunner.manager.create(TherapistProfile, {
            ...therapistProfile,
            employeeId: id,
          });
        }
        await queryRunner.manager.save(TherapistProfile, profile);
      }

      // 5. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Employee updated successfully: ${id}`);

      // 6. Return complete aggregate
      const completeEmployee = await this.dataSource.manager.findOne(Employee, {
        where: { id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      return completeEmployee!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(
        `Failed to update employee: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during employee update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
