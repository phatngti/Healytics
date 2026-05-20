import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Category } from '@/common/entities/category.entity';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Coupon } from '@/cart/entities/coupon.entity';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

interface SeedCartItem {
  userEmail: string;
  serviceSlug: string;
  /** Must be an employee email that is eligible for the service. */
  employeeEmail: string;
  /** Time slot in ISO 8601 format. */
  timeSlot: string;
}

interface SeedCoupon {
  code: string;
  discountPercent: number;
  maxDiscountAmount: number | null;
  usageLimit: number | null;
  usedCount: number;
  isActive: boolean;
  expiresInDays: number | null;
  serviceSlug?: string;
  categorySlug?: string;
}

const SEED_CART_ITEMS: SeedCartItem[] = [
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'full-body-massage-60-min',
    employeeEmail: 'therapist.mitchell@healytics.vn', // EMP-002 (primary)
    timeSlot: '2026-04-10T09:00:00.000Z',
  },
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'neck-shoulder-therapy',
    employeeEmail: 'doctor.anderson@healytics.vn', // EMP-001 (primary)
    timeSlot: '2026-04-10T10:00:00.000Z',
  },
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'basic-facial-care-package',
    employeeEmail: 'therapist.mitchell@healytics.vn', // EMP-002 (primary)
    timeSlot: '2026-04-11T09:00:00.000Z',
  },
  {
    userEmail: 'nguyenvana@healytics.vn',
    serviceSlug: 'dental-checkup-cleaning',
    employeeEmail: 'dentist.tran@healytics.vn', // EMP-005 (primary)
    timeSlot: '2026-05-08T02:00:00.000Z',
  },
  {
    userEmail: 'tranthib@healytics.vn',
    serviceSlug: 'sports-recovery-yoga-session',
    employeeEmail: 'coach.le@healytics.vn', // EMP-007 (primary)
    timeSlot: '2026-05-08T03:30:00.000Z',
  },
  {
    userEmail: 'levanc@healytics.vn',
    serviceSlug: 'nutrition-consultation-meal-plan',
    employeeEmail: 'nutrition.pham@healytics.vn', // EMP-009 (primary)
    timeSlot: '2026-05-09T06:00:00.000Z',
  },
  {
    userEmail: 'phamthid@healytics.vn',
    serviceSlug: 'herbal-acupuncture-therapy',
    employeeEmail: 'acupuncture.tran@healytics.vn', // EMP-011
    timeSlot: '2026-05-10T03:00:00.000Z',
  },
  {
    userEmail: 'hoangvane@healytics.vn',
    serviceSlug: 'dermatology-acne-consultation',
    employeeEmail: 'dermatology.huynh@healytics.vn', // EMP-012 (primary)
    timeSlot: '2026-05-11T04:00:00.000Z',
  },
  {
    userEmail: 'vuthif@healytics.vn',
    serviceSlug: 'stress-anxiety-counseling',
    employeeEmail: 'psychology.do@healytics.vn', // EMP-013 (primary)
    timeSlot: '2026-05-12T09:00:00.000Z',
  },
];

const SEED_COUPONS: SeedCoupon[] = [
  {
    code: 'MASSAGE10',
    discountPercent: 10,
    maxDiscountAmount: 60000,
    usageLimit: 200,
    usedCount: 18,
    isActive: true,
    expiresInDays: 30,
    serviceSlug: 'full-body-massage-60-min',
  },
  {
    code: 'DENTAL15',
    discountPercent: 15,
    maxDiscountAmount: 150000,
    usageLimit: 120,
    usedCount: 9,
    isActive: true,
    expiresInDays: 45,
    serviceSlug: 'dental-checkup-cleaning',
  },
  {
    code: 'RELAX20',
    discountPercent: 20,
    maxDiscountAmount: 120000,
    usageLimit: 80,
    usedCount: 21,
    isActive: true,
    expiresInDays: 21,
    categorySlug: 'relaxation-massage',
  },
  {
    code: 'NUTRI12',
    discountPercent: 12,
    maxDiscountAmount: 100000,
    usageLimit: 60,
    usedCount: 4,
    isActive: true,
    expiresInDays: 60,
    categorySlug: 'nutrition-counseling',
  },
  {
    code: 'MINDFUL8',
    discountPercent: 8,
    maxDiscountAmount: 90000,
    usageLimit: 50,
    usedCount: 2,
    isActive: true,
    expiresInDays: 35,
    serviceSlug: 'stress-anxiety-counseling',
  },
];

@Injectable()
export class CartSeeder implements ISeeder {
  private readonly logger = new Logger(CartSeeder.name);

  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepo: Repository<CartItem>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Employee)
    private readonly employeeRepo: Repository<Employee>,
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
    @InjectRepository(Coupon)
    private readonly couponRepo: Repository<Coupon>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding cart data...');

    const [accounts, products, employees] = await Promise.all([
      this.accountRepo.find({
        where: {
          email: In([
            ...new Set(SEED_CART_ITEMS.map((item) => item.userEmail)),
          ]),
        },
        select: ['id', 'email'],
        loadEagerRelations: false,
      }),
      this.productRepo.find({
        where: {
          slug: In([
            ...new Set(SEED_CART_ITEMS.map((item) => item.serviceSlug)),
          ]),
        },
        select: ['id', 'slug'],
      }),
      this.employeeRepo.find({
        where: {
          email: In([
            ...new Set(SEED_CART_ITEMS.map((item) => item.employeeEmail)),
          ]),
        },
        select: ['id', 'email'],
      }),
    ]);

    const accountMap = buildMapBy(accounts, (item) => item.email);
    const productMap = buildMapBy(products, (item) => item.slug);
    const employeeMap = buildMapBy(employees, (item) => item.email);

    await this.seedCartItems(accountMap, productMap, employeeMap);
    await this.seedCoupons();

    this.logger.log('Cart seeding completed');
  }

  private async seedCartItems(
    accountMap: Map<string, Account>,
    productMap: Map<string, Product>,
    employeeMap: Map<string, Employee>,
  ): Promise<void> {
    for (const seed of SEED_CART_ITEMS) {
      const user = accountMap.get(seed.userEmail);
      const service = productMap.get(seed.serviceSlug);
      const employee = employeeMap.get(seed.employeeEmail);

      if (!user || !service || !employee) {
        this.logger.warn(
          `  ⚠ Missing FK for cart item "${seed.serviceSlug}" — skipping`,
        );
        continue;
      }

      const timeSlot = new Date(seed.timeSlot);

      const existing = await this.cartItemRepo.findOne({
        where: {
          userId: user.id,
          serviceId: service.id,
          employeeId: employee.id,
          timeSlot,
        },
      });

      if (!existing) {
        await this.cartItemRepo.save(
          this.cartItemRepo.create({
            userId: user.id,
            serviceId: service.id,
            employeeId: employee.id,
            timeSlot,
            status: CartItemStatus.ACTIVE,
          }),
        );
        this.logger.log(`  ✅ Created cart item "${seed.serviceSlug}"`);
        continue;
      }

      this.logger.log(`  🔄 Cart item "${seed.serviceSlug}" already exists`);
    }
  }

  private async seedCoupons(): Promise<void> {
    const [products, categories] = await Promise.all([
      this.productRepo.find({
        where: {
          slug: In(
            SEED_COUPONS.map((item) => item.serviceSlug).filter(
              (slug): slug is string => Boolean(slug),
            ),
          ),
        },
        select: ['id', 'slug'],
      }),
      this.categoryRepo.find({
        where: {
          slug: In(
            SEED_COUPONS.map((item) => item.categorySlug).filter(
              (slug): slug is string => Boolean(slug),
            ),
          ),
        },
        select: ['id', 'slug'],
      }),
    ]);

    const productMap = buildMapBy(products, (item) => item.slug);
    const categoryMap = buildMapBy(categories, (item) => item.slug);

    for (const seed of SEED_COUPONS) {
      const code = seedKey(SEED_MARKERS.couponCode, seed.code);
      const service = seed.serviceSlug
        ? productMap.get(seed.serviceSlug)
        : null;
      const category = seed.categorySlug
        ? categoryMap.get(seed.categorySlug)
        : null;

      if (seed.serviceSlug && !service) {
        this.logger.warn(
          `  ⚠ Service "${seed.serviceSlug}" not found — skipping coupon`,
        );
        continue;
      }
      if (seed.categorySlug && !category) {
        this.logger.warn(
          `  ⚠ Category "${seed.categorySlug}" not found — skipping coupon`,
        );
        continue;
      }

      const expiresAt = seed.expiresInDays
        ? new Date(Date.now() + seed.expiresInDays * 24 * 60 * 60 * 1000)
        : null;
      const payload = {
        code,
        discountPercent: seed.discountPercent,
        maxDiscountAmount: seed.maxDiscountAmount,
        usageLimit: seed.usageLimit,
        usedCount: seed.usedCount,
        isActive: seed.isActive,
        expiresAt,
        serviceId: service?.id ?? null,
        categoryId: category?.id ?? null,
      };
      const existing = await this.couponRepo.findOne({ where: { code } });

      if (existing) {
        await this.couponRepo.save({ ...existing, ...payload });
        this.logger.log(`  🔄 Updated coupon "${code}"`);
        continue;
      }

      await this.couponRepo.save(this.couponRepo.create(payload));
      this.logger.log(`  ✅ Created coupon "${code}"`);
    }
  }

  async clear(): Promise<void> {
    const productSlugs = SEED_CART_ITEMS.map((item) => item.serviceSlug);
    const [users, products] = await Promise.all([
      this.accountRepo.find({
        where: {
          email: In([
            ...new Set(SEED_CART_ITEMS.map((item) => item.userEmail)),
          ]),
        },
        select: ['id'],
        loadEagerRelations: false,
      }),
      this.productRepo.find({
        where: { slug: In(productSlugs) },
        select: ['id'],
      }),
    ]);

    const userIds = users.map((item) => item.id);
    const productIds = products.map((item) => item.id);

    if (userIds.length && productIds.length) {
      const { affected: cartAffected } = await this.cartItemRepo
        .createQueryBuilder()
        .delete()
        .from(CartItem)
        .where('user_id IN (:...userIds)', { userIds })
        .andWhere('service_id IN (:...productIds)', { productIds })
        .execute();

      if (cartAffected) {
        this.logger.log(`🗑️ Hard-deleted ${cartAffected} seed cart item(s)`);
      }
    }

    const { affected: couponAffected } = await this.couponRepo.delete({
      code: Like(likePrefix(SEED_MARKERS.couponCode)),
    });
    if (couponAffected) {
      this.logger.log(`🗑️ Hard-deleted ${couponAffected} seed coupon(s)`);
    }
  }
}
