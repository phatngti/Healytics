import { Injectable, NotFoundException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull, SelectQueryBuilder } from 'typeorm';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { Category } from '@/common/entities/category.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { CategoryResponseDto } from './dto/category-response.dto';
import { AdminCategoryResponseDto } from './dto/admin-category-response.dto';
import { BookingSpecialistResponseDto } from './dto/booking-specialist-response.dto';
import { BookingServiceResponseDto } from '@/employees/dto/booking-service-response.dto';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { PartnersService } from '@/partners/partners.service';
import {
  PublicServiceListQueryDto,
  PublicServiceListSort,
} from '@/health-service/dto/public/service-list-query.dto';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';
import { ElasticsearchBookingService } from '@/search/services/elasticsearch-booking.service';

/**
 * Service facade for managing product categories.
 * Delegates mutation operations to dedicated handlers.
 * Supports hierarchical categories with parent-child relationships.
 */
@Injectable()
export class CategoriesService {
  private readonly logger = new Logger(CategoriesService.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepository: Repository<ProductEmployeeEligibility>,
    private readonly partnersService: PartnersService,
    private readonly createCategoryHandler: CreateCategoryHandler,
    private readonly updateCategoryHandler: UpdateCategoryHandler,
    private readonly removeCategoryHandler: RemoveCategoryHandler,
    private readonly elasticsearchBookingService: ElasticsearchBookingService,
  ) {}

  /**
   * Facade: Delegates to CreateCategoryHandler.
   * @param createCategoryDto - The category data
   * @returns The created category response DTO
   */
  async create(
    createCategoryDto: CreateCategoryDto,
  ): Promise<CategoryResponseDto> {
    const entity = await this.createCategoryHandler.execute(createCategoryDto);
    return CategoryResponseDto.fromEntity(entity);
  }

  /**
   * Retrieves all categories with their relations.
   * @param rootsOnly - If true, return only root categories
   * @returns Array of category response DTOs
   */
  async findAll(rootsOnly = false): Promise<CategoryResponseDto[]> {
    if (rootsOnly) {
      const roots = await this.findRoots();
      return CategoryResponseDto.fromEntities(roots);
    }
    const categories = await this.categoryRepository.find({
      relations: ['parent', 'children'],
      order: { name: 'ASC' },
    });
    return CategoryResponseDto.fromEntities(categories);
  }

  /**
   * Retrieves only root categories (those without a parent).
   * @returns Array of root categories (raw entities for internal use)
   */
  private async findRoots(): Promise<Category[]> {
    return this.categoryRepository.find({
      where: { parentId: IsNull() },
      relations: ['children'],
      order: { sortOrder: 'ASC', name: 'ASC' },
    });
  }

  async resolveBookableCategoryIds(categoryId: string): Promise<string[]> {
    const category = await this.categoryRepository.findOne({
      where: { id: categoryId },
      relations: ['children'],
    });
    if (!category) {
      this.logger.warn(`Category not found: ${categoryId}`);
      throw new NotFoundException(`Category with ID ${categoryId} not found`);
    }

    if (category.parentId == null) {
      return (category.children ?? [])
        .filter((child) => child.isActive && child.deletedAt == null)
        .map((child) => child.id);
    }

    return [category.id];
  }

  /**
   * Finds a category by ID.
   * @param id - The category ID
   * @returns The category response DTO
   * @throws NotFoundException if not found
   */
  async findOne(id: string): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { id },
      relations: ['parent', 'children'],
    });
    if (!category) {
      this.logger.warn(`Category not found: ${id}`);
      throw new NotFoundException(`Category with ID ${id} not found`);
    }
    return CategoryResponseDto.fromEntity(category);
  }

  /**
   * Finds a category by slug.
   * @param slug - The category slug
   * @returns The category response DTO
   * @throws NotFoundException if not found
   */
  async findBySlug(slug: string): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findOne({
      where: { slug },
      relations: ['parent', 'children'],
    });
    if (!category) {
      this.logger.warn(`Category slug not found: ${slug}`);
      throw new NotFoundException(`Category with slug "${slug}" not found`);
    }
    return CategoryResponseDto.fromEntity(category);
  }

  /**
   * Facade: Delegates to UpdateCategoryHandler.
   * @param id - The category ID
   * @param updateCategoryDto - The update data
   * @returns The updated category response DTO
   */
  async update(
    id: string,
    updateCategoryDto: UpdateCategoryDto,
  ): Promise<CategoryResponseDto> {
    const entity = await this.updateCategoryHandler.execute(
      id,
      updateCategoryDto,
    );
    return CategoryResponseDto.fromEntity(entity);
  }

  /**
   * Facade: Delegates to RemoveCategoryHandler.
   * @param id - The category ID
   */
  /**
   * Returns specialists (employees) who serve the given category.
   * Query path: Category → Products → ProductEmployeeEligibility → Employee.
   * Deduplicates employees (one employee may offer multiple services in the same category).
   */
  async findSpecialistsByCategory(
    categoryId: string,
  ): Promise<BookingSpecialistResponseDto[]> {
    const categoryIds = await this.resolveBookableCategoryIds(categoryId);
    if (categoryIds.length === 0) return [];

    // Query eligible employees via the join chain, retaining the eligibility record
    const eligibilities = await this.eligibilityRepository
      .createQueryBuilder('elig')
      .innerJoinAndSelect('elig.employee', 'emp')
      .innerJoin('elig.product', 'prod')
      .where('prod.category_id IN (:...categoryIds)', { categoryIds })
      .andWhere('prod.status = :activeStatus', {
        activeStatus: HealthServiceStatus.ACTIVE,
      })
      .andWhere('emp.status = :empStatus', {
        empStatus: EmployeeStatus.ACTIVE,
      })
      .getMany();

    // Deduplicate by employee ID, keeping the first eligibility record per employee
    const seen = new Set<string>();
    const uniqueEligibilities = eligibilities.filter((elig) => {
      if (!elig.employee || seen.has(elig.employee.id)) return false;
      seen.add(elig.employee.id);
      return true;
    });

    return uniqueEligibilities.map((elig) =>
      BookingSpecialistResponseDto.fromEntity(elig.employee, elig.id),
    );
  }

  /**
   * Returns all active services (products) in the given category.
   * Used by the Book Appointment flow Step 1 (Category → Services).
   * Includes clinic info from the health partner and optional distance calculation.
   */
  async findServicesByCategory(
    categoryId: string,
    query: PublicServiceListQueryDto = {},
  ): Promise<BookingServiceResponseDto[]> {
    const categoryIds = await this.resolveBookableCategoryIds(categoryId);
    if (categoryIds.length === 0) return [];

    const qb = this.productRepository
      .createQueryBuilder('product')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('category.parent', 'parentCategory')
      .leftJoinAndSelect('product.media', 'media')
      .leftJoinAndSelect('product.productDefinition', 'productDefinition')
      .leftJoinAndSelect('product.partner', 'partner')
      .leftJoinAndSelect('partner.province', 'province')
      .leftJoinAndSelect('partner.district', 'district')
      .leftJoinAndSelect('partner.ward', 'ward')
      .where('product.category_id IN (:...categoryIds)', { categoryIds })
      .andWhere('product.status = :activeStatus', {
        activeStatus: HealthServiceStatus.ACTIVE,
      });

    const serviceIds = await this.resolveTextFilteredServiceIds(query);
    if (serviceIds) {
      if (serviceIds.length === 0) {
        qb.andWhere('1 = 0');
      } else {
        qb.andWhere('product.id IN (:...textFilteredServiceIds)', {
          textFilteredServiceIds: serviceIds,
        });
      }
    } else {
      this.applySqlTextFilters(qb, query);
    }
    if (query.minPrice != null) {
      qb.andWhere(
        'COALESCE(product.sale_price, product.base_price) >= :minPrice',
        {
          minPrice: query.minPrice,
        },
      );
    }
    if (query.maxPrice != null) {
      qb.andWhere(
        'COALESCE(product.sale_price, product.base_price) <= :maxPrice',
        {
          maxPrice: query.maxPrice,
        },
      );
    }

    switch (query.sort) {
      case PublicServiceListSort.PRICE_ASC:
        qb.orderBy('COALESCE(product.sale_price, product.base_price)', 'ASC');
        break;
      case PublicServiceListSort.PRICE_DESC:
        qb.orderBy('COALESCE(product.sale_price, product.base_price)', 'DESC');
        break;
      case PublicServiceListSort.LATEST:
      case PublicServiceListSort.RATING_DESC:
      case PublicServiceListSort.DEFAULT:
      default:
        qb.orderBy('product.created_at', 'DESC');
        break;
    }

    const products = await qb.getMany();

    return BookingServiceResponseDto.fromEntities(
      products,
      null,
      query.lat,
      query.lng,
    );
  }

  async remove(id: string): Promise<void> {
    return this.removeCategoryHandler.execute(id);
  }

  private async resolveTextFilteredServiceIds(
    query: PublicServiceListQueryDto,
  ): Promise<string[] | null> {
    if (!this.elasticsearchBookingService.isAvailable) return null;

    const filters = serviceTextFilters(query);
    if (filters.length === 0) return null;

    let intersection: Set<string> | null = null;
    for (const filter of filters) {
      const ids = await this.elasticsearchBookingService.searchServiceIds(
        filter.value,
        filter.fields,
      );
      const current = new Set(ids);
      intersection =
        intersection == null
          ? current
          : new Set([...intersection].filter((id) => current.has(id)));

      if (intersection.size === 0) return [];
    }

    return intersection ? [...intersection] : null;
  }

  private applySqlTextFilters(
    qb: SelectQueryBuilder<Product>,
    query: PublicServiceListQueryDto,
  ): void {
    const clinic = textQuery(query.clinic, query.clinicId);
    if (clinic) {
      qb.andWhere(
        `(
          partner.brandName ILIKE :clinicText
          OR partner.legalName ILIKE :clinicText
          OR partner.streetAddress ILIKE :clinicText
        )`,
        { clinicText: `%${clinic}%` },
      );
    }

    const province = textQuery(query.province, query.provinceId);
    if (province) {
      qb.andWhere(
        `(
          province.fullName ILIKE :provinceText
          OR province.name ILIKE :provinceText
          OR province.nameEn ILIKE :provinceText
        )`,
        { provinceText: `%${province}%` },
      );
    }

    const district = textQuery(query.district, query.districtId);
    if (district) {
      qb.andWhere(
        `(
          district.fullName ILIKE :districtText
          OR district.name ILIKE :districtText
          OR district.nameEn ILIKE :districtText
        )`,
        { districtText: `%${district}%` },
      );
    }

    const ward = textQuery(query.ward, query.wardId);
    if (ward) {
      qb.andWhere(
        `(
          ward.fullName ILIKE :wardText
          OR ward.name ILIKE :wardText
          OR ward.nameEn ILIKE :wardText
        )`,
        { wardText: `%${ward}%` },
      );
    }
  }

  /**
   * Retrieves all categories for admin, including iconName, colorValue, sortOrder,
   * and a computed serviceCount (number of products using this category).
   */
  async findAllForAdmin(): Promise<AdminCategoryResponseDto[]> {
    const categories = await this.categoryRepository
      .createQueryBuilder('cat')
      .leftJoinAndSelect('cat.parent', 'parent')
      .leftJoinAndSelect('cat.children', 'children')
      .orderBy('cat.sortOrder', 'ASC')
      .addOrderBy('cat.name', 'ASC')
      .withDeleted()
      .where('cat.deletedAt IS NULL')
      .getMany();

    return AdminCategoryResponseDto.fromEntities(
      await this.withAdminServiceCounts(categories),
    );
  }

  /**
   * Retrieves a single category for admin by ID, including computed serviceCount.
   */
  async findOneForAdmin(id: string): Promise<AdminCategoryResponseDto> {
    const category = await this.categoryRepository
      .createQueryBuilder('cat')
      .leftJoinAndSelect('cat.parent', 'parent')
      .leftJoinAndSelect('cat.children', 'children')
      .where('cat.id = :id', { id })
      .getOne();

    if (!category) {
      this.logger.warn(`Category not found: ${id}`);
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    const [withCounts] = await this.withAdminServiceCounts([category]);
    return AdminCategoryResponseDto.fromEntity(withCounts);
  }

  /**
   * Facade for admin create: delegates to handler then returns admin DTO with serviceCount.
   */
  async createForAdmin(
    createCategoryDto: CreateCategoryDto,
  ): Promise<AdminCategoryResponseDto> {
    const entity = await this.createCategoryHandler.execute(createCategoryDto);
    return this.findOneForAdmin(entity.id);
  }

  /**
   * Facade for admin update: delegates to handler then returns admin DTO with serviceCount.
   */
  async updateForAdmin(
    id: string,
    updateCategoryDto: UpdateCategoryDto,
  ): Promise<AdminCategoryResponseDto> {
    await this.updateCategoryHandler.execute(id, updateCategoryDto);
    return this.findOneForAdmin(id);
  }

  private async withAdminServiceCounts(
    categories: Category[],
  ): Promise<(Category & { serviceCount: number })[]> {
    if (categories.length === 0) return [];

    const rows = await this.categoryRepository.query(`
      SELECT
        cat.id,
        COUNT(product.id)::int AS "serviceCount"
      FROM categories cat
      LEFT JOIN categories child
        ON child.parent_id = cat.id
        AND child.deleted_at IS NULL
        AND child.is_active = true
      LEFT JOIN products product
        ON (
          (cat.parent_id IS NULL AND product.category_id = child.id)
          OR (cat.parent_id IS NOT NULL AND product.category_id = cat.id)
        )
        AND product.deleted_at IS NULL
      WHERE cat.deleted_at IS NULL
      GROUP BY cat.id
    `);
    const counts = new Map<string, number>(
      rows.map((row: { id: string; serviceCount: number | string }) => [
        row.id,
        Number(row.serviceCount) || 0,
      ]),
    );

    return categories.map((category) =>
      Object.assign(category, {
        serviceCount: counts.get(category.id) ?? 0,
      }),
    ) as (Category & { serviceCount: number })[];
  }
}

function textQuery(primary?: string, alias?: string): string | null {
  const value = (primary ?? alias)?.trim();
  return value && value.length >= 2 ? value : null;
}

function serviceTextFilters(query: PublicServiceListQueryDto) {
  return [
    {
      value: textQuery(query.clinic, query.clinicId),
      fields: ['clinicNameSearch', 'clinicAddressSearch'],
    },
    {
      value: textQuery(query.province, query.provinceId),
      fields: ['provinceName', 'locationText'],
    },
    {
      value: textQuery(query.district, query.districtId),
      fields: ['districtName', 'locationText'],
    },
    {
      value: textQuery(query.ward, query.wardId),
      fields: ['wardName', 'locationText'],
    },
  ].filter((filter): filter is { value: string; fields: string[] } =>
    Boolean(filter.value),
  );
}
