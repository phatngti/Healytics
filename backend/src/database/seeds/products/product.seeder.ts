import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { Employee } from '@/common/entities/employee.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductReview } from '@/common/entities/product-review.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { Account } from '@/common/entities/account.entity';
import { Role } from '@/account/enum/role.enum';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { MediaType } from '@/health-service/enums/media-type.enum';
import { ISeeder } from '../seeder.interface';

/**
 * Seed data for products with full service details.
 * Every SERVICE product includes: media, serviceDefinition, resourceRequirements,
 * tagNames, eligibleEmployees, facilityImages, and reviews — ensuring all
 * user-facing detail endpoints return rich data.
 */
const SEED_PRODUCTS = [
  {
    name: 'Full Body Massage 60 Min',
    slug: 'full-body-massage-60-min',
    description:
      'Indulge in our signature full body relaxation massage. This 60-minute session combines Swedish and deep tissue techniques to relieve tension, improve circulation, and restore balance. Our certified therapists use premium aromatherapy oils tailored to your needs. Perfect for stress relief and muscle recovery.',
    type: HealthServiceType.SERVICE,
    basePrice: 350000,
    salePrice: 299000,
    categorySlug: 'relaxation-massage',
    media: [
      { url: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800', isThumbnail: true, sortOrder: 0 },
      { url: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=800', isThumbnail: false, sortOrder: 1 },
      { url: 'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=800', isThumbnail: false, sortOrder: 2 },
      { url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800', isThumbnail: false, sortOrder: 3 },
    ],
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
      { code: 'EMP-001', isPrimary: false },
    ],
    facilityImages: [
      { imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=600', label: 'Main Massage Hall', sortOrder: 0 },
      { imageUrl: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=600', label: 'Treatment Suite A', sortOrder: 1 },
      { imageUrl: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=600', label: 'Relaxation Lounge', sortOrder: 2 },
      { imageUrl: 'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?w=600', label: 'Aromatherapy Room', sortOrder: 3 },
    ],
    reviews: [
      {
        reviewerName: 'Nguyen Van A',
        avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-05-11',
        text: 'Excellent full body massage! The therapist was very skilled and the ambiance was perfect. I felt completely relaxed after the session. Highly recommend!',
        imageUrls: ['https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400'],
      },
      {
        reviewerName: 'Tran Thi B',
        avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-05-08',
        text: 'Great experience overall. The room was clean and the massage technique was professional. Would have liked a bit more pressure on the shoulders.',
        imageUrls: [],
      },
      {
        reviewerName: 'Le Van C',
        avatarUrl: 'https://randomuser.me/api/portraits/men/67.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-04-22',
        text: 'Best massage in the city! Will definitely come back again. The aromatherapy oils they used were amazing.',
        imageUrls: [],
      },
      {
        reviewerName: 'Phan Minh D',
        avatarUrl: 'https://randomuser.me/api/portraits/women/28.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-04-15',
        text: 'Wonderful atmosphere and extremely professional staff. The 60-minute session flew by, and my back pain was significantly reduced.',
        imageUrls: ['https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=400'],
      },
      {
        reviewerName: 'Hoang Anh E',
        avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-03-30',
        text: 'Good experience. The therapist listened to my preferences and adjusted the technique accordingly. Booking was easy and the facilities are top-notch.',
        imageUrls: [],
      },
    ],
  },
  {
    name: 'Neck & Shoulder Therapy',
    slug: 'neck-shoulder-therapy',
    description:
      'Targeted therapeutic treatment designed specifically for chronic neck and shoulder pain. Our experienced therapists use a combination of trigger point therapy, myofascial release, and stretching techniques to address muscle tension, improve range of motion, and provide lasting relief. Ideal for office workers and people with postural imbalances.',
    type: HealthServiceType.SERVICE,
    basePrice: 400000,
    categorySlug: 'rehabilitation-massage',
    media: [
      { url: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800', isThumbnail: true, sortOrder: 0 },
      { url: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=800', isThumbnail: false, sortOrder: 1 },
      { url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800', isThumbnail: false, sortOrder: 2 },
    ],
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
    facilityImages: [
      { imageUrl: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600', label: 'Therapy Room', sortOrder: 0 },
      { imageUrl: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=600', label: 'Equipment Area', sortOrder: 1 },
      { imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600', label: 'Recovery Zone', sortOrder: 2 },
    ],
    reviews: [
      {
        reviewerName: 'Pham Duc D',
        avatarUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-05-10',
        text: 'My neck pain has significantly improved after just one session. The therapist was extremely knowledgeable and explained every step of the treatment.',
        imageUrls: [],
      },
      {
        reviewerName: 'Vo Thi F',
        avatarUrl: 'https://randomuser.me/api/portraits/women/55.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-04-28',
        text: 'I have been coming here for 3 months and the improvement in my shoulder mobility is remarkable. Best rehabilitation therapy I have tried.',
        imageUrls: ['https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=400'],
      },
      {
        reviewerName: 'Dang Quoc G',
        avatarUrl: 'https://randomuser.me/api/portraits/men/38.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-04-05',
        text: 'Professional service and the therapist really understood my pain points. The therapy room is well-equipped and private.',
        imageUrls: [],
      },
    ],
  },
  {
    name: 'Basic Facial Care Package',
    slug: 'basic-facial-care-package',
    description:
      'Transform your skin with our essential facial care package. This 90-minute treatment includes deep cleansing, gentle exfoliation, hydrating mask application, and soothing facial massage. Using premium Korean skincare products, our estheticians customize each session to address your specific skin concerns — whether acne, dryness, or uneven tone.',
    type: HealthServiceType.SERVICE,
    basePrice: 500000,
    salePrice: 450000,
    categorySlug: 'spa-beauty',
    media: [
      { url: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800', isThumbnail: true, sortOrder: 0 },
      { url: 'https://images.unsplash.com/photo-1552693673-1bf958298935?w=800', isThumbnail: false, sortOrder: 1 },
      { url: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800', isThumbnail: false, sortOrder: 2 },
    ],
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
    facilityImages: [
      { imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600', label: 'Facial Treatment Room', sortOrder: 0 },
      { imageUrl: 'https://images.unsplash.com/photo-1552693673-1bf958298935?w=600', label: 'Product Display', sortOrder: 1 },
      { imageUrl: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=600', label: 'Relaxation Area', sortOrder: 2 },
    ],
    reviews: [
      {
        reviewerName: 'Mai Thu H',
        avatarUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-05-09',
        text: 'My skin has never looked this good! The Korean products they use are amazing and the esthetician was very gentle and thorough.',
        imageUrls: ['https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400'],
      },
      {
        reviewerName: 'Nguyen Thanh I',
        avatarUrl: 'https://randomuser.me/api/portraits/women/62.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-04-20',
        text: 'Very relaxing facial treatment. The mask they applied was so soothing. My skin felt refreshed and hydrated for days.',
        imageUrls: [],
      },
      {
        reviewerName: 'Le Phuong K',
        avatarUrl: 'https://randomuser.me/api/portraits/women/18.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-04-01',
        text: 'Best facial care package I have tried in HCMC. The facilities are spotless and the staff is incredibly professional.',
        imageUrls: [],
      },
    ],
  },
  {
    name: 'Professional Teeth Whitening',
    slug: 'professional-teeth-whitening',
    description:
      'Achieve a brighter, more confident smile with our professional in-office teeth whitening. Using advanced LED light-activated whitening technology, this 2-hour session can lighten your teeth by up to 8 shades. Our dental professionals ensure a safe, comfortable experience with minimal sensitivity. Results are immediate and long-lasting.',
    type: HealthServiceType.SERVICE,
    basePrice: 1500000,
    salePrice: 1200000,
    categorySlug: 'dental',
    media: [
      { url: 'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=800', isThumbnail: true, sortOrder: 0 },
      { url: 'https://images.unsplash.com/photo-1588776814546-daab30f310ce?w=800', isThumbnail: false, sortOrder: 1 },
      { url: 'https://images.unsplash.com/photo-1629909615957-be38d48fbbe4?w=800', isThumbnail: false, sortOrder: 2 },
    ],
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
    facilityImages: [
      { imageUrl: 'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600', label: 'Dental Office', sortOrder: 0 },
      { imageUrl: 'https://images.unsplash.com/photo-1588776814546-daab30f310ce?w=600', label: 'Treatment Chair', sortOrder: 1 },
      { imageUrl: 'https://images.unsplash.com/photo-1629909615957-be38d48fbbe4?w=600', label: 'Equipment Station', sortOrder: 2 },
    ],
    reviews: [
      {
        reviewerName: 'Bui Quang L',
        avatarUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-05-05',
        text: 'Incredible results! My teeth are noticeably whiter after just one session. Dr. Anderson was very professional and made me feel comfortable throughout.',
        imageUrls: [],
      },
      {
        reviewerName: 'Tran Ngoc M',
        avatarUrl: 'https://randomuser.me/api/portraits/women/41.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-04-18',
        text: 'Good service and visible results. There was slight sensitivity during the procedure but it subsided quickly. Worth the price.',
        imageUrls: ['https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=400'],
      },
    ],
  },
  {
    name: 'Sunscreen SPF50 Broad Spectrum',
    slug: 'sunscreen-spf50-broad-spectrum',
    description:
      'Advanced broad spectrum SPF50 PA+++ sunscreen with lightweight, non-greasy formula. Provides superior UVA/UVB protection while hydrating and nourishing your skin. Water-resistant for up to 80 minutes. Suitable for all skin types including sensitive skin. Dermatologically tested.',
    type: HealthServiceType.PHYSICAL,
    basePrice: 280000,
    categorySlug: 'dermatology',
    media: [
      { url: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=800', isThumbnail: true, sortOrder: 0 },
      { url: 'https://images.unsplash.com/photo-1532009877282-3340270e0529?w=800', isThumbnail: false, sortOrder: 1 },
    ],
    eligibleEmployees: [
      { code: 'EMP-002', isPrimary: true },
    ],
    reviews: [
      {
        reviewerName: 'Lam Thu N',
        avatarUrl: 'https://randomuser.me/api/portraits/women/36.jpg',
        rating: 5,
        status: 'Completed',
        date: '2025-05-12',
        text: 'Love this sunscreen! Non-greasy and absorbs quickly. Perfect for daily use under makeup. Great UV protection.',
        imageUrls: [],
      },
      {
        reviewerName: 'Do Minh O',
        avatarUrl: 'https://randomuser.me/api/portraits/men/29.jpg',
        rating: 4,
        status: 'Completed',
        date: '2025-04-25',
        text: 'Lightweight formula that does not leave a white cast. Very impressed with the quality for the price.',
        imageUrls: [],
      },
    ],
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

    @InjectRepository(ProductDefinition)
    private readonly serviceDefRepo: Repository<ProductDefinition>,

    @InjectRepository(ProductResourceRequirement)
    private readonly resourceReqRepo: Repository<ProductResourceRequirement>,

    @InjectRepository(ResourceType)
    private readonly resourceTypeRepo: Repository<ResourceType>,

    @InjectRepository(ProductFeatureTag)
    private readonly serviceTagRepo: Repository<ProductFeatureTag>,

    @InjectRepository(ProductTag)
    private readonly productTagRepo: Repository<ProductTag>,

    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepo: Repository<ProductEmployeeEligibility>,

    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,

    @InjectRepository(ProductMedia)
    private readonly mediaRepo: Repository<ProductMedia>,

    @InjectRepository(ProductReview)
    private readonly reviewRepo: Repository<ProductReview>,

    @InjectRepository(ProductFacilityImage)
    private readonly facilityImageRepo: Repository<ProductFacilityImage>,

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

    // Find health partner user for service tag lookup (tags are seeded under HEALTH_PARTNER)
    const tagOwner = await this.accountRepo.findOne({ where: { role: Role.HEALTH_PARTNER } });

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
        salePrice: (prodData as any).salePrice ?? null,
        currency: 'VND',
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
        categoryId,
      });

      await this.productRepo.save(product);
      this.logger.log(`  ✅ Created product "${prodData.name}" (${prodData.type})`);

      // 2. Product Media (images for all product types)
      if (prodData.media?.length) {
        for (const m of prodData.media) {
          const media = this.mediaRepo.create({
            productId: product.id,
            url: m.url,
            mediaType: MediaType.IMAGE,
            isThumbnail: m.isThumbnail,
            sortOrder: m.sortOrder,
          });
          await this.mediaRepo.save(media);
        }
        this.logger.log(`    📷 Added ${prodData.media.length} media image(s)`);
      }

      // 3. Reviews (for all product types)
      if (prodData.reviews?.length) {
        for (const rev of prodData.reviews) {
          const review = this.reviewRepo.create({
            productId: product.id,
            reviewerName: rev.reviewerName,
            avatarUrl: rev.avatarUrl,
            rating: rev.rating,
            status: rev.status ?? 'Completed',
            date: new Date(rev.date),
            text: rev.text,
            imageUrls: rev.imageUrls ?? [],
          });
          await this.reviewRepo.save(review);
        }
        this.logger.log(`    ⭐ Added ${prodData.reviews.length} review(s)`);
      }

      // 4. Employee Eligibility (for all product types)
      if ((prodData as any).eligibleEmployees?.length) {
        for (const emp of (prodData as any).eligibleEmployees) {
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

      // Only seed service-specific details for SERVICE-type products
      if (prodData.type !== HealthServiceType.SERVICE) continue;

      // 4. Service Definition (1:1)
      if ((prodData as any).serviceDefinition) {
        const serviceDef = this.serviceDefRepo.create({
          productId: product.id,
          ...(prodData as any).serviceDefinition,
        });
        await this.serviceDefRepo.save(serviceDef);
        this.logger.log(`    📋 Service definition: ${(prodData as any).serviceDefinition.durationMinutes}min + ${(prodData as any).serviceDefinition.bufferMinutes}min buffer`);
      }

      // 5. Resource Requirements (upsert ResourceType, then create requirement)
      if ((prodData as any).resourceRequirements?.length) {
        for (const req of (prodData as any).resourceRequirements) {
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

      // 6. Service Tags (via product_tags junction)
      if ((prodData as any).tagNames?.length && tagOwner) {
        for (const tagName of (prodData as any).tagNames) {
          const tag = await this.serviceTagRepo.findOne({
            where: { name: tagName, userId: tagOwner.id },
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

      // 7. Facility Images
      if ((prodData as any).facilityImages?.length) {
        for (const fi of (prodData as any).facilityImages) {
          const facilityImage = this.facilityImageRepo.create({
            productId: product.id,
            imageUrl: fi.imageUrl,
            label: fi.label,
            sortOrder: fi.sortOrder ?? 0,
          });
          await this.facilityImageRepo.save(facilityImage);
        }
        this.logger.log(`    🏢 Added ${(prodData as any).facilityImages.length} facility image(s)`);
      }
    }

    this.logger.log('Products seeding completed');
  }

  async clear(): Promise<void> {
    const slugs = SEED_PRODUCTS.map((p) => p.slug);

    // Products cascade-delete child rows (service_definitions, service_resource_requirements,
    // product_tags, service_employee_eligibility, media, reviews, facility_images),
    // so we only need to hard-delete products + resource_types.
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
