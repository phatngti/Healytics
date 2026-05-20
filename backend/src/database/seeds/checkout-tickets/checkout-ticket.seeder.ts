import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { Booking } from '@/common/entities/booking.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

type SeedTicketStatus = keyof typeof CheckoutTicketStatus;

interface SeedTicket {
  code: string;
  userEmail: string;
  staffCode: string;
  productSlug: string | null;
  status: SeedTicketStatus;
  offsetMinutes: number;
  errorMessage?: string | null;
}

const SEED_TICKETS: SeedTicket[] = [
  {
    code: 'QUEUED_001',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-001',
    productSlug: 'full-body-massage-60-min',
    status: 'QUEUED',
    offsetMinutes: 120,
  },
  {
    code: 'PROCESSING_001',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'neck-shoulder-therapy',
    status: 'PROCESSING',
    offsetMinutes: 180,
  },
  {
    code: 'FAILED_001',
    userEmail: 'user@healytics.vn',
    staffCode: 'EMP-002',
    productSlug: 'basic-facial-care-package',
    status: 'FAILED',
    offsetMinutes: 240,
    errorMessage: 'Slot is no longer available.',
  },
  {
    code: 'QUEUED_002',
    userEmail: 'nguyenvana@healytics.vn',
    staffCode: 'EMP-005',
    productSlug: 'dental-checkup-cleaning',
    status: 'QUEUED',
    offsetMinutes: 300,
  },
  {
    code: 'PROCESSING_002',
    userEmail: 'tranthib@healytics.vn',
    staffCode: 'EMP-007',
    productSlug: 'sports-recovery-yoga-session',
    status: 'PROCESSING',
    offsetMinutes: 360,
  },
  {
    code: 'FAILED_002',
    userEmail: 'hoangvane@healytics.vn',
    staffCode: 'EMP-012',
    productSlug: 'dermatology-acne-consultation',
    status: 'FAILED',
    offsetMinutes: 420,
    errorMessage: 'Payment authorization expired before checkout.',
  },
];

@Injectable()
export class CheckoutTicketSeeder implements ISeeder {
  private readonly logger = new Logger(CheckoutTicketSeeder.name);

  constructor(
    @InjectRepository(CheckoutTicket)
    private readonly ticketRepo: Repository<CheckoutTicket>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding checkout tickets...');

    const [accounts, employees, products] = await Promise.all([
      this.accountRepo.find({
        where: {
          email: In([...new Set(SEED_TICKETS.map((item) => item.userEmail))]),
        },
        select: ['id', 'email'],
      }),
      this.employeeRepo.find({
        where: {
          employeeCode: In([
            ...new Set(SEED_TICKETS.map((item) => item.staffCode)),
          ]),
        },
        select: ['id', 'employeeCode'],
      }),
      this.productRepo.find({
        where: {
          slug: In(
            SEED_TICKETS.map((item) => item.productSlug).filter(
              (slug): slug is string => slug !== null,
            ),
          ),
        },
        select: ['id', 'slug'],
      }),
    ]);

    const accountMap = buildMapBy(accounts, (item) => item.email);
    const employeeMap = buildMapBy(employees, (item) => item.employeeCode);
    const productMap = buildMapBy(products, (item) => item.slug);

    await this.seedSuccessTicket();

    for (const seed of SEED_TICKETS) {
      const idempotencyKey = seedKey(SEED_MARKERS.checkoutKey, seed.code);
      const existing = await this.ticketRepo.findOne({
        where: { idempotencyKey },
      });
      if (existing) {
        this.logger.log(
          `  ⏭ Checkout ticket "${idempotencyKey}" already exists, skipping`,
        );
        continue;
      }

      const user = accountMap.get(seed.userEmail);
      const staff = employeeMap.get(seed.staffCode);
      const product = seed.productSlug
        ? productMap.get(seed.productSlug)
        : null;

      if (!user || !staff) {
        this.logger.warn(`  ⚠ Missing FK for ticket "${seed.code}" — skipping`);
        continue;
      }
      if (seed.productSlug && !product) {
        this.logger.warn(
          `  ⚠ Product "${seed.productSlug}" not found — skipping`,
        );
        continue;
      }

      const startTime = new Date();
      startTime.setMinutes(startTime.getMinutes() + seed.offsetMinutes);
      startTime.setSeconds(0, 0);

      await this.ticketRepo.save(
        this.ticketRepo.create({
          userId: user.id,
          staffId: staff.id,
          productId: product?.id ?? null,
          startTime,
          idempotencyKey,
          status: CheckoutTicketStatus[seed.status],
          webhookUrl: 'https://seed.healytics.vn/webhooks/checkout',
          bookingId: null,
          errorMessage: seed.errorMessage ?? null,
        }),
      );

      this.logger.log(`  ✅ Created checkout ticket "${idempotencyKey}"`);
    }

    this.logger.log('Checkout ticket seeding completed');
  }

  private async seedSuccessTicket(): Promise<void> {
    const successKey = seedKey(SEED_MARKERS.checkoutKey, 'SUCCESS_001');
    const existing = await this.ticketRepo.findOne({
      where: { idempotencyKey: successKey },
    });
    if (existing) {
      this.logger.log(
        `  ⏭ Checkout ticket "${successKey}" already exists, skipping`,
      );
      return;
    }

    const booking = await this.bookingRepo.findOne({
      where: { notes: 'Please use lavender oil' },
      select: ['id', 'userId', 'staffId', 'productId', 'startTime'],
    });

    if (!booking?.productId) {
      this.logger.warn(
        '  ⚠ Seed booking for SUCCESS checkout ticket not found — skipping SUCCESS ticket',
      );
      return;
    }

    await this.ticketRepo.save(
      this.ticketRepo.create({
        userId: booking.userId,
        staffId: booking.staffId,
        productId: booking.productId,
        startTime: booking.startTime,
        idempotencyKey: successKey,
        status: CheckoutTicketStatus.SUCCESS,
        webhookUrl: 'https://seed.healytics.vn/webhooks/checkout',
        bookingId: booking.id,
        errorMessage: null,
      }),
    );
    this.logger.log(`  ✅ Created checkout ticket "${successKey}"`);
  }

  async clear(): Promise<void> {
    const { affected } = await this.ticketRepo.delete({
      idempotencyKey: Like(likePrefix(SEED_MARKERS.checkoutKey)),
    });

    if (!affected) {
      this.logger.warn('⚠ No seed checkout tickets found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${affected} seed checkout ticket(s)`);
  }
}
