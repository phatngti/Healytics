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
    name: 'Nutrition',
    slug: 'nutrition-domain',
    description: 'Nutrition, pharmacy, supplements and traditional medicine services',
    imageUrl:
      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
    iconName: 'nutrition',
    colorValue: '#00A7B5',
    sortOrder: 10,
  },
  {
    name: 'Exercise',
    slug: 'exercise-domain',
    description: 'Fitness, yoga and rehabilitation services',
    imageUrl:
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=600',
    iconName: 'fitness_center',
    colorValue: '#F59E0B',
    sortOrder: 20,
  },
  {
    name: 'Mental Therapy',
    slug: 'mental-therapy-domain',
    description: 'Mental wellness, therapy and emotional support services',
    imageUrl:
      'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=600',
    iconName: 'psychology',
    colorValue: '#10B981',
    sortOrder: 30,
  },
  {
    name: 'Spa & Beauty',
    slug: 'spa-beauty-domain',
    description: 'Spa, beauty, dermatology, dental and relaxation services',
    imageUrl:
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600',
    iconName: 'spa',
    colorValue: '#EF4444',
    sortOrder: 40,
  },
  {
    name: 'Relaxation Massage',
    slug: 'relaxation-massage',
    parentSlug: 'spa-beauty-domain',
    description: 'Stress-relief and relaxation massage services',
    imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600',
    iconName: 'spa',
    colorValue: '#2E7D32',
    sortOrder: 41,
  },
  {
    name: 'Rehabilitation Massage',
    slug: 'rehabilitation-massage',
    parentSlug: 'exercise-domain',
    description: 'Therapeutic and rehabilitation massage services',
    imageUrl:
      'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600',
    iconName: 'healing',
    colorValue: '#EF6C00',
    sortOrder: 21,
  },
  {
    name: 'Spa & Beauty',
    slug: 'spa-beauty',
    parentSlug: 'spa-beauty-domain',
    description: 'Facial care, beauty treatments and spa services',
    imageUrl:
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600',
    iconName: 'face_retouching_natural',
    colorValue: '#C2185B',
    sortOrder: 43,
  },
  {
    name: 'Spa',
    slug: 'spa',
    parentSlug: 'spa-beauty-domain',
    description: 'General spa experiences and restorative treatments',
    imageUrl:
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600',
    iconName: 'spa',
    colorValue: '#0EA5E9',
    sortOrder: 42,
  },
  {
    name: 'Dental Care',
    slug: 'dental',
    parentSlug: 'spa-beauty-domain',
    description: 'Professional dental treatment services',
    imageUrl:
      'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600',
    iconName: 'dentistry',
    colorValue: '#1565C0',
    sortOrder: 44,
  },
  {
    name: 'Dermatology',
    slug: 'dermatology',
    parentSlug: 'spa-beauty-domain',
    description: 'Skincare and dermatology products',
    imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=600',
    iconName: 'dermatology',
    colorValue: '#6A1B9A',
    sortOrder: 45,
  },
  {
    name: 'Fitness & Yoga',
    slug: 'fitness-yoga',
    parentSlug: 'exercise-domain',
    description: 'Recovery-focused fitness, yoga and mobility sessions',
    imageUrl:
      'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=600',
    iconName: 'fitness_center',
    colorValue: '#00838F',
    sortOrder: 22,
  },
  {
    name: 'Yoga Recovery',
    slug: 'yoga-recovery',
    parentSlug: 'exercise-domain',
    description: 'Guided yoga and mobility sessions for recovery',
    imageUrl:
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600',
    iconName: 'self_improvement',
    colorValue: '#00695C',
    sortOrder: 23,
  },
  {
    name: 'Pharmacy & Nutrition',
    slug: 'pharmacy-nutrition',
    parentSlug: 'nutrition-domain',
    description: 'Pharmacy services, supplements and nutrition guidance',
    imageUrl:
      'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=600',
    iconName: 'local_pharmacy',
    colorValue: '#558B2F',
    sortOrder: 11,
  },
  {
    name: 'Nutrition Counseling',
    slug: 'nutrition-counseling',
    parentSlug: 'nutrition-domain',
    description: 'Personalized meal planning and nutrition consultations',
    imageUrl:
      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
    iconName: 'nutrition',
    colorValue: '#7CB342',
    sortOrder: 12,
  },
  {
    name: 'Traditional Medicine',
    slug: 'traditional-medicine',
    parentSlug: 'nutrition-domain',
    description: 'Traditional medicine, herbal care and acupuncture services',
    imageUrl:
      'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=600',
    iconName: 'eco',
    colorValue: '#5D4037',
    sortOrder: 13,
  },
  {
    name: 'Acupuncture',
    slug: 'acupuncture',
    parentSlug: 'nutrition-domain',
    description: 'Acupuncture and meridian-balancing treatments',
    imageUrl:
      'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=600',
    iconName: 'acupuncture',
    colorValue: '#795548',
    sortOrder: 14,
  },
  {
    name: 'Mental Wellness',
    slug: 'mental-wellness',
    parentSlug: 'mental-therapy-domain',
    description: 'Counseling, psychology and mental wellness services',
    imageUrl:
      'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=600',
    iconName: 'psychology',
    colorValue: '#455A64',
    sortOrder: 31,
  },
  {
    name: 'Psychology Therapy',
    slug: 'psychology-therapy',
    parentSlug: 'mental-therapy-domain',
    description: 'Individual counseling and psychology therapy sessions',
    imageUrl: 'https://images.unsplash.com/photo-1551847677-dc82d764e1eb?w=600',
    iconName: 'psychology_alt',
    colorValue: '#546E7A',
    sortOrder: 32,
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
