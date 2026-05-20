import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';
import { UpdateEmployeeProfileDto } from '../../dto/employee/update-employee-profile.dto';

/**
 * Handler for employee self-service profile updates.
 * Owns the transaction lifecycle — controllers/services never manage transactions.
 */
@Injectable()
export class UpdateEmployeeProfileHandler {
  private readonly logger = new Logger(UpdateEmployeeProfileHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Updates the employee's own profile with allowed fields only.
   * @param accountId - The authenticated account ID from JWT
   * @param dto - Allowed profile fields to update
   * @returns The updated Employee entity
   */
  async execute(
    accountId: string,
    dto: UpdateEmployeeProfileDto,
  ): Promise<Employee> {
    this.logger.log(`Updating profile for account: ${accountId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Invariant check — employee must exist for this account
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { accountId },
      });

      if (!employee) {
        throw new NotFoundException(
          'Employee profile not found for this account',
        );
      }

      // 2. Apply allowed updates
      if (dto.phone !== undefined) employee.phone = dto.phone;
      if (dto.avatarUrl !== undefined) employee.avatarUrl = dto.avatarUrl;
      if (dto.description !== undefined) employee.description = dto.description;
      if (dto.emergencyContactName !== undefined)
        employee.emergencyContactName = dto.emergencyContactName;
      if (dto.emergencyContactPhone !== undefined)
        employee.emergencyContactPhone = dto.emergencyContactPhone;
      if (dto.schedule !== undefined) employee.schedule = dto.schedule;

      await queryRunner.manager.save(Employee, employee);

      // 3. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Profile updated for employee: ${employee.id}`);

      // Post-commit: reload with relations
      const reloaded = await this.dataSource.manager.findOne(Employee, {
        where: { id: employee.id },
        relations: ['doctorProfile', 'therapistProfile', 'partner'],
      });
      return reloaded!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Profile update failed: ${error.message}`, error.stack);
      if (error instanceof NotFoundException) throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
