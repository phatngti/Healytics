import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';
import { ServiceDefinition } from '@/common/entities/service-definition.entity';
import { ServiceResourceRequirement } from '@/common/entities/service-resource-requirement.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ServiceEmployeeEligibility } from '@/common/entities/service-employee-eligibility.entity';
import { ServiceTag } from '@/common/entities/service-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Account } from '@/common/entities/account.entity';
import { Role } from '@/account/enum/role.enum';
import { ProductType } from '@/products/enums/product-type.enum';
import { ProductStatus } from '@/products/enums/product-status.enum';
import { StaffAssignmentType } from '@/products/enums/staff-assignment-type.enum';
import { ISeeder } from '../seeder.interface';

/**
 * Seed data for products with full service details.
 * `categorySlug` resolves to `categoryId` FK.
 * SERVICE-type products include: serviceDefinition, resourceRequirements,
 * tagNames (linked via product_tags), and eligibleEmployees.
 */
const SEED_PRODUCTS = [
  {
    name: 'Full Body Massage 60 Min',
    slug: 'full-body-massage-60-min',
    description: 'Full body relaxation massage — 60 minutes',
    type: ProductType.SERVICE,
    basePrice: 350000,
    categorySlug: 'relaxation-massage',
    serviceDefinition: {
      durationMinutes: 60,
      bufferMinutes: 10,
      maxCapacity: 1,
      minLeadTimeHours: 2,
      staffAssignmentType: StaffAssignmentType.ANY,
    },
    resourceRequirements: [
      { resourceTypeName: 'Massage Room', quantityRequired: 1 },
      { resourceTypeName: 'Massage Oil Set', quantityRequired: 1 },
    ],
    tagNames: ['Relaxation'],
    eligibleEmployees: [
      { code: 'EMP-002', isPrimary: true },
    ],
  },
  {
    name: 'Neck & Shoulder Therapy',
    slug: 'neck-shoulder-therapy',
    description: 'Therapeutic treatment for neck and shoulder pain',
    type: ProductType.SERVICE,
    basePrice: 400000,
    categorySlug: 'rehabilitation-massage',
    serviceDefinition: {
      durationMinutes: 45,
      bufferMinutes: 15,
      maxCapacity: 1,
      minLeadTimeHours: 1,
      staffAssignmentType: StaffAssignmentType.SPECIFIC,
    },
    resourceRequirements: [
      { resourceTypeName: 'Therapy Room', quantityRequired: 1 },
    ],
    tagNames: ['Pain Relief', 'Rehabilitation'],
    eligibleEmployees: [
      { code: 'EMP-001', isPrimary: true },
      { code: 'EMP-002', isPrimary: false },
    ],
  },
  {
    name: 'Basic Facial Care Package',
    slug: 'basic-facial-care-package',
    description: 'Essential facial skincare treatment package',
    type: ProductType.SERVICE,
    basePrice: 500000,
    categorySlug: 'spa-beauty',
    serviceDefinition: {
      durationMinutes: 90,
      bufferMinutes: 15,
      maxCapacity: 1,
      minLeadTimeHours: 4,
      staffAssignmentType: StaffAssignmentType.ANY,
    },
    resourceRequirements: [
      { resourceTypeName: 'Facial Treatment Room', quantityRequired: 1 },
      { resourceTypeName: 'Skincare Product Kit', quantityRequired: 1 },
    ],
    tagNames: ['Beauty', 'Skincare'],
    eligibleEmployees: [
      { code: 'EMP-002', isPrimary: true },
    ],
  },
  {
    name: 'Professional Teeth Whitening',
    slug: 'professional-teeth-whitening',
    description: 'Professional in-office teeth whitening service',
    type: ProductType.SERVICE,
    basePrice: 1500000,
    categorySlug: 'dental',
    serviceDefinition: {
      durationMinutes: 120,
      bufferMinutes: 30,
      maxCapacity: 1,
      minLeadTimeHours: 24,
      staffAssignmentType: StaffAssignmentType.SPECIFIC,
    },
    resourceRequirements: [
      { resourceTypeName: 'Dental Chair', quantityRequired: 1 },
      { resourceTypeName: 'Whitening Kit', quantityRequired: 1 },
    ],
    tagNames: ['Beauty'],
    eligibleEmployees: [
      { code: 'EMP-001', isPrimary: true },
    ],
  },
  {
    name: 'Sunscreen SPF50 Broad Spectrum',
    slug: 'sunscreen-spf50-broad-spectrum',
    description: 'Broad spectrum SPF50 PA+++ sunscreen',
    type: ProductType.PHYSICAL,
    basePrice: 280000,
    categorySlug: 'dermatology',
    // Physical product — no service details
  },
];

@Injectable()
export class ProductSeeder implements ISeeder {
  private readonly logger = new Logger(ProductSeeder.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,

    @InjectRepository(ServiceDefinition)
    private readonly serviceDefRepo: Repository<ServiceDefinition>,

    @InjectRepository(ServiceResourceRequirement)
    private readonly resourceReqRepo: Repository<ServiceResourceRequirement>,

    @InjectRepository(ResourceType)
    private readonly resourceTypeRepo: Repository<ResourceType>,

    @InjectRepository(ServiceTag)
    private readonly serviceTagRepo: Repository<ServiceTag>,

    @InjectRepository(ProductTag)
    private readonly productTagRepo: Repository<ProductTag>,

    @InjectRepository(ServiceEmployeeEligibility)
    private readonly eligibilityRepo: Repository<ServiceEmployeeEligibility>,

    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,

    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding products...');

    // Pre-load lookup maps
    const categories = await this.categoryRepo.find();
    const categoryMap = new Map(categories.map((c) => [c.slug, c.id]));

    const employees = await this.employeeRepo.find();
    const employeeMap = new Map(employees.map((e) => [e.employeeCode, e.id]));

    // Find admin user for service tag lookup
    const adminUser = await this.accountRepo.findOne({ where: { role: Role.ADMIN } });

    for (const prodData of SEED_PRODUCTS) {
      const exists = await this.productRepo.findOne({
        where: { slug: prodData.slug },
      });

      if (exists) {
        this.logger.log(`  ⏭ Product "${prodData.name}" already exists, skipping`);
        continue;
      }

      const categoryId = categoryMap.get(prodData.categorySlug) || null;
      if (!categoryId) {
        this.logger.warn(`  ⚠ Category "${prodData.categorySlug}" not found — product "${prodData.name}" will have null categoryId`);
      }

      // 1. Create the product
      const product = this.productRepo.create({
        name: prodData.name,
        slug: prodData.slug,
        description: prodData.description,
        type: prodData.type,
        basePrice: prodData.basePrice,
        currency: 'VND',
        status: ProductStatus.ACTIVE,
        isVisibleOnline: true,
        categoryId,
      });

      await this.productRepo.save(product);
      this.logger.log(`  ✅ Created product "${prodData.name}" (${prodData.type})`);

      // Only seed service details for SERVICE-type products
      if (prodData.type !== ProductType.SERVICE) continue;

      // 2. Service Definition (1:1)
      if (prodData.serviceDefinition) {
        const serviceDef = this.serviceDefRepo.create({
          productId: product.id,
          ...prodData.serviceDefinition,
        });
        await this.serviceDefRepo.save(serviceDef);
        this.logger.log(`    📋 Service definition: ${prodData.serviceDefinition.durationMinutes}min + ${prodData.serviceDefinition.bufferMinutes}min buffer`);
      }

      // 3. Resource Requirements (upsert ResourceType, then create requirement)
      if (prodData.resourceRequirements?.length) {
        for (const req of prodData.resourceRequirements) {
          let resourceType = await this.resourceTypeRepo.findOne({
            where: { name: req.resourceTypeName },
          });

          if (!resourceType) {
            resourceType = this.resourceTypeRepo.create({
              name: req.resourceTypeName,
              totalQuantity: 5, // default seed quantity
            });
            await this.resourceTypeRepo.save(resourceType);
            this.logger.log(`    🏗️ Created resource type "${req.resourceTypeName}"`);
          }

          const resourceReq = this.resourceReqRepo.create({
            productId: product.id,
            resourceTypeId: resourceType.id,
            quantityRequired: req.quantityRequired,
          });
          await this.resourceReqRepo.save(resourceReq);
          this.logger.log(`    🔧 Resource requirement: ${req.quantityRequired}x "${req.resourceTypeName}"`);
        }
      }

      // 4. Service Tags (via product_tags junction)
      if (prodData.tagNames?.length && adminUser) {
        for (const tagName of prodData.tagNames) {
          const tag = await this.serviceTagRepo.findOne({
            where: { name: tagName, userId: adminUser.id },
          });

          if (!tag) {
            this.logger.warn(`    ⚠ Service tag "${tagName}" not found — skipping tag assignment`);
            continue;
          }

          const existingTag = await this.productTagRepo.findOne({
            where: { productId: product.id, tagId: tag.id },
          });

          if (!existingTag) {
            const productTag = this.productTagRepo.create({
              productId: product.id,
              tagId: tag.id,
            });
            await this.productTagRepo.save(productTag);
            this.logger.log(`    🏷️ Tagged with "${tagName}"`);
          }
        }
      }

      // 5. Employee Eligibility
      if (prodData.eligibleEmployees?.length) {
        for (const emp of prodData.eligibleEmployees) {
          const employeeId = employeeMap.get(emp.code);

          if (!employeeId) {
            this.logger.warn(`    ⚠ Employee "${emp.code}" not found — skipping eligibility`);
            continue;
          }

          const eligibility = this.eligibilityRepo.create({
            productId: product.id,
            employeeId,
            isPrimary: emp.isPrimary,
          });
          await this.eligibilityRepo.save(eligibility);
          this.logger.log(`    👤 Employee "${emp.code}" eligible${emp.isPrimary ? ' (primary)' : ''}`);
        }
      }
    }

    this.logger.log('Products seeding completed');
  }

  async clear(): Promise<void> {
    const slugs = SEED_PRODUCTS.map((p) => p.slug);

    // Products cascade-delete child rows (service_definitions, service_resource_requirements,
    // product_tags, service_employee_eligibility), so we only need to hard-delete products + resource_types.
    const { affected: productAffected } = await this.productRepo.delete({ slug: In(slugs) });
    if (!productAffected) {
      this.logger.warn('⚠ No seed products found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${productAffected} seed product(s) (+ cascaded child rows)`);
    }

    // Clean up resource_types created during seeding
    const resourceTypeNames = [
      ...new Set(
        SEED_PRODUCTS
          .flatMap((p) => (p as any).resourceRequirements || [])
          .map((r: any) => r.resourceTypeName),
      ),
    ];

    if (resourceTypeNames.length) {
      const { affected: rtAffected } = await this.resourceTypeRepo.delete({ name: In(resourceTypeNames) });
      if (!rtAffected) {
        this.logger.warn('⚠ No seed resource types found to delete');
      } else {
        this.logger.log(`🗑️ Hard-deleted ${rtAffected} seed resource type(s)`);
      }
    }
  }
}
