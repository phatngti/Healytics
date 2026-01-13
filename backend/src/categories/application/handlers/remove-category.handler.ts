import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Category } from '../../entities/category.entity';

/**
 * Handler for removing categories using soft delete.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class RemoveCategoryHandler {
  private readonly logger = new Logger(RemoveCategoryHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the remove category command using soft delete.
   * @param id - The category ID to remove
   */
  async execute(id: string): Promise<void> {
    this.logger.log(`Executing RemoveCategoryHandler for: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration: Load category
      const category = await queryRunner.manager.findOne(Category, {
        where: { id },
      });

      if (!category) {
        throw new NotFoundException(`Category with ID ${id} not found`);
      }

      // 2. Domain Action: Soft delete category
      await queryRunner.manager.softRemove(Category, category);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Category soft deleted successfully: ${id}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(
        `Failed to remove category: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during category removal',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
