import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';

/**
 * Handler for detaching a service tag from a product.
 * Follows the domain handler pattern with transactional boundaries.
 */
@Injectable()
export class DetachProductTagHandler {
  private readonly logger = new Logger(DetachProductTagHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the detach tag from product command.
   * @param tagId - The ID of the tag to detach
   * @param productId - The ID of the product
   * @param userId - The ID of the user (must own the tag)
   */
  async execute(tagId: string, productId: string, userId: string): Promise<void> {
    this.logger.log(`Detaching tag ${tagId} from product ${productId}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration - Verify tag ownership
      const tag = await queryRunner.manager.findOne(ProductFeatureTag, {
        where: { id: tagId },
      });

      if (!tag) {
        throw new NotFoundException(`Service tag with ID ${tagId} not found`);
      }

      // 2. Invariant Check - Ownership
      if (tag.userId !== userId) {
        throw new ForbiddenException('You do not have permission to modify this tag');
      }

      // 3. Find existing attachment
      const productTag = await queryRunner.manager.findOne(ProductTag, {
        where: { productId, tagId },
      });

      if (!productTag) {
        throw new NotFoundException('Tag is not attached to this product');
      }

      // 4. Domain Action - Remove attachment
      await queryRunner.manager.remove(ProductTag, productTag);

      // 5. Side Effect - Decrement usage counter
      if (tag.usage > 0) {
        await queryRunner.manager.decrement(ProductFeatureTag, { id: tagId }, 'usage', 1);
      }

      await queryRunner.commitTransaction();
      this.logger.log(`Tag ${tagId} detached from product ${productId}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (
        error instanceof NotFoundException ||
        error instanceof ForbiddenException
      ) {
        throw error;
      }
      this.logger.error(`Failed to detach tag: ${error.message}`, error.stack);
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
