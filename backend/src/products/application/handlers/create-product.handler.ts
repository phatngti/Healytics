import {
  Injectable,
  Logger,
  ConflictException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CreateProductDto } from '../../dto/create-product.dto';
import { Product } from '@/common/entities/product.entity';
import { ProductType } from '../../enums/product-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ServiceDefinition } from '@/common/entities/service-definition.entity';
import { ServiceEmployeeEligibility } from '@/common/entities/service-employee-eligibility.entity';

@Injectable()
export class CreateProductHandler {
  private readonly logger = new Logger(CreateProductHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: CreateProductDto): Promise<Product> {
    this.logger.log(`Executing CreateProductHandler with name: ${command.name}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const { media, serviceDefinition, employeeIds, ...baseData } = command;

      // 1. Invariant Check (Validate)
      if (baseData.type === ProductType.SERVICE && !serviceDefinition) {
        throw new ConflictException(
          'Service definition is required for SERVICE type products',
        );
      }

      // 2. Domain Action (Prepare Entity)
      // Note: In strict DDD, this would be Product.create(...)
      const product = queryRunner.manager.create(Product, {
        ...baseData,
        currency: 'VND', // Hardcoded as per business rule defaults
      });

      // 3. Persistence & Side Effects
      const savedProduct = await queryRunner.manager.save(Product, product);

      // Handle Media - Relation Management
      if (media && media.length > 0) {
        const mediaEntities = media.map((m) =>
          queryRunner.manager.create(ProductMedia, {
            ...m,
            productId: savedProduct.id,
          }),
        );
        await queryRunner.manager.save(ProductMedia, mediaEntities);
      }

      // Handle Service Definition - Relation Management
      if (baseData.type === ProductType.SERVICE && serviceDefinition) {
        const definitionEntity = queryRunner.manager.create(ServiceDefinition, {
          ...serviceDefinition,
          productId: savedProduct.id,
        });
        await queryRunner.manager.save(ServiceDefinition, definitionEntity);
      }

      // Handle Staff Eligibility - Relation Management
      if (
        baseData.type === ProductType.SERVICE &&
        employeeIds &&
        employeeIds.length > 0
      ) {
        const eligibilityEntities = employeeIds.map((eid) =>
          queryRunner.manager.create(ServiceEmployeeEligibility, {
            productId: savedProduct.id,
            employeeId: eid,
            isPrimary: false,
          }),
        );
        await queryRunner.manager.save(
          ServiceEmployeeEligibility,
          eligibilityEntities,
        );
      }

      await queryRunner.commitTransaction();
      this.logger.log(`Product created successfully: ${savedProduct.id}`);

      // Re-fetch to return complete aggregate (or delegate this to a Query Handler/Service)
      // The original service returned findOne(savedProduct.id).
      // Ideally, Command Handlers return void or the ID, but for compatibility we return the entity.
      // Since we are inside a transaction, we can fetch it using the queryRunner manager to be safe/consistent,
      // but findOne usually queries cleanly. The original service called `this.findOne(savedProduct.id)`.
      // We will duplicate the find logic here using the manager to ensure we see the uncommitted data if we weren't committing yet,
      // but we just committed. So we can use the manager or just return what we have (but we need relations).
      
      const completeProduct = await this.dataSource.manager.findOne(Product, {
        where: { id: savedProduct.id },
        relations: [
          'category',
          'media',
          'serviceDefinition',
          'serviceEmployeeEligibilities',
          'serviceEmployeeEligibilities.employee',
        ],
      });
      
      return completeProduct!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to create product: ${error.message}`,
        error.stack,
      );

      if (error instanceof ConflictException) throw error;
      throw new InternalServerErrorException(
        'Transaction failed during product creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
