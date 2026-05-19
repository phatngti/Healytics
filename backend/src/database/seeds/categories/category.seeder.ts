import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Category } from '@/common/entities/category.entity';
import { ISeeder } from '../seeder.interface';

interface SeedCategory {
  name: string;
  slug: string;
  description: string;
  imageUrl: string;
  parentSlug?: string;
  iconName: string;
  colorValue: string;
  sortOrder: number;
}

const SEED_CATEGORIES: SeedCategory[] = [
  {
    name: 'Relaxation Massage',
    slug: 'relaxation-massage',
    description: 'Stress-relief and relaxation massage services',
    imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600',
    iconName: 'spa',
    colorValue: '#2E7D32',
    sortOrder: 10,
  },
  {
    name: 'Rehabilitation Massage',
    slug: 'rehabilitation-massage',
    description: 'Therapeutic and rehabilitation massage services',
    imageUrl:
      'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600',
    iconName: 'healing',
    colorValue: '#EF6C00',
    sortOrder: 20,
  },
  {
    name: 'Spa & Beauty',
    slug: 'spa-beauty',
    description: 'Facial care, beauty treatments and spa services',
    imageUrl:
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600',
    iconName: 'face_retouching_natural',
    colorValue: '#C2185B',
    sortOrder: 30,
  },
  {
    name: 'Dental Care',
    slug: 'dental',
    description: 'Professional dental treatment services',
    imageUrl:
      'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600',
    iconName: 'dentistry',
    colorValue: '#1565C0',
    sortOrder: 40,
  },
  {
    name: 'Dermatology',
    slug: 'dermatology',
    description: 'Skincare and dermatology products',
    imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=600',
    iconName: 'dermatology',
    colorValue: '#6A1B9A',
    sortOrder: 50,
  },
  {
    name: 'Fitness & Yoga',
    slug: 'fitness-yoga',
    description: 'Recovery-focused fitness, yoga and mobility sessions',
    imageUrl:
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=600',
    iconName: 'fitness_center',
    colorValue: '#00838F',
    sortOrder: 60,
  },
  {
    name: 'Yoga Recovery',
    slug: 'yoga-recovery',
    parentSlug: 'fitness-yoga',
    description: 'Guided yoga and mobility sessions for recovery',
    imageUrl:
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600',
    iconName: 'self_improvement',
    colorValue: '#00695C',
    sortOrder: 61,
  },
  {
    name: 'Pharmacy & Nutrition',
    slug: 'pharmacy-nutrition',
    description: 'Pharmacy services, supplements and nutrition guidance',
    imageUrl:
      'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=600',
    iconName: 'local_pharmacy',
    colorValue: '#558B2F',
    sortOrder: 70,
  },
  {
    name: 'Nutrition Counseling',
    slug: 'nutrition-counseling',
    parentSlug: 'pharmacy-nutrition',
    description: 'Personalized meal planning and nutrition consultations',
    imageUrl:
      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
    iconName: 'nutrition',
    colorValue: '#7CB342',
    sortOrder: 71,
  },
  {
    name: 'Traditional Medicine',
    slug: 'traditional-medicine',
    description: 'Traditional medicine, herbal care and acupuncture services',
    imageUrl:
      'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600',
    iconName: 'eco',
    colorValue: '#5D4037',
    sortOrder: 80,
  },
  {
    name: 'Acupuncture',
    slug: 'acupuncture',
    parentSlug: 'traditional-medicine',
    description: 'Acupuncture and meridian-balancing treatments',
    imageUrl:
      'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=600',
    iconName: 'acupuncture',
    colorValue: '#795548',
    sortOrder: 81,
  },
  {
    name: 'Mental Wellness',
    slug: 'mental-wellness',
    description: 'Counseling, psychology and mental wellness services',
    imageUrl:
      'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=600',
    iconName: 'psychology',
    colorValue: '#455A64',
    sortOrder: 90,
  },
  {
    name: 'Psychology Therapy',
    slug: 'psychology-therapy',
    parentSlug: 'mental-wellness',
    description: 'Individual counseling and psychology therapy sessions',
    imageUrl: 'https://images.unsplash.com/photo-1551847677-dc82d764e1eb?w=600',
    iconName: 'psychology_alt',
    colorValue: '#546E7A',
    sortOrder: 91,
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
        withDeleted: true,
      });
      const parent = catData.parentSlug
        ? await this.categoryRepo.findOne({
            where: { slug: catData.parentSlug },
            select: ['id', 'slug'],
            withDeleted: true,
          })
        : null;
      const payload = {
        name: catData.name,
        slug: catData.slug,
        description: catData.description,
        imageUrl: catData.imageUrl,
        isActive: true,
        iconName: catData.iconName,
        colorValue: catData.colorValue,
        sortOrder: catData.sortOrder,
        parentId: parent?.id ?? null,
      };

      if (exists) {
        await this.categoryRepo.update(exists.id, {
          ...payload,
          deletedAt: null,
        });
        this.logger.log(`  🔄 Updated category "${catData.name}"`);
        continue;
      }

      const category = this.categoryRepo.create(payload);

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
