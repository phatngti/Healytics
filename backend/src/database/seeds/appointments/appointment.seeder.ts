import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Payment } from '@/common/entities/payment.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { Role } from '@/account/enum/role.enum';
import { ISeeder } from '../seeder.interface';

const seedAppointmentMarker = (idempotencyKey: string): string =>
  `SEED_APPOINTMENT:${idempotencyKey}`;

// ─────────────────────────────────────────────────────────────────────────────
// Relative booking time helpers (so data stays realistic when seeded later)
// ─────────────────────────────────────────────────────────────────────────────
const daysAgo = (n: number, hour = 10, minute = 0) => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  d.setHours(hour, minute, 0, 0);
  return d;
};

const daysFromNow = (n: number, hour = 10, minute = 0) => {
  const d = new Date();
  d.setDate(d.getDate() + n);
  d.setHours(hour, minute, 0, 0);
  return d;
};

// ─────────────────────────────────────────────────────────────────────────────
// Seed data definitions
// Each entry is matched to seeded users (by email) and employees (by code).
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Appointments seeded for the test user.
 *
 * Mix of statuses to exercise every UI state in the user app:
 *   - COMPLETED + isReviewed=false  → shows "Write a Review" CTA
 *   - COMPLETED + isReviewed=true   → shows "Reviewed" badge; has review records
 *   - CONFIRMED                     → upcoming appointment
 *   - CANCELLED                     → cancelled appointment
 *   - PENDING_PAYMENT               → waiting for payment
 */
const SEED_APPOINTMENTS: {
  /** Idempotency key — used to detect existing seed records */
  idempotencyKey: string;
  userEmail: string;
  staffCode: string;
  productSlug: string | null;
  startTime: Date;
  endTime: Date;
  status: BookingStatus;
  isReviewed: boolean;
  notes: string | null;
  payment: {
    method: PaymentMethod;
    status: PaymentStatus;
    amount: number;
    paidAt: Date | null;
  };
  /** Status log transitions from initial → current status */
  statusLogs: {
    fromStatus: BookingStatus | null;
    toStatus: BookingStatus;
    changedBy: string;
    reason?: string;
    reasonCode?: BookingStatusReasonCode;
  }[];
  /** Present only when isReviewed = true */
  treatmentReview?: {
    rating: number;
    comment: string;
    tags: string[];
    photoUrls: string[];
  };
  specialistReview?: {
    rating: number;
    comment: string;
    tags: string[];
    wouldRecommend: boolean;
  };
}[] = [
  // ── 1. COMPLETED + reviewed ───────────────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-001',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'full-body-massage-60-min',
    startTime: daysAgo(14, 10, 0),
    endTime: daysAgo(14, 11, 10),
    status: BookingStatus.COMPLETED,
    isReviewed: true,
    notes: 'Please use lavender oil',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.PAID,
      amount: 299000,
      paidAt: daysAgo(14, 9, 30),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-002',
      },
    ],
    treatmentReview: {
      rating: 5,
      comment:
        'Absolutely incredible experience! The therapist was highly professional and the atmosphere was so calming. Left feeling completely rejuvenated.',
      tags: ['Professional', 'Relaxing', 'Clean'],
      photoUrls: [],
    },
    specialistReview: {
      rating: 5,
      comment:
        'Sarah is truly exceptional. Her technique is both powerful and precise — I could feel the difference immediately. Highly recommend!',
      tags: ['Skilled', 'Friendly', 'Thorough'],
      wouldRecommend: true,
    },
  },

  // ── 2. COMPLETED + NOT reviewed ───────────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-002',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-001',
    productSlug: 'neck-shoulder-therapy',
    startTime: daysAgo(7, 14, 0),
    endTime: daysAgo(7, 14, 45),
    status: BookingStatus.COMPLETED,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.CASH,
      status: PaymentStatus.PAID,
      amount: 400000,
      paidAt: daysAgo(7, 14, 50),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'staff:EMP-001',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-001',
      },
    ],
  },

  // ── 3. COMPLETED + reviewed (facial) ─────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-003',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'basic-facial-care-package',
    startTime: daysAgo(21, 11, 0),
    endTime: daysAgo(21, 12, 45),
    status: BookingStatus.COMPLETED,
    isReviewed: true,
    notes: null,
    payment: {
      method: PaymentMethod.VNPAY,
      status: PaymentStatus.PAID,
      amount: 450000,
      paidAt: daysAgo(21, 10, 45),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-002',
      },
    ],
    treatmentReview: {
      rating: 4,
      comment:
        'Great facial treatment. My skin felt amazing afterwards. The Korean products used were top quality. Will definitely return!',
      tags: ['Clean', 'Friendly', 'Good Value'],
      photoUrls: [],
    },
    specialistReview: {
      rating: 4,
      comment:
        'Very knowledgeable and gentle. Sarah explained each step clearly and customized the treatment for my skin type.',
      tags: ['Professional', 'Knowledgeable'],
      wouldRecommend: true,
    },
  },

  // ── 4. CONFIRMED (upcoming) ────────────────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-004',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'full-body-massage-60-min',
    startTime: daysFromNow(3, 15, 0),
    endTime: daysFromNow(3, 16, 10),
    status: BookingStatus.CONFIRMED,
    isReviewed: false,
    notes: 'First visit — please advise on suitable pressure level',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.PAID,
      amount: 299000,
      paidAt: daysFromNow(-1, 10, 0),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
    ],
  },

  // ── 5. CONFIRMED (upcoming — dental) ──────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-005',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-001',
    productSlug: 'professional-teeth-whitening',
    startTime: daysFromNow(7, 10, 0),
    endTime: daysFromNow(7, 12, 30),
    status: BookingStatus.CONFIRMED,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.VNPAY,
      status: PaymentStatus.PAID,
      amount: 1200000,
      paidAt: daysFromNow(-2, 9, 0),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
    ],
  },

  // ── 6. CANCELLED ───────────────────────────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-006',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-001',
    productSlug: 'neck-shoulder-therapy',
    startTime: daysAgo(5, 9, 0),
    endTime: daysAgo(5, 9, 45),
    status: BookingStatus.CANCELLED,
    isReviewed: false,
    notes: 'Cannot make it due to work schedule conflict',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.REFUND,
      amount: 400000,
      paidAt: daysAgo(6, 14, 0),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.CANCELLED,
        changedBy: 'user',
      },
    ],
  },

  // ── 7. PENDING_PAYMENT ─────────────────────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-007',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'basic-facial-care-package',
    startTime: daysFromNow(10, 13, 0),
    endTime: daysFromNow(10, 14, 30),
    status: BookingStatus.PENDING_PAYMENT,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.UNPAID,
      amount: 450000,
      paidAt: null,
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
    ],
  },

  // ── 8. COMPLETED + NOT reviewed (older) ────────────────────────────────────
  {
    idempotencyKey: 'SEED-APT-008',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-001',
    productSlug: 'professional-teeth-whitening',
    startTime: daysAgo(45, 10, 0),
    endTime: daysAgo(45, 12, 30),
    status: BookingStatus.COMPLETED,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.CASH,
      status: PaymentStatus.PAID,
      amount: 1200000,
      paidAt: daysAgo(45, 12, 40),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-001',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-009',
    userEmail: 'nguyenvana@healytics.vn',
    staffCode: 'EMP-005',
    productSlug: 'dental-checkup-cleaning',
    startTime: daysAgo(10, 9, 0),
    endTime: daysAgo(10, 10, 0),
    status: BookingStatus.COMPLETED,
    isReviewed: true,
    notes: 'Routine dental cleaning before travel',
    payment: {
      method: PaymentMethod.VNPAY,
      status: PaymentStatus.PAID,
      amount: 590000,
      paidAt: daysAgo(10, 8, 45),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-005',
      },
    ],
    treatmentReview: {
      rating: 5,
      comment:
        'The dental cleaning was careful and clear. Dr. Olivia explained the sensitivity risk before starting.',
      tags: ['Professional', 'Clean', 'Gentle'],
      photoUrls: [],
    },
    specialistReview: {
      rating: 5,
      comment:
        'Very gentle and detailed. I felt comfortable throughout the appointment.',
      tags: ['Gentle', 'Detailed'],
      wouldRecommend: true,
    },
  },
  {
    idempotencyKey: 'SEED-APT-010',
    userEmail: 'tranthib@healytics.vn',
    staffCode: 'EMP-007',
    productSlug: 'sports-recovery-yoga-session',
    startTime: daysFromNow(4, 10, 0),
    endTime: daysFromNow(4, 11, 15),
    status: BookingStatus.CONFIRMED,
    isReviewed: false,
    notes: 'Needs hip mobility work after marathon training',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.PAID,
      amount: 180000,
      paidAt: daysAgo(1, 12, 0),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-011',
    userEmail: 'levanc@healytics.vn',
    staffCode: 'EMP-009',
    productSlug: 'nutrition-consultation-meal-plan',
    startTime: daysAgo(12, 13, 0),
    endTime: daysAgo(12, 14, 0),
    status: BookingStatus.COMPLETED,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.STRIPE,
      status: PaymentStatus.PAID,
      amount: 650000,
      paidAt: daysAgo(12, 12, 45),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-009',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-012',
    userEmail: 'phamthid@healytics.vn',
    staffCode: 'EMP-010',
    productSlug: 'herbal-acupuncture-therapy',
    startTime: daysAgo(18, 15, 0),
    endTime: daysAgo(18, 16, 15),
    status: BookingStatus.COMPLETED,
    isReviewed: true,
    notes: 'Prefers morning acupuncture appointment',
    payment: {
      method: PaymentMethod.CASH,
      status: PaymentStatus.PAID,
      amount: 520000,
      paidAt: daysAgo(18, 16, 20),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'staff:EMP-010',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-010',
      },
    ],
    treatmentReview: {
      rating: 5,
      comment:
        'The acupuncture session was calm and effective. The aftercare guidance was easy to follow.',
      tags: ['Calm', 'Effective', 'Clear Advice'],
      photoUrls: [],
    },
    specialistReview: {
      rating: 5,
      comment:
        'Dr. Mai asked detailed questions and adjusted the treatment to my shoulder tension.',
      tags: ['Experienced', 'Thoughtful'],
      wouldRecommend: true,
    },
  },
  {
    idempotencyKey: 'SEED-APT-013',
    userEmail: 'hoangvane@healytics.vn',
    staffCode: 'EMP-012',
    productSlug: 'dermatology-acne-consultation',
    startTime: daysFromNow(6, 11, 0),
    endTime: daysFromNow(6, 11, 45),
    status: BookingStatus.PENDING_PAYMENT,
    isReviewed: false,
    notes: null,
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.UNPAID,
      amount: 750000,
      paidAt: null,
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-014',
    userEmail: 'vuthif@healytics.vn',
    staffCode: 'EMP-013',
    productSlug: 'stress-anxiety-counseling',
    startTime: daysFromNow(5, 16, 0),
    endTime: daysFromNow(5, 17, 0),
    status: BookingStatus.CONFIRMED,
    isReviewed: false,
    notes: 'Requests quiet room for first counseling session',
    payment: {
      method: PaymentMethod.STRIPE,
      status: PaymentStatus.PAID,
      amount: 900000,
      paidAt: daysAgo(2, 16, 10),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-015',
    userEmail: 'dangvang@healytics.vn',
    staffCode: 'EMP-011',
    productSlug: 'herbal-acupuncture-therapy',
    startTime: daysAgo(3, 10, 0),
    endTime: daysAgo(3, 11, 15),
    status: BookingStatus.NO_SHOW,
    isReviewed: false,
    notes: 'Missed due to traffic, wants to rebook',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.DEPOSITED,
      amount: 200000,
      paidAt: daysAgo(4, 9, 15),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.NO_SHOW,
        changedBy: 'staff:EMP-011',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-016',
    userEmail: 'buithih@healytics.vn',
    staffCode: 'EMP-006',
    productSlug: 'professional-teeth-whitening',
    startTime: daysAgo(9, 14, 0),
    endTime: daysAgo(9, 16, 0),
    status: BookingStatus.CANCELLED,
    isReviewed: false,
    notes: 'Sensitive teeth, cancelled after rescheduling',
    payment: {
      method: PaymentMethod.VNPAY,
      status: PaymentStatus.REFUND,
      amount: 1200000,
      paidAt: daysAgo(10, 10, 0),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.CANCELLED,
        changedBy: 'user',
      },
    ],
  },
  {
    idempotencyKey: 'SEED-APT-017',
    userEmail: 'nguyenminh@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'full-body-massage-60-min',
    startTime: daysAgo(30, 10, 0),
    endTime: daysAgo(30, 11, 10),
    status: BookingStatus.COMPLETED,
    isReviewed: true,
    notes: 'Second massage visit with medium pressure',
    payment: {
      method: PaymentMethod.MOMO,
      status: PaymentStatus.PAID,
      amount: 299000,
      paidAt: daysAgo(30, 9, 40),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.CONFIRMED,
        toStatus: BookingStatus.COMPLETED,
        changedBy: 'staff:EMP-002',
      },
    ],
    treatmentReview: {
      rating: 4,
      comment:
        'Great second visit. The medium pressure was right and the room was very clean.',
      tags: ['Clean', 'Relaxing'],
      photoUrls: [],
    },
    specialistReview: {
      rating: 4,
      comment: 'Sarah remembered my preferences and checked pressure often.',
      tags: ['Attentive', 'Friendly'],
      wouldRecommend: true,
    },
  },
  {
    idempotencyKey: 'SEED-APT-018',
    userEmail: 'lehoanglinh@healytics.vn',
    staffCode: 'EMP-009',
    productSlug: 'nutrition-consultation-meal-plan',
    startTime: daysFromNow(8, 9, 0),
    endTime: daysFromNow(8, 10, 0),
    status: BookingStatus.CONFIRMED,
    isReviewed: false,
    notes: 'Follow-up nutrition plan review',
    payment: {
      method: PaymentMethod.STRIPE,
      status: PaymentStatus.DEPOSITED,
      amount: 300000,
      paidAt: daysAgo(1, 8, 30),
    },
    statusLogs: [
      {
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
      },
      {
        fromStatus: BookingStatus.PENDING_PAYMENT,
        toStatus: BookingStatus.CONFIRMED,
        changedBy: 'system',
      },
    ],
  },
];

// ─────────────────────────────────────────────────────────────────────────────

@Injectable()
export class AppointmentSeeder implements ISeeder {
  private readonly logger = new Logger(AppointmentSeeder.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,

    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,

    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,

    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,

    @InjectRepository(BookingStatusLog)
    private readonly statusLogRepo: Repository<BookingStatusLog>,

    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,

    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepo: Repository<TreatmentReview>,

    @InjectRepository(SpecialistReview)
    private readonly specialistReviewRepo: Repository<SpecialistReview>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding appointments...');

    // ── Pre-load lookup maps ──────────────────────────────────────────────────
    const userEmails = [
      ...new Set(SEED_APPOINTMENTS.map((apt) => apt.userEmail)),
    ];
    const userAccounts = await this.accountRepo.find({
      where: { email: In(userEmails), role: Role.USER },
      select: ['id', 'email'],
    });
    const userMap = new Map(
      userAccounts.map((account) => [account.email, account]),
    );

    if (!userMap.size) {
      this.logger.warn(
        '  ⚠ Seed users not found — skipping appointment seeding. Run UserSeeder first.',
      );
      return;
    }

    const employees = await this.employeeRepo.find();
    const employeeMap = new Map(employees.map((e) => [e.employeeCode, e]));

    const products = await this.productRepo.find();
    const productMap = new Map(products.map((p) => [p.slug, p]));

    // ── Seed each appointment ─────────────────────────────────────────────────
    for (const apt of SEED_APPOINTMENTS) {
      // Use notes + startTime as a logical idempotency check via idempotencyKey
      // We store idempotencyKey in the `notes` field is NOT correct — instead
      // we query bookings by userId + staffId + startTime (composite unique index)
      const userAccount = userMap.get(apt.userEmail);
      if (!userAccount) {
        this.logger.warn(
          `  ⚠ User "${apt.userEmail}" not found — skipping ${apt.idempotencyKey}`,
        );
        continue;
      }

      const employee = employeeMap.get(apt.staffCode);
      if (!employee) {
        this.logger.warn(
          `  ⚠ Employee "${apt.staffCode}" not found — skipping ${apt.idempotencyKey}`,
        );
        continue;
      }

      const product = apt.productSlug ? productMap.get(apt.productSlug) : null;
      if (apt.productSlug && !product) {
        this.logger.warn(
          `  ⚠ Product "${apt.productSlug}" not found — skipping ${apt.idempotencyKey}`,
        );
        continue;
      }

      const existing = await this.findExistingSeedBooking(
        apt,
        userAccount.id,
        employee.id,
        product?.id ?? null,
      );

      if (existing) {
        await this.markSeedBooking(existing.id, apt.idempotencyKey);
        this.logger.log(
          `  ⏭ Booking ${apt.idempotencyKey} already exists, skipping`,
        );
        continue;
      }

      // 1. Create Booking
      const booking = this.bookingRepo.create({
        userId: userAccount.id,
        staffId: employee.id,
        productId: product?.id ?? null,
        startTime: apt.startTime,
        endTime: apt.endTime,
        status: apt.status,
        isReviewed: apt.isReviewed,
        notes: apt.notes,
        paymentUrl: null,
        paymentDeeplink: null,
        paymentExpiresAt: null,
      });

      await this.bookingRepo.save(booking);
      this.logger.log(
        `  ✅ Created booking ${apt.idempotencyKey} (${apt.status}) → staff: ${apt.staffCode}, product: ${apt.productSlug ?? 'none'}`,
      );

      // 2. Booking Status Logs (audit trail)
      for (const log of apt.statusLogs) {
        const reasonCode =
          log.reasonCode ??
          this.inferSeedReasonCode(log.fromStatus, log.toStatus);
        const statusLog = this.statusLogRepo.create({
          bookingId: booking.id,
          fromStatus: log.fromStatus,
          toStatus: log.toStatus,
          changedBy: log.changedBy,
          reasonCode,
          reason: this.buildSeedStatusLogReason(
            apt.idempotencyKey,
            log.reason ?? this.defaultSeedReason(log.fromStatus, log.toStatus),
          ),
        });
        await this.statusLogRepo.save(statusLog);
      }
      this.logger.log(`    📋 Added ${apt.statusLogs.length} status log(s)`);

      // 3. Payment record
      const payment = this.paymentRepo.create({
        bookingId: booking.id,
        userId: userAccount.id,
        paymentMethod: apt.payment.method,
        paymentStatus: apt.payment.status,
        amount: apt.payment.amount,
        paidAt: apt.payment.paidAt,
        gatewayOrderId: null,
        gatewayTransId: null,
        paymentUrl: null,
        paymentDeeplink: null,
        gatewayResultCode: apt.payment.status === PaymentStatus.PAID ? 0 : null,
        gatewayMessage:
          apt.payment.status === PaymentStatus.PAID ? 'Success' : null,
        refundedAt:
          apt.payment.status === PaymentStatus.REFUND
            ? apt.payment.paidAt
            : null,
      });
      await this.paymentRepo.save(payment);
      this.logger.log(
        `    💳 Payment ${apt.payment.method} → ${apt.payment.status} (${apt.payment.amount.toLocaleString('vi-VN')} VND)`,
      );

      // 4. TreatmentReview (only when isReviewed + reviewData present)
      if (apt.isReviewed && apt.treatmentReview && product) {
        const treatmentReview = this.treatmentReviewRepo.create({
          appointmentId: booking.id,
          userId: userAccount.id,
          rating: apt.treatmentReview.rating,
          comment: apt.treatmentReview.comment,
          tags: apt.treatmentReview.tags,
          photoUrls: apt.treatmentReview.photoUrls,
        });
        await this.treatmentReviewRepo.save(treatmentReview);
        this.logger.log(
          `    ⭐ Treatment review: ${apt.treatmentReview.rating}/5 — "${apt.treatmentReview.comment.substring(0, 40)}..."`,
        );
      }

      // 5. SpecialistReview (only when isReviewed + reviewData present)
      if (apt.isReviewed && apt.specialistReview) {
        const specialistReview = this.specialistReviewRepo.create({
          appointmentId: booking.id,
          specialistId: employee.id,
          userId: userAccount.id,
          rating: apt.specialistReview.rating,
          comment: apt.specialistReview.comment,
          tags: apt.specialistReview.tags,
          wouldRecommend: apt.specialistReview.wouldRecommend,
        });
        await this.specialistReviewRepo.save(specialistReview);
        this.logger.log(
          `    👨‍⚕️ Specialist review: ${apt.specialistReview.rating}/5 (wouldRecommend=${apt.specialistReview.wouldRecommend})`,
        );
      }
    }

    await this.refreshEmployeeReviewAggregates();
    this.logger.log('Appointments seeding completed');
  }

  async clear(): Promise<void> {
    this.logger.log('Clearing seed appointment data...');

    // We identify seed bookings by the user + known staff codes + product slugs
    // Strategy: find all bookings where userId = testUser + staffId in seedEmployee IDs
    const userAccounts = await this.accountRepo.find({
      where: {
        email: In([...new Set(SEED_APPOINTMENTS.map((a) => a.userEmail))]),
        role: Role.USER,
      },
      select: ['id'],
    });

    if (!userAccounts.length) {
      this.logger.warn('  ⚠ Seed users not found — nothing to clear');
      return;
    }
    const userIds = userAccounts.map((account) => account.id);

    const seedStaffCodes = [
      ...new Set(SEED_APPOINTMENTS.map((a) => a.staffCode)),
    ];
    const employees = await this.employeeRepo.find({
      where: { employeeCode: In(seedStaffCodes) },
    });
    const staffIds = employees.map((e) => e.id);

    if (!staffIds.length) {
      this.logger.warn('  ⚠ No seed employees found — nothing to clear');
      return;
    }

    const seedBookings = await this.bookingRepo.find({
      where: { userId: In(userIds), staffId: In(staffIds) },
      select: ['id'],
      withDeleted: true,
    });

    if (!seedBookings.length) {
      this.logger.warn('  ⚠ No seed bookings found to delete');
      return;
    }

    const bookingIds = seedBookings.map((b) => b.id);

    // Delete in FK-safe order: reviews → payments → status logs → bookings
    // Note: TypeORM cascade handles logs/payments if defined, but we delete explicitly
    // to avoid partial failures and log each step.

    const { affected: trCount } = await this.treatmentReviewRepo.delete({
      appointmentId: In(bookingIds),
    });
    if (trCount) this.logger.log(`🗑️ Deleted ${trCount} treatment review(s)`);

    const { affected: srCount } = await this.specialistReviewRepo.delete({
      appointmentId: In(bookingIds),
    });
    if (srCount) this.logger.log(`🗑️ Deleted ${srCount} specialist review(s)`);

    const { affected: payCount } = await this.paymentRepo.delete({
      bookingId: In(bookingIds),
    });
    if (payCount) this.logger.log(`🗑️ Deleted ${payCount} payment(s)`);

    const { affected: logCount } = await this.statusLogRepo.delete({
      bookingId: In(bookingIds),
    });
    if (logCount) this.logger.log(`🗑️ Deleted ${logCount} status log(s)`);

    const { affected: bookingCount } = await this.bookingRepo.delete({
      id: In(bookingIds),
    });
    this.logger.log(`🗑️ Hard-deleted ${bookingCount ?? 0} seed booking(s)`);

    await this.refreshEmployeeReviewAggregates(staffIds);
  }

  private async refreshEmployeeReviewAggregates(
    staffIds?: string[],
  ): Promise<void> {
    const params = staffIds?.length ? [staffIds] : [];
    const scope = staffIds?.length ? 'WHERE e.id = ANY($1::uuid[])' : '';
    const reviewScope = staffIds?.length
      ? 'WHERE sr.specialist_id = ANY($1::uuid[])'
      : '';

    await this.employeeRepo.query(
      `
      WITH review_aggregates AS (
        SELECT
          sr.specialist_id,
          ROUND(AVG(sr.rating)::numeric, 2) AS rating,
          COUNT(sr.id)::int AS review_count
        FROM specialist_reviews sr
        ${reviewScope}
        GROUP BY sr.specialist_id
      ),
      scoped_employees AS (
        SELECT e.id
        FROM employees e
        ${scope}
      ),
      updated_reviewed_employees AS (
        UPDATE employees e
        SET
          rating = ra.rating,
          review_count = ra.review_count,
          updated_at = NOW()
        FROM review_aggregates ra
        WHERE e.id = ra.specialist_id
          AND (
            e.rating IS DISTINCT FROM ra.rating
            OR e.review_count IS DISTINCT FROM ra.review_count
          )
        RETURNING e.id
      )
      UPDATE employees e
      SET
        rating = 0,
        review_count = 0,
        updated_at = NOW()
      FROM scoped_employees se
      WHERE e.id = se.id
        AND NOT EXISTS (
          SELECT 1
          FROM specialist_reviews sr
          WHERE sr.specialist_id = e.id
        )
        AND (
          e.rating IS DISTINCT FROM 0
          OR e.review_count IS DISTINCT FROM 0
        )
      `,
      params,
    );
  }

  private async findExistingSeedBooking(
    apt: (typeof SEED_APPOINTMENTS)[number],
    userId: string,
    staffId: string,
    productId: string | null,
  ): Promise<Booking | null> {
    const marker = seedAppointmentMarker(apt.idempotencyKey);
    const markedBooking = await this.bookingRepo
      .createQueryBuilder('booking')
      .innerJoin(
        BookingStatusLog,
        'statusLog',
        'statusLog.booking_id = booking.id',
      )
      .where(
        '(statusLog.reason = :marker OR statusLog.reason LIKE :markerPrefix)',
        {
          marker,
          markerPrefix: `${marker} - %`,
        },
      )
      .getOne();

    if (markedBooking) {
      return markedBooking;
    }

    let query = this.bookingRepo
      .createQueryBuilder('booking')
      .where('booking.user_id = :userId', { userId })
      .andWhere('booking.staff_id = :staffId', { staffId })
      .andWhere('booking.status = :status', { status: apt.status });

    query = productId
      ? query.andWhere('booking.product_id = :productId', { productId })
      : query.andWhere('booking.product_id IS NULL');

    query =
      apt.notes === null
        ? query.andWhere('booking.notes IS NULL')
        : query.andWhere('booking.notes = :notes', { notes: apt.notes });

    const candidates = await query
      .orderBy('booking.created_at', 'ASC')
      .getMany();
    if (candidates.length > 1) {
      this.logger.warn(
        `  ⚠ Found ${candidates.length} existing logical booking rows for ${apt.idempotencyKey}; keeping the oldest and skipping new insert`,
      );
    }

    return candidates[0] ?? null;
  }

  private async markSeedBooking(
    bookingId: string,
    idempotencyKey: string,
  ): Promise<void> {
    await this.statusLogRepo.update(
      { bookingId },
      {
        reason: this.buildSeedStatusLogReason(
          idempotencyKey,
          'Existing seed booking marker',
        ),
        reasonCode: BookingStatusReasonCode.LEGACY_STATUS_CHANGE,
      },
    );
  }

  private buildSeedStatusLogReason(
    idempotencyKey: string,
    reason: string,
  ): string {
    return `${seedAppointmentMarker(idempotencyKey)} - ${reason}`;
  }

  private inferSeedReasonCode(
    fromStatus: BookingStatus | null,
    toStatus: BookingStatus,
  ): BookingStatusReasonCode {
    if (fromStatus === null && toStatus === BookingStatus.PENDING_PAYMENT) {
      return BookingStatusReasonCode.CHECKOUT_CREATED_PENDING_PAYMENT;
    }
    if (
      fromStatus === BookingStatus.PENDING_PAYMENT &&
      toStatus === BookingStatus.CONFIRMED
    ) {
      return BookingStatusReasonCode.LEGACY_STATUS_CHANGE;
    }
    if (
      fromStatus === BookingStatus.CONFIRMED &&
      toStatus === BookingStatus.COMPLETED
    ) {
      return BookingStatusReasonCode.EMPLOYEE_COMPLETED_SERVICE;
    }
    if (toStatus === BookingStatus.CANCELLED) {
      return BookingStatusReasonCode.LEGACY_STATUS_CHANGE;
    }
    return BookingStatusReasonCode.LEGACY_STATUS_CHANGE;
  }

  private defaultSeedReason(
    fromStatus: BookingStatus | null,
    toStatus: BookingStatus,
  ): string {
    return `Seed booking status change from ${fromStatus ?? 'none'} to ${toStatus}`;
  }
}
