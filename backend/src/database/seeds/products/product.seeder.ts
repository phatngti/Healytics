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
import { Partner } from '@/common/entities/partner.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { Booking } from '@/common/entities/booking.entity';
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
 * tagNames, eligibleEmployees, and facilityImages.
 * Treatment reviews are seeded separately by finding completed bookings.
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
    partnerTaxCode: '0123456789', // Healytics Spa & Wellness
    media: [
      {
        url: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
        isThumbnail: true,
        sortOrder: 0,
      },
      {
        url: 'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=800',
        isThumbnail: false,
        sortOrder: 1,
      },
      {
        url: 'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=800',
        isThumbnail: false,
        sortOrder: 2,
      },
      {
        url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=800',
        isThumbnail: false,
        sortOrder: 3,
      },
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
    serviceManual: {
      preServiceGuidelines: [
        'Avoid heavy meals 2 hours before your session',
        'Wear comfortable, loose-fitting clothing',
        'Stay hydrated before and after the massage',
        'Inform the therapist of any injuries or pain areas',
      ],
      serviceRules: [
        {
          iconSlug: 'no-eating',
          title: 'No Heavy Meals',
          description: 'Avoid eating large meals 2 hours before your massage',
        },
        {
          iconSlug: 'hydrate',
          title: 'Stay Hydrated',
          description: 'Drink plenty of water before and after the treatment',
        },
        {
          iconSlug: 'arrive-early',
          title: 'Arrive 15 Minutes Early',
          description: 'Allow time for check-in and changing',
        },
      ],
      procedureSteps: [
        {
          stepNumber: 1,
          title: 'Check-in & Consultation',
          description:
            'Arrive at reception, complete health form, and discuss your preferences',
        },
        {
          stepNumber: 2,
          title: 'Preparation',
          description:
            'Change into comfortable attire and relax in the pre-treatment lounge',
        },
        {
          stepNumber: 3,
          title: 'Massage Session',
          description:
            'Enjoy your 60-minute full body massage with aromatherapy oils',
        },
        {
          stepNumber: 4,
          title: 'Post-Session Relaxation',
          description:
            'Rest in the relaxation lounge and enjoy complimentary herbal tea',
        },
      ],
    },
    tagNames: ['Relaxation'],
    eligibleEmployees: [
      { code: 'EMP-002', isPrimary: true },
      { code: 'EMP-001', isPrimary: false },
    ],
    facilityImages: [
      {
        imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=600',
        label: 'Main Massage Hall',
        sortOrder: 0,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?w=600',
        label: 'Treatment Suite A',
        sortOrder: 1,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=600',
        label: 'Relaxation Lounge',
        sortOrder: 2,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1507652313519-d4e9174996dd?w=600',
        label: 'Aromatherapy Room',
        sortOrder: 3,
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
    partnerTaxCode: '0123456789', // Healytics Spa & Wellness
    media: [
      {
        url: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
        isThumbnail: true,
        sortOrder: 0,
      },
      {
        url: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=800',
        isThumbnail: false,
        sortOrder: 1,
      },
      {
        url: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
        isThumbnail: false,
        sortOrder: 2,
      },
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
    serviceManual: {
      preServiceGuidelines: [
        'Wear clothing that allows access to your neck and shoulders',
        'Note any recent injuries or areas of acute pain',
        'Avoid applying heat packs before the session',
        'Be prepared to discuss your pain history and daily activities',
      ],
      serviceRules: [
        {
          iconSlug: 'no-heat',
          title: 'No Heat Packs',
          description:
            'Avoid applying heat to the treatment area before your session',
        },
        {
          iconSlug: 'communicate',
          title: 'Communicate Pain Levels',
          description:
            'Always let the therapist know if pressure is too intense',
        },
        {
          iconSlug: 'follow-up',
          title: 'Follow Post-Care Instructions',
          description: 'Gentle stretches may be prescribed for home care',
        },
      ],
      procedureSteps: [
        {
          stepNumber: 1,
          title: 'Assessment',
          description:
            'Therapist evaluates your posture, range of motion, and pain points',
        },
        {
          stepNumber: 2,
          title: 'Targeted Therapy',
          description:
            '30-minute trigger point and myofascial release treatment',
        },
        {
          stepNumber: 3,
          title: 'Stretching & Cool Down',
          description: '15-minute guided stretching and mobility exercises',
        },
        {
          stepNumber: 4,
          title: 'Home Care Briefing',
          description:
            'Therapist provides personalized exercises and aftercare advice',
        },
      ],
    },
    tagNames: ['Pain Relief', 'Rehabilitation'],
    eligibleEmployees: [
      { code: 'EMP-001', isPrimary: true },
      { code: 'EMP-002', isPrimary: false },
    ],
    facilityImages: [
      {
        imageUrl:
          'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=600',
        label: 'Therapy Room',
        sortOrder: 0,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=600',
        label: 'Equipment Area',
        sortOrder: 1,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600',
        label: 'Recovery Zone',
        sortOrder: 2,
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
    partnerTaxCode: '0123456789', // Healytics Spa & Wellness
    media: [
      {
        url: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
        isThumbnail: true,
        sortOrder: 0,
      },
      {
        url: 'https://images.unsplash.com/photo-1552693673-1bf958298935?w=800',
        isThumbnail: false,
        sortOrder: 1,
      },
      {
        url: 'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=800',
        isThumbnail: false,
        sortOrder: 2,
      },
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
    serviceManual: {
      preServiceGuidelines: [
        'Remove all makeup before arrival or let our staff assist',
        'Avoid using retinol products 48 hours prior',
        'Inform the esthetician of any skin allergies or sensitivities',
        'Stay out of direct sun exposure for 24 hours after treatment',
      ],
      serviceRules: [
        {
          iconSlug: 'no-retinol',
          title: 'No Retinol 48h Before',
          description:
            'Discontinue retinol products 48 hours before your facial',
        },
        {
          iconSlug: 'no-sun',
          title: 'Avoid Sun After',
          description:
            'Stay out of direct sunlight for 24 hours post-treatment',
        },
        {
          iconSlug: 'clean-face',
          title: 'Clean Face',
          description: 'Arrive with a clean, makeup-free face for best results',
        },
      ],
      procedureSteps: [
        {
          stepNumber: 1,
          title: 'Skin Analysis',
          description:
            'Esthetician examines your skin type and discusses concerns',
        },
        {
          stepNumber: 2,
          title: 'Deep Cleansing & Exfoliation',
          description: '20-minute cleansing and gentle exfoliation',
        },
        {
          stepNumber: 3,
          title: 'Mask Application',
          description: 'Customized hydrating mask tailored to your skin needs',
        },
        {
          stepNumber: 4,
          title: 'Facial Massage & Moisturizing',
          description:
            'Relaxing facial massage with premium Korean skincare products',
        },
        {
          stepNumber: 5,
          title: 'Post-Treatment Care',
          description: 'Application of SPF protection and aftercare guidance',
        },
      ],
    },
    tagNames: ['Beauty', 'Skincare'],
    eligibleEmployees: [{ code: 'EMP-002', isPrimary: true }],
    facilityImages: [
      {
        imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=600',
        label: 'Facial Treatment Room',
        sortOrder: 0,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1552693673-1bf958298935?w=600',
        label: 'Product Display',
        sortOrder: 1,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=600',
        label: 'Relaxation Area',
        sortOrder: 2,
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
    partnerTaxCode: '0987654321', // Healytics Dental
    media: [
      {
        url: 'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=800',
        isThumbnail: true,
        sortOrder: 0,
      },
      {
        url: 'https://images.unsplash.com/photo-1588776814546-daab30f310ce?w=800',
        isThumbnail: false,
        sortOrder: 1,
      },
      {
        url: 'https://images.unsplash.com/photo-1629909615957-be38d48fbbe4?w=800',
        isThumbnail: false,
        sortOrder: 2,
      },
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
    serviceManual: {
      preServiceGuidelines: [
        'Brush and floss your teeth before the appointment',
        'Avoid consuming coffee, tea, or red wine 24 hours before',
        'Inform the dentist of any tooth sensitivity issues',
        'Avoid smoking for 48 hours after the procedure',
      ],
      serviceRules: [
        {
          iconSlug: 'no-staining',
          title: 'No Staining Foods 24h Before',
          description: 'Avoid coffee, tea, red wine, and dark-colored foods',
        },
        {
          iconSlug: 'no-smoking',
          title: 'No Smoking 48h After',
          description:
            'Avoid smoking or tobacco products for 48 hours post-treatment',
        },
        {
          iconSlug: 'sensitivity',
          title: 'Expect Mild Sensitivity',
          description:
            'Temporary tooth sensitivity is normal and subsides within 24-48 hours',
        },
      ],
      procedureSteps: [
        {
          stepNumber: 1,
          title: 'Dental Examination',
          description: 'Dr. examines your teeth and discusses expected results',
        },
        {
          stepNumber: 2,
          title: 'Teeth Cleaning',
          description:
            'Professional cleaning to remove plaque and prepare surfaces',
        },
        {
          stepNumber: 3,
          title: 'Whitening Gel Application',
          description:
            'Protective gum shield applied, followed by whitening gel',
        },
        {
          stepNumber: 4,
          title: 'LED Light Activation',
          description:
            '3 cycles of 15-minute LED light treatment for maximum whitening',
        },
        {
          stepNumber: 5,
          title: 'Final Rinse & Review',
          description:
            'Gel removed, shade comparison, and aftercare instructions provided',
        },
      ],
    },
    tagNames: ['Beauty'],
    eligibleEmployees: [{ code: 'EMP-001', isPrimary: true }],
    facilityImages: [
      {
        imageUrl:
          'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600',
        label: 'Dental Office',
        sortOrder: 0,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1588776814546-daab30f310ce?w=600',
        label: 'Treatment Chair',
        sortOrder: 1,
      },
      {
        imageUrl:
          'https://images.unsplash.com/photo-1629909615957-be38d48fbbe4?w=600',
        label: 'Equipment Station',
        sortOrder: 2,
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

    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepo: Repository<TreatmentReview>,

    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,

    @InjectRepository(ProductFacilityImage)
    private readonly facilityImageRepo: Repository<ProductFacilityImage>,

    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,

    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding products...');

    // Pre-load lookup maps
    const categories = await this.categoryRepo.find();
    const categoryMap = new Map(categories.map((c) => [c.slug, c.id]));

    const employees = await this.employeeRepo.find();
    const employeeMap = new Map(employees.map((e) => [e.employeeCode, e.id]));

    // Build partner lookup: taxCode → partner.id
    const partners = await this.partnerRepo.find({ select: ['id', 'taxCode'] });
    const partnerMap = new Map(partners.map((p) => [p.taxCode, p.id]));

    // Find health partner user for service tag lookup (tags are seeded under HEALTH_PARTNER)
    const tagOwner = await this.accountRepo.findOne({
      where: { role: Role.HEALTH_PARTNER },
    });

    for (const prodData of SEED_PRODUCTS) {
      const exists = await this.productRepo.findOne({
        where: { slug: prodData.slug },
      });

      if (exists) {
        this.logger.log(
          `  ⏭ Product "${prodData.name}" already exists, skipping`,
        );
        continue;
      }

      const categoryId = categoryMap.get(prodData.categorySlug) || null;
      if (!categoryId) {
        this.logger.warn(
          `  ⚠ Category "${prodData.categorySlug}" not found — product "${prodData.name}" will have null categoryId`,
        );
      }

      // Resolve partner FK
      const partnerId = (prodData as any).partnerTaxCode
        ? (partnerMap.get((prodData as any).partnerTaxCode) ?? null)
        : null;
      if ((prodData as any).partnerTaxCode && !partnerId) {
        this.logger.warn(
          `  ⚠ Partner "${(prodData as any).partnerTaxCode}" not found — product "${prodData.name}" will have null partnerId`,
        );
      }

      // 1. Create the product
      const product = this.productRepo.create({
        name: prodData.name,
        slug: prodData.slug,
        description: prodData.description,
        type: prodData.type,
        basePrice: prodData.basePrice,
        salePrice: (prodData as any).salePrice ?? null,
        vendorName: (prodData as any).vendorName ?? null,
        serviceManual: (prodData as any).serviceManual ?? null,
        currency: 'VND',
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
        categoryId,
        partnerId,
      });

      await this.productRepo.save(product);
      this.logger.log(
        `  ✅ Created product "${prodData.name}" (${prodData.type})`,
      );

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

      // 3. TreatmentReviews — seed from completed bookings for this product
      await this.seedTreatmentReviews(product.id);

      // 4. Employee Eligibility (for all product types)
      if ((prodData as any).eligibleEmployees?.length) {
        for (const emp of (prodData as any).eligibleEmployees) {
          const employeeId = employeeMap.get(emp.code);

          if (!employeeId) {
            this.logger.warn(
              `    ⚠ Employee "${emp.code}" not found — skipping eligibility`,
            );
            continue;
          }

          const eligibility = this.eligibilityRepo.create({
            productId: product.id,
            employeeId,
            isPrimary: emp.isPrimary,
          });
          await this.eligibilityRepo.save(eligibility);
          this.logger.log(
            `    👤 Employee "${emp.code}" eligible${emp.isPrimary ? ' (primary)' : ''}`,
          );
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
        this.logger.log(
          `    📋 Service definition: ${(prodData as any).serviceDefinition.durationMinutes}min + ${(prodData as any).serviceDefinition.bufferMinutes}min buffer`,
        );
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
            this.logger.log(
              `    🏗️ Created resource type "${req.resourceTypeName}"`,
            );
          }

          const resourceReq = this.resourceReqRepo.create({
            productId: product.id,
            resourceTypeId: resourceType.id,
            quantityRequired: req.quantityRequired,
          });
          await this.resourceReqRepo.save(resourceReq);
          this.logger.log(
            `    🔧 Resource requirement: ${req.quantityRequired}x "${req.resourceTypeName}"`,
          );
        }
      }

      // 6. Service Tags (via product_tags junction)
      if ((prodData as any).tagNames?.length && tagOwner) {
        for (const tagName of (prodData as any).tagNames) {
          const tag = await this.serviceTagRepo.findOne({
            where: { name: tagName, userId: tagOwner.id },
          });

          if (!tag) {
            this.logger.warn(
              `    ⚠ Service tag "${tagName}" not found — skipping tag assignment`,
            );
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
        this.logger.log(
          `    🏢 Added ${(prodData as any).facilityImages.length} facility image(s)`,
        );
      }
    }

    this.logger.log('Products seeding completed');
  }

  /**
   * Seeds sample TreatmentReview records for a given product by finding
   * its COMPLETED bookings. This ensures review data in product_treatment_reviews
   * is always backed by real appointment + user records.
   */
  private async seedTreatmentReviews(productId: string): Promise<void> {
    const { BookingStatus } =
      await import('@/booking/enums/booking-status.enum');

    // Find up to 5 completed bookings for this product
    const completedBookings = await this.bookingRepo.find({
      where: { productId, status: BookingStatus.COMPLETED },
      relations: ['user'],
      take: 5,
    });

    if (!completedBookings.length) {
      this.logger.log(
        `    ℹ️  No completed bookings for product ${productId} — skipping treatment reviews`,
      );
      return;
    }

    const SAMPLE_REVIEWS = [
      {
        rating: 5,
        comment:
          'Excellent service! The therapist was very professional and the results were amazing.',
        tags: ['Professional', 'Relaxing', 'Clean'],
      },
      {
        rating: 5,
        comment: 'Best experience I have had. Will definitely come back!',
        tags: ['On-time', 'Friendly', 'Clean'],
      },
      {
        rating: 4,
        comment:
          'Great service overall. Highly recommend to anyone looking for quality care.',
        tags: ['Relaxing', 'Professional'],
      },
      {
        rating: 4,
        comment:
          'Very pleasant experience. The facility is spotless and the staff is knowledgeable.',
        tags: ['Clean', 'Friendly'],
      },
      {
        rating: 5,
        comment:
          'Amazing atmosphere and incredibly skilled practitioners. Worth every penny!',
        tags: ['Professional', 'On-time', 'Relaxing'],
      },
    ];

    let seededCount = 0;
    for (let i = 0; i < completedBookings.length; i++) {
      const booking = completedBookings[i];

      // Skip if a review already exists for this booking
      const existing = await this.treatmentReviewRepo.findOne({
        where: { appointmentId: booking.id },
      });
      if (existing) continue;

      const sample = SAMPLE_REVIEWS[i % SAMPLE_REVIEWS.length];
      const review = this.treatmentReviewRepo.create({
        appointmentId: booking.id,
        userId: booking.userId,
        rating: sample.rating,
        comment: sample.comment,
        tags: sample.tags,
        photoUrls: [],
      });
      await this.treatmentReviewRepo.save(review);
      seededCount++;
    }

    if (seededCount > 0) {
      this.logger.log(
        `    ⭐ Seeded ${seededCount} treatment review(s) for product ${productId}`,
      );
    }
  }

  async clear(): Promise<void> {
    const slugs = SEED_PRODUCTS.map((p) => p.slug);

    // Products cascade-delete child rows (service_definitions, service_resource_requirements,
    // product_tags, service_employee_eligibility, media, reviews, facility_images),
    // so we only need to hard-delete products + resource_types.
    const { affected: productAffected } = await this.productRepo.delete({
      slug: In(slugs),
    });
    if (!productAffected) {
      this.logger.warn('⚠ No seed products found to delete');
    } else {
      this.logger.log(
        `🗑️ Hard-deleted ${productAffected} seed product(s) (+ cascaded child rows)`,
      );
    }

    // Clean up resource_types created during seeding
    const resourceTypeNames = [
      ...new Set(
        SEED_PRODUCTS.flatMap((p) => (p as any).resourceRequirements || []).map(
          (r: any) => r.resourceTypeName,
        ),
      ),
    ];

    if (resourceTypeNames.length) {
      const { affected: rtAffected } = await this.resourceTypeRepo.delete({
        name: In(resourceTypeNames),
      });
      if (!rtAffected) {
        this.logger.warn('⚠ No seed resource types found to delete');
      } else {
        this.logger.log(`🗑️ Hard-deleted ${rtAffected} seed resource type(s)`);
      }
    }
  }
}
