import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';

/**
 * Handler for removing employees using soft delete.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class RemoveEmployeeHandler {
  private readonly logger = new Logger(RemoveEmployeeHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the remove employee command using soft delete.
   * @param id - The employee ID to remove
   */
  async execute(id: string): Promise<void> {
    this.logger.log(`Executing RemoveEmployeeHandler for: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration: Load employee
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { id },
      });

      if (!employee) {
        throw new NotFoundException(`Employee with ID ${id} not found`);
      }

      // 2. Domain Action: Soft delete employee
      await queryRunner.manager.softRemove(Employee, employee);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Employee soft deleted successfully: ${id}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(
        `Failed to remove employee: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during employee removal',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
