import {
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource, In } from 'typeorm';
import { UpdatePartnerHealthServiceDto } from '../../dto/partner/update-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Employee } from '@/common/entities/employee.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';

@Injectable()
export class UpdateHealthServiceHandler {
  private readonly logger = new Logger(UpdateHealthServiceHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    id: string,
    command: UpdatePartnerHealthServiceDto,
    partnerId?: string,
  ): Promise<Product> {
    this.logger.log(`Executing UpdateHealthServiceHandler for ID: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration (Load)
      const existingProduct = await queryRunner.manager.findOne(Product, {
        where: partnerId ? { id, partnerId } : { id },
        relations: ['productDefinition'],
      });

      if (!existingProduct) {
        throw new NotFoundException(`Product with ID ${id} not found`);
      }

      const {
        media,
        productDefinition,
        serviceManual,
        employeeIds,
        tagIds,
        facilityImages,
        ...updateData
      } = command;

      // Null values are already stripped by StripNullPropertiesPipe;
      // only filter out undefined (omitted) fields.
      const sanitizedUpdate = Object.fromEntries(
        Object.entries(updateData).filter(
          ([, value]) => value !== undefined,
        ),
      );

      if (Object.keys(sanitizedUpdate).length > 0) {
        Object.assign(existingProduct, sanitizedUpdate);
      }

      // Update service manual (full replacement)
      if (serviceManual !== undefined) {
        existingProduct.serviceManual = serviceManual;
      }

      // Save product if any fields changed
      if (
        Object.keys(sanitizedUpdate).length > 0 ||
        serviceManual !== undefined
      ) {
        await queryRunner.manager.save(Product, existingProduct);
      }

      // 3. Update Product Definition
      if (
        existingProduct.type === HealthServiceType.SERVICE &&
        productDefinition !== undefined
      ) {
        if (productDefinition === null) {
          await queryRunner.manager.delete(ProductDefinition, {
            productId: id,
          });
        } else {
          const existingDef = await queryRunner.manager.findOne(
            ProductDefinition,
            {
              where: { productId: id },
            },
          );

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
      }

      // 4. Update Media (Full Replacement Policy)
      if (media !== undefined) {
        // Delete all existing media for this product
        await queryRunner.manager.delete(ProductMedia, { productId: id });

        // Insert new (media can be null to clear all)
        if (media && media.length > 0) {
          const mediaEntities = media.map((m) =>
            queryRunner.manager.create(ProductMedia, {
              ...m,
              productId: id,
            }),
          );
          await queryRunner.manager.save(ProductMedia, mediaEntities);
        }
      }

      // 5. Update facility images (full replacement policy)
      if (facilityImages !== undefined) {
        await queryRunner.manager.delete(ProductFacilityImage, {
          productId: id,
        });

        if (facilityImages && facilityImages.length > 0) {
          const facilityEntities = facilityImages.map((facilityImage) =>
            queryRunner.manager.create(ProductFacilityImage, {
              ...facilityImage,
              productId: id,
            }),
          );
          await queryRunner.manager.save(
            ProductFacilityImage,
            facilityEntities,
          );
        }
      }

      // 6. Update staff eligibility (full replacement policy)
      if (employeeIds !== undefined) {
        const uniqueEmployeeIds = [...new Set(employeeIds ?? [])];

        if (uniqueEmployeeIds.length > 0) {
          const employees = await queryRunner.manager.find(Employee, {
            where: {
              id: In(uniqueEmployeeIds),
              ...(partnerId ? { partnerId } : {}),
            },
            select: ['id'],
          });

          if (employees.length !== uniqueEmployeeIds.length) {
            const foundIds = new Set(employees.map((employee) => employee.id));
            const missingIds = uniqueEmployeeIds.filter(
              (employeeId) => !foundIds.has(employeeId),
            );
            throw new NotFoundException(
              `Employee(s) not found: ${missingIds.join(', ')}`,
            );
          }
        }

        await queryRunner.manager.delete(ProductEmployeeEligibility, {
          productId: id,
        });

        if (uniqueEmployeeIds.length > 0) {
          const eligibilityEntities = uniqueEmployeeIds.map((employeeId) =>
            queryRunner.manager.create(ProductEmployeeEligibility, {
              productId: id,
              employeeId,
              isPrimary: false,
            }),
          );
          await queryRunner.manager.save(
            ProductEmployeeEligibility,
            eligibilityEntities,
          );
        }
      }

      // 7. Update feature tags (full replacement policy)
      if (tagIds !== undefined) {
        const uniqueTagIds = [...new Set(tagIds ?? [])];

        // Validate that all tag IDs exist as active ProductFeatureTag records
        if (uniqueTagIds.length > 0) {
          const existingTags = await queryRunner.manager.find(
            ProductFeatureTag,
            {
              where: { id: In(uniqueTagIds), isActive: true },
              select: ['id'],
            },
          );
          if (existingTags.length !== uniqueTagIds.length) {
            const foundIds = new Set(existingTags.map((t) => t.id));
            const missingIds = uniqueTagIds.filter((tid) => !foundIds.has(tid));
            throw new NotFoundException(
              `Feature tag(s) not found or inactive: ${missingIds.join(', ')}`,
            );
          }
        }

        // Delete all existing product-tag junction rows
        await queryRunner.manager.delete(ProductTag, { productId: id });

        // Insert new junction rows
        if (uniqueTagIds.length > 0) {
          const tagEntities = uniqueTagIds.map((tagId) =>
            queryRunner.manager.create(ProductTag, {
              productId: id,
              tagId,
            }),
          );
          await queryRunner.manager.save(ProductTag, tagEntities);
        }
      }

      // 8. Commit
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
          'productTags',
          'productTags.tag',
          'facilityImages',
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
