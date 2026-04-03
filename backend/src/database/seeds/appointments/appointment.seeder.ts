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
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { Role } from '@/account/enum/role.enum';
import { ISeeder } from '../seeder.interface';

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
    const userAccount = await this.accountRepo.findOne({
      where: { email: 'user@healytics.vn', role: Role.USER },
    });

    if (!userAccount) {
      this.logger.warn(
        '  ⚠ Test user "user@healytics.vn" not found — skipping appointment seeding. Run UserSeeder first.',
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

      // Idempotency: check if a booking already exists at this staff + startTime
      const existing = await this.bookingRepo.findOne({
        where: { staffId: employee.id, startTime: apt.startTime },
      });

      if (existing) {
        this.logger.log(
          `  ⏭ Booking ${apt.idempotencyKey} already exists (staffId=${employee.id}, startTime=${apt.startTime.toISOString()}), skipping`,
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
        const statusLog = this.statusLogRepo.create({
          bookingId: booking.id,
          fromStatus: log.fromStatus,
          toStatus: log.toStatus,
          changedBy: log.changedBy,
          reason: null,
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

    this.logger.log('Appointments seeding completed');
  }

  async clear(): Promise<void> {
    this.logger.log('Clearing seed appointment data...');

    // We identify seed bookings by the user + known staff codes + product slugs
    // Strategy: find all bookings where userId = testUser + staffId in seedEmployee IDs
    const userAccount = await this.accountRepo.findOne({
      where: { email: 'user@healytics.vn', role: Role.USER },
    });

    if (!userAccount) {
      this.logger.warn('  ⚠ Test user not found — nothing to clear');
      return;
    }

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
      where: { userId: userAccount.id, staffId: In(staffIds) },
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
  }
}
