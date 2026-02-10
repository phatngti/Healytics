import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Category } from '@/common/entities/category.entity';
import { ISeeder } from '../seeder.interface';

const SEED_CATEGORIES = [
  { name: 'Rehabilitation Massage', slug: 'rehabilitation-massage', description: 'Therapeutic rehabilitation massage services' },
  { name: 'Relaxation Massage', slug: 'relaxation-massage', description: 'Relaxation and stress-relief massage services' },
  { name: 'Spa & Beauty', slug: 'spa-beauty', description: 'Spa treatments and beauty care services' },
  { name: 'Dental', slug: 'dental', description: 'General and cosmetic dental services' },
  { name: 'Dermatology', slug: 'dermatology', description: 'Dermatology and aesthetic skin treatments' },
  { name: 'Traditional Medicine', slug: 'traditional-medicine', description: 'Traditional and herbal medicine services' },
  { name: 'Psychology', slug: 'psychology', description: 'Psychology and mental health therapy services' },
  { name: 'Nutrition', slug: 'nutrition', description: 'Nutritional counseling and dietary services' },
  { name: 'Fitness', slug: 'fitness', description: 'Fitness, gym and yoga services' },
  { name: 'Pharmacy', slug: 'pharmacy', description: 'Pharmaceutical products and services' },
];

@Injectable()
export class CategorySeeder implements ISeeder {
  private readonly logger = new Logger(CategorySeeder.name);

  constructor(
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding categories...');

    for (const catData of SEED_CATEGORIES) {
      const exists = await this.categoryRepo.findOne({
        where: { slug: catData.slug },
      });

      if (exists) {
        this.logger.log(`  ⏭ Category "${catData.name}" already exists, skipping`);
        continue;
      }

      const category = this.categoryRepo.create({
        name: catData.name,
        slug: catData.slug,
        description: catData.description,
        isActive: true,
      });

      await this.categoryRepo.save(category);
      this.logger.log(`  ✅ Created category "${catData.name}"`);
    }

    this.logger.log('Categories seeding completed');
  }

  async clear(): Promise<void> {
    const slugs = SEED_CATEGORIES.map((c) => c.slug);
    const { affected } = await this.categoryRepo.delete({ slug: In(slugs) });
    if (!affected) {
      this.logger.warn('⚠ No seed categories found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed category(ies)`);
    }
  }
}
