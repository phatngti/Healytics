import {
  Injectable,
  Logger,
  ConflictException,
  ForbiddenException,
  HttpException,
  InternalServerErrorException,
  NotFoundException,
  Optional,
} from '@nestjs/common';
import { DataSource, In } from 'typeorm';
import { RedisService } from '@/redis/redis.service';
import { CreatePartnerHealthServiceDto } from '../../dto/partner/create-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { HealthServiceType } from '../../enums/health-service-type.enum';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { Category } from '@/common/entities/category.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { SearchIndexOperation } from '@/search/entities/search-index-outbox.entity';
import { SearchIndexOutboxService } from '@/search/services/search-index-outbox.service';

type CreateHealthServiceCommand = CreatePartnerHealthServiceDto & {
  partnerId: string;
};

@Injectable()
export class CreateHealthServiceHandler {
  private readonly logger = new Logger(CreateHealthServiceHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly redisService: RedisService,
    @Optional()
    private readonly searchIndexOutboxService?: SearchIndexOutboxService,
  ) {}

  /**
   * Generates a URL-friendly slug in the format:
   *   {partner_brand_slug}_{product_name_slug}_{6-char-random}
   *
   * Example: "healytics-spa_thai-massage_a1b2c3"
   */
  private buildSlug(brandName: string, productName: string): string {
    const toSlugPart = (str: string): string =>
      str
        .toLowerCase()
        .replace(/[^a-z0-9\s-]/g, '') // strip non-alphanumeric
        .trim()
        .replace(/\s+/g, '-'); // spaces → hyphens

    const random = Math.random().toString(36).slice(2, 8); // 6-char alphanumeric
    return `${toSlugPart(brandName)}_${toSlugPart(productName)}_${random}`;
  }

  async execute(command: CreateHealthServiceCommand): Promise<Product> {
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
        tagIds,
        partnerId,
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        slug: _ignoredSlug, // slug is auto-generated; client value is ignored
        ...baseData
      } = command;
      const uniqueEmployeeIds = [...new Set(employeeIds ?? [])];
      const uniqueTagIds = [...new Set(tagIds ?? [])];

      // 0. Fetch partner to derive brand name for slug generation
      const partner = await queryRunner.manager.findOne(Partner, {
        where: { id: partnerId },
        select: ['id', 'brandName'],
      });
      if (!partner) {
        throw new NotFoundException(`Partner with ID ${partnerId} not found`);
      }

      // 1. Invariant Check (Validate)
      if (baseData.type === HealthServiceType.SERVICE && !productDefinition) {
        throw new ConflictException(
          'Product definition is required for SERVICE type products',
        );
      }

      if (baseData.categoryId) {
        const category = await queryRunner.manager.findOne(Category, {
          where: { id: baseData.categoryId, isActive: true },
          select: ['id', 'parentId'],
        });

        if (!category) {
          throw new NotFoundException(
            `Category with ID ${baseData.categoryId} not found`,
          );
        }
        if (category.parentId == null) {
          throw new ConflictException(
            'Services must be assigned to a sub-category',
          );
        }
      }

      if (
        baseData.type === HealthServiceType.SERVICE &&
        uniqueEmployeeIds.length > 0
      ) {
        const employees = await queryRunner.manager.find(Employee, {
          where: { id: In(uniqueEmployeeIds) },
          select: ['id', 'partnerId'],
        });

        if (employees.length !== uniqueEmployeeIds.length) {
          const foundIds = new Set(employees.map((employee) => employee.id));
          const missingIds = uniqueEmployeeIds.filter(
            (id) => !foundIds.has(id),
          );
          throw new NotFoundException(
            `Employee(s) not found: ${missingIds.join(', ')}`,
          );
        }

        const foreignEmployee = employees.find(
          (employee) => employee.partnerId !== partnerId,
        );
        if (foreignEmployee) {
          throw new ForbiddenException(
            `Employee ${foreignEmployee.id} does not belong to this partner`,
          );
        }
      }

      // 2. Domain Action (Prepare Entity)
      const product = queryRunner.manager.create(Product, {
        ...baseData,
        partnerId,
        slug: this.buildSlug(partner.brandName, command.name),
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
        uniqueEmployeeIds.length > 0
      ) {
        const eligibilityEntities = uniqueEmployeeIds.map((eid) =>
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

      // Handle Feature Tags — Junction Table Management
      if (uniqueTagIds.length > 0) {
        // Validate that all tag IDs exist as active ProductFeatureTag records
        const existingTags = await queryRunner.manager.find(ProductFeatureTag, {
          where: { id: In(uniqueTagIds), isActive: true },
          select: ['id'],
        });
        if (existingTags.length !== uniqueTagIds.length) {
          const foundIds = new Set(existingTags.map((t) => t.id));
          const missingIds = uniqueTagIds.filter((id) => !foundIds.has(id));
          throw new NotFoundException(
            `Feature tag(s) not found or inactive: ${missingIds.join(', ')}`,
          );
        }

        const tagEntities = uniqueTagIds.map((tagId) =>
          queryRunner.manager.create(ProductTag, {
            productId: savedProduct.id,
            tagId,
          }),
        );
        await queryRunner.manager.save(ProductTag, tagEntities);
      }

      await this.searchIndexOutboxService?.enqueueProduct(
        queryRunner.manager,
        savedProduct.id,
        SearchIndexOperation.UPSERT,
        { employeeIds: uniqueEmployeeIds },
      );
      await this.searchIndexOutboxService?.enqueueEmployees(
        queryRunner.manager,
        uniqueEmployeeIds,
      );

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
          'category.parent',
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

      if (error instanceof HttpException) throw error;
      throw new InternalServerErrorException(
        'Transaction failed during product creation',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
