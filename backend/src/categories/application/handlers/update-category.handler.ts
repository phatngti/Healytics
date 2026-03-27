import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpdateCategoryDto } from '../../dto/update-category.dto';
import { Category } from '@/common/entities/category.entity';

/**
 * Handler for updating categories with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class UpdateCategoryHandler {
  private readonly logger = new Logger(UpdateCategoryHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the update category command within a transaction.
   * @param id - The category ID to update
   * @param command - The update data
   * @returns The updated category with relations
   */
  async execute(id: string, command: UpdateCategoryDto): Promise<Category> {
    this.logger.log(`Executing UpdateCategoryHandler for: ${id}`);
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

      // 2. Domain Action: Update Category entity
      Object.assign(category, command);
      await queryRunner.manager.save(Category, category);

      // 3. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Category updated successfully: ${id}`);

      // 4. Return complete aggregate with relations
      const completeCategory = await this.dataSource.manager.findOne(Category, {
        where: { id },
        relations: ['parent', 'children'],
      });

      return completeCategory!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      this.logger.error(
        `Failed to update category: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during category update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
