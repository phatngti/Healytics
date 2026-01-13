import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateCategoryDto } from '../../dto/create-category.dto';
import { Category } from '../../entities/category.entity';

/**
 * Handler for creating categories with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class CreateCategoryHandler {
  private readonly logger = new Logger(CreateCategoryHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create category command within a transaction.
   * @param command - The category creation data
   * @returns The created category
   */
  async execute(command: CreateCategoryDto): Promise<Category> {
    this.logger.log(`Executing CreateCategoryHandler for: ${command.name}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Domain Action: Create Category entity
      const category = queryRunner.manager.create(Category, command);
      const savedCategory = await queryRunner.manager.save(Category, category);

      // 2. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Category created successfully: ${savedCategory.id}`);

      // 3. Return complete aggregate with relations
      const completeCategory = await this.dataSource.manager.findOne(Category, {
        where: { id: savedCategory.id },
        relations: ['parent', 'children'],
      });

      return completeCategory!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create category: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during category creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
