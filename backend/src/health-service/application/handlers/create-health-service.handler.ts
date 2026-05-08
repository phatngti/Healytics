import {
  Injectable,
  Logger,
  ConflictException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { RedisService } from '@/redis/redis.service';
import { CreatePartnerHealthServiceDto } from '../../dto/partner/create-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';

@Injectable()
export class CreateHealthServiceHandler {
  private readonly logger = new Logger(CreateHealthServiceHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly redisService: RedisService,
  ) {}

  async execute(command: CreatePartnerHealthServiceDto): Promise<Product> {
    this.logger.log(
      `Executing CreateHealthServiceHandler with name: ${command.name}`,
    );
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const {
        media,
        productDefinition,
        employeeIds,
        facilityImages,
        serviceManual,
        ...baseData
      } = command;

      // 1. Invariant Check (Validate)
      if (baseData.type === HealthServiceType.SERVICE && !productDefinition) {
        throw new ConflictException(
          'Product definition is required for SERVICE type products',
        );
      }

      // 2. Domain Action (Prepare Entity)
      const product = queryRunner.manager.create(Product, {
        ...baseData,
        serviceManual: serviceManual ?? null,
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

      // Handle Product Definition - Relation Management
      if (baseData.type === HealthServiceType.SERVICE && productDefinition) {
        const definitionEntity = queryRunner.manager.create(ProductDefinition, {
          productId: savedProduct.id,
          durationMinutes: productDefinition.durationMinutes,
          bufferMinutes: productDefinition.bufferMinutes ?? 0,
          maxCapacity: productDefinition.maxCapacity ?? 1,
          minLeadTimeHours: productDefinition.minLeadTimeHours ?? 0,
          staffAssignmentType:
            productDefinition.staffAssignmentType ?? StaffAssignmentType.ANY,
        });
        await queryRunner.manager.save(ProductDefinition, definitionEntity);
      }

      // Handle Staff Eligibility - Relation Management
      if (
        baseData.type === HealthServiceType.SERVICE &&
        employeeIds &&
        employeeIds.length > 0
      ) {
        const eligibilityEntities = employeeIds.map((eid) =>
          queryRunner.manager.create(ProductEmployeeEligibility, {
            productId: savedProduct.id,
            employeeId: eid,
            isPrimary: false,
          }),
        );
        await queryRunner.manager.save(
          ProductEmployeeEligibility,
          eligibilityEntities,
        );
      }

      // Handle Facility Images — Relation Management
      if (facilityImages && facilityImages.length > 0) {
        const facilityEntities = facilityImages.map((f) =>
          queryRunner.manager.create(ProductFacilityImage, {
            ...f,
            productId: savedProduct.id,
          }),
        );
        await queryRunner.manager.save(ProductFacilityImage, facilityEntities);
      }

      await queryRunner.commitTransaction();
      this.logger.log(`Product created successfully: ${savedProduct.id}`);

      // 4. Publish Redis event — notify subscribers of new service
      try {
        await this.redisService.publish('new_service_created', savedProduct.id);
      } catch (pubErr) {
        this.logger.warn(
          `Failed to publish new_service_created event for ${savedProduct.id}: ${pubErr.message}`,
        );
      }

      const completeProduct = await this.dataSource.manager.findOne(Product, {
        where: { id: savedProduct.id },
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
