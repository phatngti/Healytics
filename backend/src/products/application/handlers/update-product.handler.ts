import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpdateProductDto } from '../../dto/update-product.dto';
import { Product } from '@/common/entities/product.entity';
import { ProductType } from '../../enums/product-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ServiceDefinition } from '@/common/entities/service-definition.entity';

@Injectable()
export class UpdateProductHandler {
  private readonly logger = new Logger(UpdateProductHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(id: string, command: UpdateProductDto): Promise<Product> {
    this.logger.log(`Executing UpdateProductHandler for ID: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration (Load) with pessimistic lock if needed (not strictly needed here unless high concurrency expected)
      const existingProduct = await queryRunner.manager.findOne(Product, {
        where: { id },
        relations: ['serviceDefinition'],
      });

      if (!existingProduct) {
        throw new NotFoundException(`Product with ID ${id} not found`);
      }

      const { media, serviceDefinition, ...updateData } = command;

      // 2. Domain Action (Mutate)
      if (Object.keys(updateData).length > 0) {
        Object.assign(existingProduct, updateData);
        await queryRunner.manager.save(Product, existingProduct);
      }

      // 3. Update Service Definition
      if (existingProduct.type === ProductType.SERVICE && serviceDefinition) {
        const existingDef = await queryRunner.manager.findOne(ServiceDefinition, {
          where: { productId: id },
        });

        if (existingDef) {
          Object.assign(existingDef, serviceDefinition);
          await queryRunner.manager.save(ServiceDefinition, existingDef);
        } else {
          const newDef = queryRunner.manager.create(ServiceDefinition, {
            ...serviceDefinition,
            productId: id,
          });
          await queryRunner.manager.save(ServiceDefinition, newDef);
        }
      }

      // 4. Update Media (Full Replacement Policy)
      if (media !== undefined) {
        // Delete all existing media for this product
        await queryRunner.manager.delete(ProductMedia, { productId: id });

        // Insert new
        if (media.length > 0) {
          const mediaEntities = media.map((m) =>
            queryRunner.manager.create(ProductMedia, {
              ...m,
              productId: id,
            }),
          );
          await queryRunner.manager.save(ProductMedia, mediaEntities);
        }
      }

      // 5. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Product updated successfully: ${id}`);

      const updatedProduct = await this.dataSource.manager.findOne(Product, {
        where: { id },
        relations: [
          'category',
          'media',
          'serviceDefinition',
          'serviceEmployeeEligibilities',
          'serviceEmployeeEligibilities.employee',
        ],
      });
      return updatedProduct!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to update product ${id}: ${error.message}`,
        error.stack,
      );

      if (error instanceof NotFoundException) throw error;
      throw new InternalServerErrorException(
        'Transaction failed during product update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
