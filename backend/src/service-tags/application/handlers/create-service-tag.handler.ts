import {
  Injectable,
  Logger,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateServiceTagDto } from '../../dto/create-service-tag.dto';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';

/**
 * Handler for creating a new service tag.
 * Follows the domain handler pattern with transactional boundaries.
 */
@Injectable()
export class CreateServiceTagHandler {
  private readonly logger = new Logger(CreateServiceTagHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the create service tag command.
   * @param command - The DTO containing tag creation data
   * @param userId - The ID of the user (partner) creating the tag
   * @returns The created ServiceTag entity
   */
  async execute(command: CreateServiceTagDto, userId: string): Promise<ProductFeatureTag> {
    this.logger.log(`Executing CreateProductFeatureTagHandler for user: ${userId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Domain Action (Prepare Entity)
      const tag = queryRunner.manager.create(ProductFeatureTag, {
        ...command,
        userId,
        colorValue: command.colorValue ?? '#FF6366F1',
        isActive: command.isActive ?? true,
        sortOrder: command.sortOrder ?? 0,
      });

      // 2. Persistence
      const savedTag = await queryRunner.manager.save(ProductFeatureTag, tag);

      await queryRunner.commitTransaction();
      this.logger.log(`Service tag created successfully: ${savedTag.id}`);

      // 3. Return complete entity
      return savedTag;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create service tag: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during service tag creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
