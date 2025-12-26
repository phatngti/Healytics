import { Injectable, NotFoundException, OnModuleInit, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { Category } from './entities/category.entity';

@Injectable()
export class CategoriesService implements OnModuleInit {
  private readonly logger = new Logger(CategoriesService.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async onModuleInit() {
    await this.seedCategories();
  }

  private async seedCategories() {
    const count = await this.categoryRepository.count();
    if (count > 0) {
      this.logger.log('Categories already seeded, skipping...');
      return;
    }

    const categories = [
      { slug: 'skincare', name: 'Skincare' },
      { slug: 'massage', name: 'Massage' },
      { slug: 'facial-therapy', name: 'Facial Therapy' },
      { slug: 'hair-care', name: 'Hair Care' },
      { slug: 'supplements', name: 'Supplements' },
      { slug: 'body-treatment', name: 'Body Treatment' },
      { slug: 'wellness', name: 'Wellness' },
    ];

    this.logger.log('Seeding categories...');
    for (const cat of categories) {
      await this.categoryRepository.save(
        this.categoryRepository.create({
          slug: cat.slug,
          name: cat.name,
          isActive: true,
        }),
      );
    }
    this.logger.log('Categories seeded successfully.');
  }

  async create(createCategoryDto: CreateCategoryDto): Promise<Category> {
    const category = this.categoryRepository.create(createCategoryDto);
    return this.categoryRepository.save(category);
  }

  findAll(): Promise<Category[]> {
    return this.categoryRepository.find({
      relations: ['parent', 'children'],
      order: { name: 'ASC' },
    });
  }

  /**
   * Get only root categories (no parent)
   */
  findRoots(): Promise<Category[]> {
    return this.categoryRepository.find({
      where: { parentId: IsNull() },
      relations: ['children'],
      order: { name: 'ASC' },
    });
  }

  async findOne(id: string): Promise<Category> {
    const category = await this.categoryRepository.findOne({
      where: { id },
      relations: ['parent', 'children'],
    });

    if (!category) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }

    return category;
  }

  async findBySlug(slug: string): Promise<Category> {
    const category = await this.categoryRepository.findOne({
      where: { slug },
      relations: ['parent', 'children'],
    });

    if (!category) {
      throw new NotFoundException(`Category with slug "${slug}" not found`);
    }

    return category;
  }

  async update(id: string, updateCategoryDto: UpdateCategoryDto): Promise<Category> {
    const category = await this.findOne(id);
    Object.assign(category, updateCategoryDto);
    await this.categoryRepository.save(category);
    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.categoryRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Category with ID ${id} not found`);
    }
  }
}
