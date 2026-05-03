import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { Product } from '@/common/entities/product.entity';
import { Booking } from '@/common/entities/booking.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';
import { ClinicReviewResponse } from '@/clinic/entities/clinic-review-response.entity';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

interface SeedCertification {
  partnerTaxCode: string;
  title: string;
  subtitle: string | null;
  iconName: string;
  sortOrder: number;
}

const SEED_CERTIFICATIONS: SeedCertification[] = [
  {
    partnerTaxCode: '0123456789',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'JCI_ACCREDITED'),
    subtitle: 'International quality standards',
    iconName: 'verified',
    sortOrder: 1,
  },
  {
    partnerTaxCode: '0123456789',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'LICENSED_STAFF'),
    subtitle: 'Licensed specialists and therapists',
    iconName: 'medical_services',
    sortOrder: 2,
  },
  {
    partnerTaxCode: '0987654321',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'DENTAL_SAFETY'),
    subtitle: 'Sterilization and dental safety compliance',
    iconName: 'health_and_safety',
    sortOrder: 1,
  },
  {
    partnerTaxCode: '1122334455',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'RECOVERY_COACHES'),
    subtitle: 'Certified mobility and recovery coaches',
    iconName: 'fitness_center',
    sortOrder: 1,
  },
  {
    partnerTaxCode: '5566778899',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'GPP_READY'),
    subtitle: 'Good pharmacy practice resubmission package',
    iconName: 'local_pharmacy',
    sortOrder: 1,
  },
  {
    partnerTaxCode: '6677889900',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'YHCT_LICENSED'),
    subtitle: 'Traditional medicine treatment license',
    iconName: 'eco',
    sortOrder: 1,
  },
  {
    partnerTaxCode: '7788990011',
    title: seedKey(SEED_MARKERS.clinicCertificationTitle, 'MULTI_SPECIALTY'),
    subtitle: 'Dermatology and psychology care teams',
    iconName: 'psychology',
    sortOrder: 1,
  },
];

@Injectable()
export class ClinicSeeder implements ISeeder {
  private readonly logger = new Logger(ClinicSeeder.name);

  constructor(
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepo: Repository<TreatmentReview>,
    @InjectRepository(PartnerCertification)
    private readonly certificationRepo: Repository<PartnerCertification>,
    @InjectRepository(ClinicReviewResponse)
    private readonly clinicResponseRepo: Repository<ClinicReviewResponse>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding clinic data...');
    await this.seedCertifications();
    await this.seedClinicResponses();
    this.logger.log('Clinic seeding completed');
  }

  private async seedCertifications(): Promise<void> {
    const partners = await this.partnerRepo.find({
      where: {
        taxCode: In([
          ...new Set(SEED_CERTIFICATIONS.map((item) => item.partnerTaxCode)),
        ]),
      },
      select: ['id', 'taxCode'],
    });
    const partnerMap = buildMapBy(partners, (partner) => partner.taxCode);

    for (const seed of SEED_CERTIFICATIONS) {
      const partner = partnerMap.get(seed.partnerTaxCode);
      if (!partner) {
        this.logger.warn(
          `  ⚠ Partner "${seed.partnerTaxCode}" not found — skipping certification`,
        );
        continue;
      }

      const existing = await this.certificationRepo.findOne({
        where: { partnerId: partner.id, title: seed.title },
      });
      if (existing) {
        existing.subtitle = seed.subtitle;
        existing.iconName = seed.iconName;
        existing.sortOrder = seed.sortOrder;
        await this.certificationRepo.save(existing);
        this.logger.log(`  🔄 Updated certification "${seed.title}"`);
        continue;
      }

      await this.certificationRepo.save(
        this.certificationRepo.create({
          partnerId: partner.id,
          title: seed.title,
          subtitle: seed.subtitle,
          iconName: seed.iconName,
          sortOrder: seed.sortOrder,
        }),
      );
      this.logger.log(`  ✅ Created certification "${seed.title}"`);
    }
  }

  private async seedClinicResponses(): Promise<void> {
    const reviews = await this.treatmentReviewRepo.find({
      relations: ['booking'],
      order: { createdAt: 'ASC' },
      take: 12,
    });

    for (const review of reviews) {
      const existing = await this.clinicResponseRepo.findOne({
        where: { reviewId: review.id },
      });
      if (existing) {
        continue;
      }

      if (!review.booking?.productId) {
        this.logger.warn(
          `  ⚠ Review "${review.id}" has no product booking context — skipping`,
        );
        continue;
      }

      const product = await this.productRepo.findOne({
        where: { id: review.booking.productId },
        select: ['id', 'partnerId'],
      });
      if (!product?.partnerId) {
        this.logger.warn(
          `  ⚠ Product "${review.booking.productId}" has no partner — skipping`,
        );
        continue;
      }

      const responseText =
        `${seedKey(SEED_MARKERS.clinicResponseText, review.id.slice(0, 8))} ` +
        'Thank you for your feedback. Our clinic team will keep improving service quality.';

      await this.clinicResponseRepo.save(
        this.clinicResponseRepo.create({
          reviewId: review.id,
          partnerId: product.partnerId,
          responseText,
        }),
      );
      this.logger.log(`  ✅ Created clinic response for review "${review.id}"`);
    }
  }

  async clear(): Promise<void> {
    const { affected: responseAffected } = await this.clinicResponseRepo.delete(
      {
        responseText: Like(likePrefix(SEED_MARKERS.clinicResponseText)),
      },
    );
    if (responseAffected) {
      this.logger.log(
        `🗑️ Hard-deleted ${responseAffected} seed clinic response(s)`,
      );
    }

    const { affected: certAffected } = await this.certificationRepo.delete({
      title: Like(likePrefix(SEED_MARKERS.clinicCertificationTitle)),
    });
    if (!certAffected) {
      this.logger.warn('⚠ No seed clinic certifications found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${certAffected} seed certification(s)`);
  }
}
