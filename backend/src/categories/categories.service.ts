import {
  Injectable,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { Category } from '@/common/entities/category.entity';
import { CategoryResponseDto } from './dto/category-response.dto';
import { AdminCategoryResponseDto } from './dto/admin-category-response.dto';
import { CreateCategoryHandler } from './application/handlers/create-category.handler';
import { UpdateCategoryHandler } from './application/handlers/update-category.handler';
import { RemoveCategoryHandler } from './application/handlers/remove-category.handler';

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
    private readonly createCategoryHandler: CreateCategoryHandler,
    private readonly updateCategoryHandler: UpdateCategoryHandler,
    private readonly removeCategoryHandler: RemoveCategoryHandler,
  ) {}

  /**
   * Facade: Delegates to CreateCategoryHandler.
   * @param createCategoryDto - The category data
   * @returns The created category response DTO
   */
  async create(createCategoryDto: CreateCategoryDto): Promise<CategoryResponseDto> {
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
      order: { name: 'ASC' },
    });
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
    const entity = await this.updateCategoryHandler.execute(id, updateCategoryDto);
    return CategoryResponseDto.fromEntity(entity);
  }

  /**
   * Facade: Delegates to RemoveCategoryHandler.
   * @param id - The category ID
   */
  async remove(id: string): Promise<void> {
    return this.removeCategoryHandler.execute(id);
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
      .loadRelationCountAndMap('cat.serviceCount', 'cat.products')
      .orderBy('cat.sortOrder', 'ASC')
      .addOrderBy('cat.name', 'ASC')
      .withDeleted()
      .where('cat.deletedAt IS NULL')
      .getMany();

    return AdminCategoryResponseDto.fromEntities(
      categories as (Category & { serviceCount: number })[],
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
      .loadRelationCountAndMap('cat.serviceCount', 'cat.products')
      .where('cat.id = :id', { id })
      .getOne();

    if (!category) {
      this.logger.warn(`Category not found: ${id}`);
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    return AdminCategoryResponseDto.fromEntity(
      category as Category & { serviceCount: number },
    );
  }

  /**
   * Facade for admin create: delegates to handler then returns admin DTO with serviceCount.
   */
  async createForAdmin(createCategoryDto: CreateCategoryDto): Promise<AdminCategoryResponseDto> {
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
}

