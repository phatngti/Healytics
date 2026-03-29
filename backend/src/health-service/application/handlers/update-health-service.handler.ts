import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpdatePartnerHealthServiceDto } from '../../dto/partner/update-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';

@Injectable()
export class UpdateHealthServiceHandler {
  private readonly logger = new Logger(UpdateHealthServiceHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(id: string, command: UpdatePartnerHealthServiceDto): Promise<Product> {
    this.logger.log(`Executing UpdateHealthServiceHandler for ID: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration (Load)
      const existingProduct = await queryRunner.manager.findOne(Product, {
        where: { id },
        relations: ['productDefinition'],
      });

      if (!existingProduct) {
        throw new NotFoundException(`Product with ID ${id} not found`);
      }

      const { media, productDefinition, serviceManual, ...updateData } = command;

      if (Object.keys(updateData).length > 0) {
        Object.assign(existingProduct, updateData);
      }

      // Update service manual (full replacement)
      if (serviceManual !== undefined) {
        existingProduct.serviceManual = serviceManual;
      }

      // Save product if any fields changed
      if (Object.keys(updateData).length > 0 || serviceManual !== undefined) {
        await queryRunner.manager.save(Product, existingProduct);
      }

      // 3. Update Product Definition
      if (existingProduct.type === HealthServiceType.SERVICE && productDefinition) {
        const existingDef = await queryRunner.manager.findOne(ProductDefinition, {
          where: { productId: id },
        });

        if (existingDef) {
          Object.assign(existingDef, productDefinition);
          await queryRunner.manager.save(ProductDefinition, existingDef);
        } else {
          const newDef = queryRunner.manager.create(ProductDefinition, {
            ...productDefinition,
            productId: id,
          });
          await queryRunner.manager.save(ProductDefinition, newDef);
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
          'productDefinition',
          'productEmployeeEligibilities',
          'productEmployeeEligibilities.employee',
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
