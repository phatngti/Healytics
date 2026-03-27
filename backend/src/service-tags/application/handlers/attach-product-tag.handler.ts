import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';

/**
 * Handler for attaching a service tag to a product.
 * Follows the domain handler pattern with transactional boundaries.
 */
@Injectable()
export class AttachProductTagHandler {
  private readonly logger = new Logger(AttachProductTagHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the attach tag to product command.
   * @param tagId - The ID of the tag to attach
   * @param productId - The ID of the product
   * @param userId - The ID of the user (must own the tag)
   * @returns The created ProductTag entity
   */
  async execute(tagId: string, productId: string, userId: string): Promise<ProductTag> {
    this.logger.log(`Attaching tag ${tagId} to product ${productId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration - Load aggregate with verification
      const tag = await queryRunner.manager.findOne(ProductFeatureTag, {
        where: { id: tagId },
      });

      if (!tag) {
        throw new NotFoundException(`Service tag with ID ${tagId} not found`);
      }

      // 2. Invariant Check - Ownership
      if (tag.userId !== userId) {
        throw new ForbiddenException('You do not have permission to use this tag');
      }

      // 3. Check existing attachment
      const existing = await queryRunner.manager.findOne(ProductTag, {
        where: { productId, tagId },
      });

      if (existing) {
        throw new ConflictException('Tag is already attached to this product');
      }

      // 4. Domain Action - Create attachment
      const productTag = queryRunner.manager.create(ProductTag, {
        productId,
        tagId,
      });

      const savedProductTag = await queryRunner.manager.save(ProductTag, productTag);

      // 5. Side Effect - Increment usage counter
      await queryRunner.manager.increment(ProductFeatureTag, { id: tagId }, 'usage', 1);

      await queryRunner.commitTransaction();
      this.logger.log(`Tag ${tagId} attached to product ${productId}`);

      return savedProductTag;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (
        error instanceof NotFoundException ||
        error instanceof ForbiddenException ||
        error instanceof ConflictException
      ) {
        throw error;
      }
      this.logger.error(`Failed to attach tag: ${error.message}`, error.stack);
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
