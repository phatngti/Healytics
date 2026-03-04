import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Category } from '@/common/entities/category.entity';
import { ISeeder } from '../seeder.interface';

const SEED_CATEGORIES = [
  {
    name: 'Relaxation Massage',
    slug: 'relaxation-massage',
    description: 'Stress-relief and relaxation massage services',
    imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600',
  },
  {
    name: 'Rehabilitation Massage',
    slug: 'rehabilitation-massage',
    description: 'Therapeutic and rehabilitation massage services',
    imageUrl: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600',
  },
  {
    name: 'Spa & Beauty',
    slug: 'spa-beauty',
    description: 'Facial care, beauty treatments and spa services',
    imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600',
  },
  {
    name: 'Dental Care',
    slug: 'dental',
    description: 'Professional dental treatment services',
    imageUrl: 'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600',
  },
  {
    name: 'Dermatology',
    slug: 'dermatology',
    description: 'Skincare and dermatology products',
    imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=600',
  },
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
        imageUrl: catData.imageUrl,
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
