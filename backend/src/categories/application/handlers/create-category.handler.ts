import {
  BadRequestException,
  Injectable,
  Logger,
  HttpException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';
import { CreateCategoryDto } from '../../dto/create-category.dto';
import { Category } from '@/common/entities/category.entity';

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
      await this.validateParent(queryRunner.manager, command.parentId);

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
      if (error instanceof HttpException) throw error;
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

  private async validateParent(
    manager: EntityManager,
    parentId?: string,
  ): Promise<void> {
    if (!parentId) return;

    const parent = await manager.findOne(Category, {
      where: { id: parentId, isActive: true },
      select: ['id', 'parentId'],
    });

    if (!parent) {
      throw new BadRequestException('Parent category must be active and exist');
    }

    if (parent.parentId != null) {
      throw new BadRequestException(
        'Sub-categories can only belong to a root category',
      );
    }
  }
}
