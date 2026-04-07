import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, likePrefix, seedKey } from '../utils/seed.utils';

interface SeedPartnerReviewLog {
  code: string;
  partnerTaxCode: string;
  verdict: PartnerVerificationStatus;
  reviewerEmail: string;
  generalComment: string;
}

const SEED_PARTNER_REVIEW_LOGS: SeedPartnerReviewLog[] = [
  {
    code: '001',
    partnerTaxCode: '0123456789',
    verdict: PartnerVerificationStatus.APPROVED,
    reviewerEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    generalComment: seedKey(SEED_MARKERS.partnerReviewComment, 'APPROVED_001'),
  },
  {
    code: '002',
    partnerTaxCode: '5566778899',
    verdict: PartnerVerificationStatus.REQUIRED_RESUBMIT,
    reviewerEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    generalComment: seedKey(SEED_MARKERS.partnerReviewComment, 'RESUBMIT_001'),
  },
  {
    code: '003',
    partnerTaxCode: '1122334455',
    verdict: PartnerVerificationStatus.REJECTED,
    reviewerEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    generalComment: seedKey(SEED_MARKERS.partnerReviewComment, 'REJECTED_001'),
  },
];

@Injectable()
export class PartnerReviewLogSeeder implements ISeeder {
  private readonly logger = new Logger(PartnerReviewLogSeeder.name);

  constructor(
    @InjectRepository(PartnerReviewLog)
    private readonly reviewLogRepo: Repository<PartnerReviewLog>,
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(PartnerDocument)
    private readonly partnerDocumentRepo: Repository<PartnerDocument>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding partner review logs...');

    const [partners, reviewers] = await Promise.all([
      this.partnerRepo.find({
        where: { taxCode: In(SEED_PARTNER_REVIEW_LOGS.map((item) => item.partnerTaxCode)) },
        select: ['id', 'taxCode'],
      }),
      this.accountRepo.find({
        where: {
          email: In([...new Set(SEED_PARTNER_REVIEW_LOGS.map((item) => item.reviewerEmail))]),
        },
        select: ['id', 'email'],
      }),
    ]);

    const partnerMap = new Map(partners.map((partner) => [partner.taxCode, partner]));
    const reviewerMap = new Map(reviewers.map((reviewer) => [reviewer.email, reviewer]));

    for (const seed of SEED_PARTNER_REVIEW_LOGS) {
      const existing = await this.reviewLogRepo.findOne({
        where: { generalComment: seed.generalComment },
      });
      if (existing) {
        this.logger.log(`  ⏭ Review log "${seed.generalComment}" already exists, skipping`);
        continue;
      }

      const partner = partnerMap.get(seed.partnerTaxCode);
      const reviewer = reviewerMap.get(seed.reviewerEmail);
      if (!partner || !reviewer) {
        this.logger.warn(`  ⚠ Missing FK for review log "${seed.code}" — skipping`);
        continue;
      }

      const documents = await this.partnerDocumentRepo.find({
        where: { partnerId: partner.id },
        select: ['documentKey', 'type', 'fileUrl'],
      });

      const isApproved = seed.verdict === PartnerVerificationStatus.APPROVED;
      const documentReviews: NonNullable<PartnerReviewLog['documentReviews']> = {};
      for (const document of documents.slice(0, 2)) {
        documentReviews[document.documentKey] = {
          documentType: document.type,
          url:
            document.fileUrl ??
            `https://cdn.healytics.vn/seed/${document.documentKey}`,
          isValid: isApproved,
          feedback: isApproved
            ? undefined
            : 'Please upload clearer document scans',
        };
      }

      const fieldReviews: NonNullable<PartnerReviewLog['fieldReviews']> = {
        taxCode: {
          value: seed.partnerTaxCode,
          isValid: isApproved,
          feedback: isApproved
            ? undefined
            : 'Tax code verification requires correction',
        },
        legalName: {
          value: partner.legalName,
          isValid: isApproved,
          feedback: isApproved
            ? undefined
            : 'Legal name mismatch against registration document',
        },
      };

      await this.reviewLogRepo.save(
        this.reviewLogRepo.create({
          partnerId: partner.id,
          reviewerId: reviewer.id,
          verdict: seed.verdict,
          fieldReviews,
          documentReviews: Object.keys(documentReviews).length
            ? documentReviews
            : null,
          generalComment: seed.generalComment,
        }),
      );
      this.logger.log(`  ✅ Created partner review log "${seed.generalComment}"`);
    }

    this.logger.log('Partner review log seeding completed');
  }

  async clear(): Promise<void> {
    const { affected } = await this.reviewLogRepo.delete({
      generalComment: Like(likePrefix(SEED_MARKERS.partnerReviewComment)),
    });

    if (!affected) {
      this.logger.warn('⚠ No seed partner review logs found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${affected} seed partner review log(s)`);
  }
}
