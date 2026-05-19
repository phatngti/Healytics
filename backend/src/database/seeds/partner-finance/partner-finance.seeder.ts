import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Booking } from '@/common/entities/booking.entity';
import { Partner } from '@/common/entities/partner.entity';
import { PartnerLedgerTransaction } from '@/common/entities/partner-ledger-transaction.entity';
import { PartnerPayout } from '@/common/entities/partner-payout.entity';
import { PartnerPayoutTransaction } from '@/common/entities/partner-payout-transaction.entity';
import { PartnerRefundCase } from '@/common/entities/partner-refund-case.entity';
import { PartnerTransactionTimeline } from '@/common/entities/partner-transaction-timeline.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';
import { PartnerRefundCaseType } from '@/partner-finance/enums/partner-refund-case-type.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

const daysAgo = (days: number, hour = 10, minute = 0): Date => {
  const date = new Date();
  date.setDate(date.getDate() - days);
  date.setHours(hour, minute, 0, 0);
  return date;
};

const daysFromNow = (days: number, hour = 10, minute = 0): Date => {
  const date = new Date();
  date.setDate(date.getDate() + days);
  date.setHours(hour, minute, 0, 0);
  return date;
};

interface SeedPayout {
  code: string;
  partnerTaxCode: string;
  periodStart: Date;
  periodEnd: Date;
  includedVolume: number;
  feesAdjustments: number;
  netPayout: number;
  scheduledDate: Date;
  methodLabel: string;
  status: PartnerPayoutStatus;
}

interface BookingSelector {
  notes?: string;
  productSlug?: string;
  status?: BookingStatus;
}

interface SeedTimelineEvent {
  title: string;
  description: string | null;
  occurredAt: Date;
}

interface SeedRefundCase {
  caseType: PartnerRefundCaseType;
  requestedAt: Date;
  amount: number;
  reason: string;
  owner: string;
  status: PartnerRefundCaseStatus;
  slaDueAt: Date | null;
}

interface SeedLedgerTransaction {
  code: string;
  partnerTaxCode: string;
  booking?: BookingSelector;
  type: PartnerTransactionType;
  sourceType: PartnerCommerceSourceType;
  grossAmount: number;
  feeAmount: number;
  status: PartnerTransactionStatus;
  settlementStatus: PartnerSettlementStatus;
  payoutStatus: PartnerPayoutStatus;
  payoutCode?: string;
  paymentMethodLabel?: string;
  sourceTitleSnapshot?: string;
  sourceSubtitleSnapshot?: string;
  flaggedForReview?: boolean;
  notes?: string | null;
  createdAt: Date;
  timeline: SeedTimelineEvent[];
  refundCase?: SeedRefundCase;
}

const SEED_PAYOUTS: SeedPayout[] = [
  {
    code: 'SPA_PAID_OUT_001',
    partnerTaxCode: '0123456789',
    periodStart: daysAgo(21),
    periodEnd: daysAgo(14),
    includedVolume: 299000,
    feesAdjustments: 29900,
    netPayout: 269100,
    scheduledDate: daysAgo(9, 9),
    methodLabel: 'Vietcombank ending 1122',
    status: PartnerPayoutStatus.PAID_OUT,
  },
  {
    code: 'SPA_IN_PAYOUT_001',
    partnerTaxCode: '0123456789',
    periodStart: daysAgo(8),
    periodEnd: daysAgo(1),
    includedVolume: 400000,
    feesAdjustments: 40000,
    netPayout: 360000,
    scheduledDate: daysFromNow(2, 9),
    methodLabel: 'Vietcombank ending 1122',
    status: PartnerPayoutStatus.IN_PAYOUT,
  },
  {
    code: 'SPA_FAILED_001',
    partnerTaxCode: '0123456789',
    periodStart: daysAgo(24),
    periodEnd: daysAgo(18),
    includedVolume: 450000,
    feesAdjustments: 45000,
    netPayout: 405000,
    scheduledDate: daysAgo(2, 15),
    methodLabel: 'ACB ending 4388',
    status: PartnerPayoutStatus.FAILED,
  },
  {
    code: 'DENTAL_PAID_OUT_001',
    partnerTaxCode: '0987654321',
    periodStart: daysAgo(49),
    periodEnd: daysAgo(42),
    includedVolume: 1200000,
    feesAdjustments: 120000,
    netPayout: 1080000,
    scheduledDate: daysAgo(38, 9),
    methodLabel: 'Techcombank ending 8877',
    status: PartnerPayoutStatus.PAID_OUT,
  },
  {
    code: 'DENTAL_IN_PAYOUT_001',
    partnerTaxCode: '0987654321',
    periodStart: daysAgo(3),
    periodEnd: daysFromNow(4),
    includedVolume: 1200000,
    feesAdjustments: 120000,
    netPayout: 1080000,
    scheduledDate: daysFromNow(5, 9),
    methodLabel: 'Techcombank ending 8877',
    status: PartnerPayoutStatus.IN_PAYOUT,
  },
  {
    code: 'FITNESS_IN_PAYOUT_001',
    partnerTaxCode: '1122334455',
    periodStart: daysAgo(4),
    periodEnd: daysFromNow(3),
    includedVolume: 180000,
    feesAdjustments: 18000,
    netPayout: 162000,
    scheduledDate: daysFromNow(6, 9),
    methodLabel: 'VPBank ending 2299',
    status: PartnerPayoutStatus.IN_PAYOUT,
  },
  {
    code: 'PHARMA_PAID_OUT_001',
    partnerTaxCode: '5566778899',
    periodStart: daysAgo(15),
    periodEnd: daysAgo(8),
    includedVolume: 650000,
    feesAdjustments: 65000,
    netPayout: 585000,
    scheduledDate: daysAgo(5, 9),
    methodLabel: 'MB Bank ending 9044',
    status: PartnerPayoutStatus.PAID_OUT,
  },
  {
    code: 'HERITAGE_PAID_OUT_001',
    partnerTaxCode: '6677889900',
    periodStart: daysAgo(21),
    periodEnd: daysAgo(14),
    includedVolume: 520000,
    feesAdjustments: 52000,
    netPayout: 468000,
    scheduledDate: daysAgo(11, 9),
    methodLabel: 'Sacombank ending 4410',
    status: PartnerPayoutStatus.PAID_OUT,
  },
  {
    code: 'MINDSKIN_IN_PAYOUT_001',
    partnerTaxCode: '7788990011',
    periodStart: daysAgo(3),
    periodEnd: daysFromNow(4),
    includedVolume: 900000,
    feesAdjustments: 90000,
    netPayout: 810000,
    scheduledDate: daysFromNow(5, 10),
    methodLabel: 'BIDV ending 7012',
    status: PartnerPayoutStatus.IN_PAYOUT,
  },
];

const SEED_TRANSACTIONS: SeedLedgerTransaction[] = [
  {
    code: 'SPA_MASSAGE_PAID_OUT',
    partnerTaxCode: '0123456789',
    booking: { notes: 'Please use lavender oil' },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 299000,
    feeAmount: 29900,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SETTLED,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    payoutCode: 'SPA_PAID_OUT_001',
    createdAt: daysAgo(14, 9, 40),
    timeline: [
      {
        title: 'Payment captured',
        description: 'MoMo payment was confirmed for the massage booking.',
        occurredAt: daysAgo(14, 9, 40),
      },
      {
        title: 'Settlement completed',
        description: 'Funds were settled and included in the partner payout.',
        occurredAt: daysAgo(10, 15, 20),
      },
      {
        title: 'Payout completed',
        description: 'Net payout was transferred to the partner bank account.',
        occurredAt: daysAgo(9, 10, 5),
      },
    ],
  },
  {
    code: 'SPA_NECK_IN_PAYOUT',
    partnerTaxCode: '0123456789',
    booking: {
      productSlug: 'neck-shoulder-therapy',
      status: BookingStatus.COMPLETED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 400000,
    feeAmount: 40000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SCHEDULED,
    payoutStatus: PartnerPayoutStatus.IN_PAYOUT,
    payoutCode: 'SPA_IN_PAYOUT_001',
    createdAt: daysAgo(7, 15, 0),
    timeline: [
      {
        title: 'Cash payment reconciled',
        description: 'Front desk marked the appointment as paid.',
        occurredAt: daysAgo(7, 15, 0),
      },
      {
        title: 'Payout scheduled',
        description: 'The transaction was queued for the next weekly payout.',
        occurredAt: daysAgo(1, 17, 30),
      },
    ],
  },
  {
    code: 'SPA_FACIAL_FAILED_PAYOUT',
    partnerTaxCode: '0123456789',
    booking: {
      productSlug: 'basic-facial-care-package',
      status: BookingStatus.COMPLETED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 450000,
    feeAmount: 45000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.HELD,
    payoutStatus: PartnerPayoutStatus.FAILED,
    payoutCode: 'SPA_FAILED_001',
    flaggedForReview: true,
    notes: 'Partner requested payout review after failed bank transfer.',
    createdAt: daysAgo(21, 11, 5),
    timeline: [
      {
        title: 'Payment captured',
        description: 'VNPay payment was confirmed for the facial package.',
        occurredAt: daysAgo(21, 11, 5),
      },
      {
        title: 'Payout failed',
        description:
          'Bank rejected the payout due to account verification mismatch.',
        occurredAt: daysAgo(2, 15, 20),
      },
      {
        title: 'Flagged for review',
        description: 'Partner asked finance to review the failed payout.',
        occurredAt: daysAgo(1, 9, 0),
      },
    ],
    refundCase: {
      caseType: PartnerRefundCaseType.DISPUTE,
      requestedAt: daysAgo(1, 9),
      amount: 450000,
      reason: 'Customer asked for confirmation before funds are released.',
      owner: 'Finance Operations',
      status: PartnerRefundCaseStatus.UNDER_REVIEW,
      slaDueAt: daysFromNow(1, 17),
    },
  },
  {
    code: 'SPA_NECK_REFUND',
    partnerTaxCode: '0123456789',
    booking: {
      productSlug: 'neck-shoulder-therapy',
      status: BookingStatus.CANCELLED,
    },
    type: PartnerTransactionType.REFUND,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 400000,
    feeAmount: 0,
    status: PartnerTransactionStatus.REFUNDED,
    settlementStatus: PartnerSettlementStatus.HELD,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    paymentMethodLabel: 'MoMo Wallet',
    createdAt: daysAgo(5, 10, 30),
    timeline: [
      {
        title: 'Refund requested',
        description: 'Customer cancelled and requested refund processing.',
        occurredAt: daysAgo(5, 9, 10),
      },
      {
        title: 'Refund approved',
        description: 'Refund was approved and sent to the payment gateway.',
        occurredAt: daysAgo(5, 10, 30),
      },
    ],
    refundCase: {
      caseType: PartnerRefundCaseType.REFUND,
      requestedAt: daysAgo(5, 9),
      amount: 400000,
      reason: 'Customer cancelled before appointment start time.',
      owner: 'Customer Support',
      status: PartnerRefundCaseStatus.APPROVED,
      slaDueAt: null,
    },
  },
  {
    code: 'SPA_UPCOMING_CHARGE',
    partnerTaxCode: '0123456789',
    booking: {
      productSlug: 'full-body-massage-60-min',
      status: BookingStatus.CONFIRMED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 299000,
    feeAmount: 29900,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.UNSETTLED,
    payoutStatus: PartnerPayoutStatus.NOT_ASSIGNED,
    createdAt: daysAgo(1, 10, 10),
    timeline: [
      {
        title: 'Payment authorized',
        description:
          'MoMo payment was authorized for the upcoming appointment.',
        occurredAt: daysAgo(1, 10, 10),
      },
    ],
  },
  {
    code: 'SPA_PLATFORM_FEE',
    partnerTaxCode: '0123456789',
    type: PartnerTransactionType.FEE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 0,
    feeAmount: 25000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SETTLED,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    paymentMethodLabel: 'Healytics settlement',
    sourceTitleSnapshot: 'Monthly platform fee',
    sourceSubtitleSnapshot:
      'Operational fee adjustment for marketplace services',
    createdAt: daysAgo(3, 8),
    timeline: [
      {
        title: 'Fee applied',
        description: 'Monthly platform fee was applied to the partner ledger.',
        occurredAt: daysAgo(3, 8),
      },
    ],
  },
  {
    code: 'DENTAL_WHITENING_PAID_OUT',
    partnerTaxCode: '0987654321',
    booking: {
      productSlug: 'professional-teeth-whitening',
      status: BookingStatus.COMPLETED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 1200000,
    feeAmount: 120000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SETTLED,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    payoutCode: 'DENTAL_PAID_OUT_001',
    createdAt: daysAgo(45, 12, 50),
    timeline: [
      {
        title: 'Payment captured',
        description: 'Cash payment was reconciled for teeth whitening.',
        occurredAt: daysAgo(45, 12, 50),
      },
      {
        title: 'Payout completed',
        description: 'Dental clinic payout was completed.',
        occurredAt: daysAgo(38, 10),
      },
    ],
  },
  {
    code: 'DENTAL_UPCOMING_IN_PAYOUT',
    partnerTaxCode: '0987654321',
    booking: {
      productSlug: 'professional-teeth-whitening',
      status: BookingStatus.CONFIRMED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 1200000,
    feeAmount: 120000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SCHEDULED,
    payoutStatus: PartnerPayoutStatus.IN_PAYOUT,
    payoutCode: 'DENTAL_IN_PAYOUT_001',
    createdAt: daysAgo(2, 9, 10),
    timeline: [
      {
        title: 'Payment captured',
        description:
          'VNPay payment was confirmed for the upcoming dental booking.',
        occurredAt: daysAgo(2, 9, 10),
      },
      {
        title: 'Payout scheduled',
        description: 'The charge is included in the upcoming dental payout.',
        occurredAt: daysAgo(1, 16),
      },
    ],
  },
  {
    code: 'FITNESS_YOGA_IN_PAYOUT',
    partnerTaxCode: '1122334455',
    booking: {
      productSlug: 'sports-recovery-yoga-session',
      status: BookingStatus.CONFIRMED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 180000,
    feeAmount: 18000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SCHEDULED,
    payoutStatus: PartnerPayoutStatus.IN_PAYOUT,
    payoutCode: 'FITNESS_IN_PAYOUT_001',
    createdAt: daysAgo(1, 12, 10),
    timeline: [
      {
        title: 'Payment captured',
        description:
          'MoMo payment was confirmed for the recovery yoga booking.',
        occurredAt: daysAgo(1, 12, 10),
      },
      {
        title: 'Payout scheduled',
        description: 'The charge is included in the next fitness payout.',
        occurredAt: daysAgo(1, 17),
      },
    ],
  },
  {
    code: 'PHARMA_NUTRITION_PAID_OUT',
    partnerTaxCode: '5566778899',
    booking: {
      productSlug: 'nutrition-consultation-meal-plan',
      status: BookingStatus.COMPLETED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 650000,
    feeAmount: 65000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SETTLED,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    payoutCode: 'PHARMA_PAID_OUT_001',
    createdAt: daysAgo(12, 12, 55),
    timeline: [
      {
        title: 'Stripe payment captured',
        description: 'Stripe payment was confirmed for nutrition consultation.',
        occurredAt: daysAgo(12, 12, 55),
      },
      {
        title: 'Payout completed',
        description: 'Nutrition consultation proceeds were paid out.',
        occurredAt: daysAgo(5, 9, 30),
      },
    ],
  },
  {
    code: 'HERITAGE_ACUPUNCTURE_PAID_OUT',
    partnerTaxCode: '6677889900',
    booking: {
      productSlug: 'herbal-acupuncture-therapy',
      status: BookingStatus.COMPLETED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 520000,
    feeAmount: 52000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SETTLED,
    payoutStatus: PartnerPayoutStatus.PAID_OUT,
    payoutCode: 'HERITAGE_PAID_OUT_001',
    createdAt: daysAgo(18, 16, 25),
    timeline: [
      {
        title: 'Cash payment reconciled',
        description:
          'Clinic reconciled cash payment after acupuncture session.',
        occurredAt: daysAgo(18, 16, 25),
      },
      {
        title: 'Payout completed',
        description: 'Acupuncture proceeds were transferred to the clinic.',
        occurredAt: daysAgo(11, 9, 30),
      },
    ],
  },
  {
    code: 'HERITAGE_NO_SHOW_DEPOSIT',
    partnerTaxCode: '6677889900',
    booking: {
      productSlug: 'herbal-acupuncture-therapy',
      status: BookingStatus.NO_SHOW,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 200000,
    feeAmount: 20000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.HELD,
    payoutStatus: PartnerPayoutStatus.NOT_ASSIGNED,
    createdAt: daysAgo(4, 9, 20),
    flaggedForReview: true,
    notes: 'Deposit retained after no-show pending support review.',
    timeline: [
      {
        title: 'Deposit captured',
        description: 'MoMo deposit was captured for the acupuncture booking.',
        occurredAt: daysAgo(4, 9, 20),
      },
      {
        title: 'No-show marked',
        description: 'Clinic marked the booking as no-show.',
        occurredAt: daysAgo(3, 11, 20),
      },
    ],
    refundCase: {
      caseType: PartnerRefundCaseType.DISPUTE,
      requestedAt: daysAgo(2, 10),
      amount: 200000,
      reason: 'Customer requested deposit review after traffic delay.',
      owner: 'Customer Support',
      status: PartnerRefundCaseStatus.UNDER_REVIEW,
      slaDueAt: daysFromNow(2, 17),
    },
  },
  {
    code: 'MINDSKIN_COUNSELING_IN_PAYOUT',
    partnerTaxCode: '7788990011',
    booking: {
      productSlug: 'stress-anxiety-counseling',
      status: BookingStatus.CONFIRMED,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 900000,
    feeAmount: 90000,
    status: PartnerTransactionStatus.PAID,
    settlementStatus: PartnerSettlementStatus.SCHEDULED,
    payoutStatus: PartnerPayoutStatus.IN_PAYOUT,
    payoutCode: 'MINDSKIN_IN_PAYOUT_001',
    createdAt: daysAgo(2, 16, 15),
    timeline: [
      {
        title: 'Stripe payment captured',
        description: 'Stripe payment was confirmed for counseling booking.',
        occurredAt: daysAgo(2, 16, 15),
      },
      {
        title: 'Payout scheduled',
        description: 'The counseling transaction entered payout processing.',
        occurredAt: daysAgo(1, 16, 30),
      },
    ],
  },
  {
    code: 'MINDSKIN_DERM_PENDING',
    partnerTaxCode: '7788990011',
    booking: {
      productSlug: 'dermatology-acne-consultation',
      status: BookingStatus.PENDING_PAYMENT,
    },
    type: PartnerTransactionType.CHARGE,
    sourceType: PartnerCommerceSourceType.SERVICE_BOOKING,
    grossAmount: 750000,
    feeAmount: 75000,
    status: PartnerTransactionStatus.PENDING,
    settlementStatus: PartnerSettlementStatus.UNSETTLED,
    payoutStatus: PartnerPayoutStatus.NOT_ASSIGNED,
    paymentMethodLabel: 'MoMo Wallet',
    createdAt: daysAgo(1, 11),
    timeline: [
      {
        title: 'Payment link created',
        description: 'MoMo payment link is waiting for customer authorization.',
        occurredAt: daysAgo(1, 11),
      },
    ],
  },
];

@Injectable()
export class PartnerFinanceSeeder implements ISeeder {
  private readonly logger = new Logger(PartnerFinanceSeeder.name);

  constructor(
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(UserProfile)
    private readonly userProfileRepo: Repository<UserProfile>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(PartnerPayout)
    private readonly payoutRepo: Repository<PartnerPayout>,
    @InjectRepository(PartnerLedgerTransaction)
    private readonly ledgerRepo: Repository<PartnerLedgerTransaction>,
    @InjectRepository(PartnerPayoutTransaction)
    private readonly payoutTxnRepo: Repository<PartnerPayoutTransaction>,
    @InjectRepository(PartnerRefundCase)
    private readonly refundCaseRepo: Repository<PartnerRefundCase>,
    @InjectRepository(PartnerTransactionTimeline)
    private readonly timelineRepo: Repository<PartnerTransactionTimeline>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding partner finance data...');

    const partners = await this.partnerRepo.find({
      where: {
        taxCode: In([
          ...new Set([
            ...SEED_PAYOUTS.map((item) => item.partnerTaxCode),
            ...SEED_TRANSACTIONS.map((item) => item.partnerTaxCode),
          ]),
        ]),
      },
      select: ['id', 'taxCode', 'brandName', 'accountId'],
    });
    const partnerMap = buildMapBy(partners, (partner) => partner.taxCode);

    const payoutMap = await this.seedPayouts(partnerMap);
    const context = await this.loadBookingContext();
    const transactionMap = await this.seedTransactions(
      partnerMap,
      payoutMap,
      context,
    );

    await this.seedPayoutTransactionLinks(transactionMap, payoutMap);
    await this.seedRefundCases(transactionMap);
    await this.seedTimelineEvents(transactionMap, partnerMap);

    this.logger.log('Partner finance seeding completed');
  }

  private async seedPayouts(
    partnerMap: Map<string, Partner>,
  ): Promise<Map<string, PartnerPayout>> {
    const payoutMap = new Map<string, PartnerPayout>();

    for (const seed of SEED_PAYOUTS) {
      const partner = partnerMap.get(seed.partnerTaxCode);
      if (!partner) {
        this.logger.warn(
          `  ⚠ Partner "${seed.partnerTaxCode}" not found — skipping payout "${seed.code}"`,
        );
        continue;
      }

      const providerPayoutId = seedKey(
        SEED_MARKERS.partnerFinancePayoutProviderId,
        seed.code,
      );
      let payout = await this.payoutRepo.findOne({
        where: { providerPayoutId },
      });
      const payload = {
        partnerId: partner.id,
        periodStart: seed.periodStart,
        periodEnd: seed.periodEnd,
        includedVolume: seed.includedVolume,
        feesAdjustments: seed.feesAdjustments,
        netPayout: seed.netPayout,
        scheduledDate: seed.scheduledDate,
        methodLabel: seed.methodLabel,
        status: seed.status,
        currency: 'VND',
        providerPayoutId,
      };

      payout = payout
        ? await this.payoutRepo.save({ ...payout, ...payload })
        : await this.payoutRepo.save(this.payoutRepo.create(payload));

      payoutMap.set(seed.code, payout);
      this.logger.log(
        `  ✅ Upserted payout "${seed.code}" for ${partner.brandName}`,
      );
    }

    return payoutMap;
  }

  private async loadBookingContext(): Promise<{
    bookings: Booking[];
    profileMap: Map<string, UserProfile>;
  }> {
    const bookings = await this.bookingRepo.find({
      relations: ['product', 'user', 'payments'],
      order: { startTime: 'ASC' },
    });

    const userIds = [...new Set(bookings.map((booking) => booking.userId))];
    const profiles = userIds.length
      ? await this.userProfileRepo.find({ where: { accountId: In(userIds) } })
      : [];

    return {
      bookings,
      profileMap: buildMapBy(profiles, (profile) => profile.accountId ?? ''),
    };
  }

  private async seedTransactions(
    partnerMap: Map<string, Partner>,
    payoutMap: Map<string, PartnerPayout>,
    context: { bookings: Booking[]; profileMap: Map<string, UserProfile> },
  ): Promise<Map<string, PartnerLedgerTransaction>> {
    const transactionMap = new Map<string, PartnerLedgerTransaction>();

    for (const seed of SEED_TRANSACTIONS) {
      const partner = partnerMap.get(seed.partnerTaxCode);
      if (!partner) {
        this.logger.warn(
          `  ⚠ Partner "${seed.partnerTaxCode}" not found — skipping transaction "${seed.code}"`,
        );
        continue;
      }

      const booking = seed.booking
        ? this.resolveBooking(seed.booking, context.bookings)
        : null;
      if (seed.booking && !booking) {
        this.logger.warn(
          `  ⚠ Booking not found for transaction "${seed.code}" — skipping`,
        );
        continue;
      }

      if (
        booking?.product?.partnerId &&
        booking.product.partnerId !== partner.id
      ) {
        this.logger.warn(
          `  ⚠ Booking/product partner mismatch for transaction "${seed.code}" — skipping`,
        );
        continue;
      }

      const payout = seed.payoutCode ? payoutMap.get(seed.payoutCode) : null;
      if (seed.payoutCode && !payout) {
        this.logger.warn(
          `  ⚠ Payout "${seed.payoutCode}" not found — skipping transaction "${seed.code}"`,
        );
        continue;
      }

      const reference = seedKey(
        SEED_MARKERS.partnerFinanceReference,
        seed.code,
      );
      const existing = await this.ledgerRepo.findOne({ where: { reference } });
      const paymentMethodLabel =
        seed.paymentMethodLabel ??
        this.paymentMethodLabel(booking) ??
        'Healytics Pay';
      const sourceTitleSnapshot =
        seed.sourceTitleSnapshot ??
        booking?.product?.name ??
        'Partner finance adjustment';
      const sourceSubtitleSnapshot =
        seed.sourceSubtitleSnapshot ??
        (booking
          ? `${partner.brandName} | ${booking.startTime.toISOString()}`
          : partner.brandName);

      const payload = {
        partnerId: partner.id,
        type: seed.type,
        sourceType: seed.sourceType,
        sourceId: booking?.id ?? null,
        reference,
        customerNameSnapshot: this.customerName(
          booking?.user ?? null,
          context.profileMap,
        ),
        grossAmount: seed.grossAmount,
        feeAmount: seed.feeAmount,
        currency: 'VND',
        status: seed.status,
        settlementStatus: seed.settlementStatus,
        payoutStatus: seed.payoutStatus,
        paymentMethodLabel,
        sourceTitleSnapshot,
        sourceSubtitleSnapshot,
        flaggedForReview: seed.flaggedForReview ?? false,
        notes: seed.notes ?? null,
        payoutId: payout?.id ?? null,
        createdAt: seed.createdAt,
        updatedAt: new Date(),
      };

      const transaction = existing
        ? await this.ledgerRepo.save({ ...existing, ...payload })
        : await this.ledgerRepo.save(this.ledgerRepo.create(payload));

      transactionMap.set(seed.code, transaction);
      this.logger.log(`  ✅ Upserted finance transaction "${reference}"`);
    }

    return transactionMap;
  }

  private async seedPayoutTransactionLinks(
    transactionMap: Map<string, PartnerLedgerTransaction>,
    payoutMap: Map<string, PartnerPayout>,
  ): Promise<void> {
    const transactionIds = [...transactionMap.values()].map(
      (transaction) => transaction.id,
    );
    if (transactionIds.length) {
      await this.payoutTxnRepo.delete({ transactionId: In(transactionIds) });
    }

    for (const seed of SEED_TRANSACTIONS) {
      if (!seed.payoutCode) continue;

      const transaction = transactionMap.get(seed.code);
      const payout = payoutMap.get(seed.payoutCode);
      if (!transaction || !payout) continue;

      await this.payoutTxnRepo.save(
        this.payoutTxnRepo.create({
          payoutId: payout.id,
          transactionId: transaction.id,
          partnerId: transaction.partnerId,
        }),
      );
      this.logger.log(
        `  🔗 Linked transaction "${seed.code}" to payout "${seed.payoutCode}"`,
      );
    }
  }

  private async seedRefundCases(
    transactionMap: Map<string, PartnerLedgerTransaction>,
  ): Promise<void> {
    const refundTransactionIds = SEED_TRANSACTIONS.filter(
      (seed) => seed.refundCase && transactionMap.has(seed.code),
    ).map((seed) => transactionMap.get(seed.code)!.id);

    if (refundTransactionIds.length) {
      await this.refundCaseRepo.delete({
        transactionId: In(refundTransactionIds),
      });
    }

    for (const seed of SEED_TRANSACTIONS) {
      if (!seed.refundCase) continue;
      const transaction = transactionMap.get(seed.code);
      if (!transaction) continue;

      await this.refundCaseRepo.save(
        this.refundCaseRepo.create({
          partnerId: transaction.partnerId,
          transactionId: transaction.id,
          caseType: seed.refundCase.caseType,
          requestedAt: seed.refundCase.requestedAt,
          amount: seed.refundCase.amount,
          currency: 'VND',
          reason: seed.refundCase.reason,
          owner: seed.refundCase.owner,
          status: seed.refundCase.status,
          slaDueAt: seed.refundCase.slaDueAt,
        }),
      );
      this.logger.log(`  ✅ Created refund case for "${seed.code}"`);
    }
  }

  private async seedTimelineEvents(
    transactionMap: Map<string, PartnerLedgerTransaction>,
    partnerMap: Map<string, Partner>,
  ): Promise<void> {
    const transactionIds = [...transactionMap.values()].map(
      (transaction) => transaction.id,
    );
    if (transactionIds.length) {
      await this.timelineRepo.delete({ transactionId: In(transactionIds) });
    }

    const accountIds = [
      ...new Set([...partnerMap.values()].map((partner) => partner.accountId)),
    ];
    const accounts = accountIds.length
      ? await this.accountRepo.find({
          where: { id: In(accountIds) },
          select: ['id', 'email'],
        })
      : [];
    const accountIdSet = new Set(accounts.map((account) => account.id));

    for (const seed of SEED_TRANSACTIONS) {
      const transaction = transactionMap.get(seed.code);
      const partner = partnerMap.get(seed.partnerTaxCode);
      if (!transaction || !partner) continue;

      const actorAccountId = accountIdSet.has(partner.accountId)
        ? partner.accountId
        : null;
      for (const event of seed.timeline) {
        await this.timelineRepo.save(
          this.timelineRepo.create({
            transactionId: transaction.id,
            partnerId: transaction.partnerId,
            title: event.title,
            description: event.description,
            occurredAt: event.occurredAt,
            actorAccountId,
            metadata: { seedCode: seed.code },
          }),
        );
      }
      this.logger.log(
        `  🧾 Created ${seed.timeline.length} timeline event(s) for "${seed.code}"`,
      );
    }
  }

  private resolveBooking(
    selector: BookingSelector,
    bookings: Booking[],
  ): Booking | null {
    const matches = bookings.filter((booking) => {
      if (selector.notes !== undefined && booking.notes !== selector.notes)
        return false;
      if (selector.status && booking.status !== selector.status) return false;
      if (
        selector.productSlug &&
        booking.product?.slug !== selector.productSlug
      )
        return false;
      return true;
    });

    return matches[0] ?? null;
  }

  private paymentMethodLabel(booking: Booking | null): string | null {
    const payment = booking?.payments?.[0];
    if (!payment) return null;

    const labels: Record<string, string> = {
      [PaymentMethod.MOMO]: 'MoMo Wallet',
      [PaymentMethod.VNPAY]: 'VNPay Gateway',
      [PaymentMethod.CASH]: 'Cash at clinic',
    };

    return labels[payment.paymentMethod] ?? payment.paymentMethod;
  }

  private customerName(
    account: Account | null,
    profileMap: Map<string, UserProfile>,
  ): string {
    if (!account) return 'Partner ledger adjustment';

    const profile = profileMap.get(account.id);
    const displayName = [profile?.firstName, profile?.lastName]
      .filter(Boolean)
      .join(' ')
      .trim();

    return displayName || account.email;
  }

  async clear(): Promise<void> {
    const transactions = await this.ledgerRepo.find({
      where: {
        reference: Like(likePrefix(SEED_MARKERS.partnerFinanceReference)),
      },
      select: ['id', 'payoutId'],
    });
    const payouts = await this.payoutRepo.find({
      where: {
        providerPayoutId: Like(
          likePrefix(SEED_MARKERS.partnerFinancePayoutProviderId),
        ),
      },
      select: ['id'],
    });

    const transactionIds = transactions.map((transaction) => transaction.id);
    const payoutIds = [
      ...new Set([
        ...payouts.map((payout) => payout.id),
        ...transactions
          .map((transaction) => transaction.payoutId)
          .filter((id): id is string => Boolean(id)),
      ]),
    ];

    if (!transactionIds.length && !payoutIds.length) {
      this.logger.warn('⚠ No seed partner finance records found to delete');
      return;
    }

    if (transactionIds.length) {
      await this.refundCaseRepo.delete({ transactionId: In(transactionIds) });
      await this.timelineRepo.delete({ transactionId: In(transactionIds) });
    }

    if (transactionIds.length || payoutIds.length) {
      let deleteLinks = this.payoutTxnRepo.createQueryBuilder().delete();
      if (transactionIds.length) {
        deleteLinks = deleteLinks.where(
          'transaction_id IN (:...transactionIds)',
          {
            transactionIds,
          },
        );
      }
      if (payoutIds.length) {
        deleteLinks = transactionIds.length
          ? deleteLinks.orWhere('payout_id IN (:...payoutIds)', { payoutIds })
          : deleteLinks.where('payout_id IN (:...payoutIds)', { payoutIds });
      }
      await deleteLinks.execute();
    }

    if (transactionIds.length) {
      const { affected } = await this.ledgerRepo.delete({
        id: In(transactionIds),
      });
      this.logger.log(
        `🗑️ Hard-deleted ${affected ?? 0} seed partner finance transaction(s)`,
      );
    }

    if (payoutIds.length) {
      const { affected } = await this.payoutRepo.delete({ id: In(payoutIds) });
      this.logger.log(
        `🗑️ Hard-deleted ${affected ?? 0} seed partner payout(s)`,
      );
    }
  }
}
