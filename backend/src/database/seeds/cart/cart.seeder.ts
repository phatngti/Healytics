import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';
import { Coupon } from '@/cart/entities/coupon.entity';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, buildMapBy, seedKey } from '../utils/seed.utils';

interface SeedCoupon {
  code: string;
  discountPercent: number;
  maxDiscountAmount: number | null;
  usageLimit: number | null;
  usedCount: number;
  isActive: boolean;
  expiresAt: Date | null;
  serviceSlug: string | null;
  categorySlug: string | null;
}

interface SeedCartItem {
  userEmail: string;
  serviceSlug: string;
  couponCode: string | null;
}

const SEED_COUPONS: SeedCoupon[] = [
  {
    code: seedKey(SEED_MARKERS.couponCode, 'SERVICE_10'),
    discountPercent: 10,
    maxDiscountAmount: 60000,
    usageLimit: 100,
    usedCount: 0,
    isActive: true,
    expiresAt: new Date('2099-01-01T00:00:00.000Z'),
    serviceSlug: 'full-body-massage-60-min',
    categorySlug: null,
  },
  {
    code: seedKey(SEED_MARKERS.couponCode, 'CATEGORY_15'),
    discountPercent: 15,
    maxDiscountAmount: 100000,
    usageLimit: 200,
    usedCount: 0,
    isActive: true,
    expiresAt: new Date('2099-01-01T00:00:00.000Z'),
    serviceSlug: null,
    categorySlug: 'relaxation-massage',
  },
  {
    code: seedKey(SEED_MARKERS.couponCode, 'EXPIRED_20'),
    discountPercent: 20,
    maxDiscountAmount: 120000,
    usageLimit: 100,
    usedCount: 0,
    isActive: true,
    expiresAt: new Date('2024-01-01T00:00:00.000Z'),
    serviceSlug: null,
    categorySlug: 'spa-beauty',
  },
  {
    code: seedKey(SEED_MARKERS.couponCode, 'INACTIVE_10'),
    discountPercent: 10,
    maxDiscountAmount: 50000,
    usageLimit: 100,
    usedCount: 0,
    isActive: false,
    expiresAt: new Date('2099-01-01T00:00:00.000Z'),
    serviceSlug: 'neck-shoulder-therapy',
    categorySlug: null,
  },
  {
    code: seedKey(SEED_MARKERS.couponCode, 'LIMIT_REACHED_30'),
    discountPercent: 30,
    maxDiscountAmount: 150000,
    usageLimit: 1,
    usedCount: 1,
    isActive: true,
    expiresAt: new Date('2099-01-01T00:00:00.000Z'),
    serviceSlug: 'basic-facial-care-package',
    categorySlug: null,
  },
];

const SEED_CART_ITEMS: SeedCartItem[] = [
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'full-body-massage-60-min',
    couponCode: seedKey(SEED_MARKERS.couponCode, 'SERVICE_10'),
  },
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'neck-shoulder-therapy',
    couponCode: null,
  },
  {
    userEmail: 'user@healytics.vn',
    serviceSlug: 'basic-facial-care-package',
    couponCode: seedKey(SEED_MARKERS.couponCode, 'CATEGORY_15'),
  },
];

@Injectable()
export class CartSeeder implements ISeeder {
  private readonly logger = new Logger(CartSeeder.name);

  constructor(
    @InjectRepository(Coupon)
    private readonly couponRepo: Repository<Coupon>,
    @InjectRepository(CartItem)
    private readonly cartItemRepo: Repository<CartItem>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
    @InjectRepository(Category)
    private readonly categoryRepo: Repository<Category>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding cart data...');

    const [accounts, products, categories] = await Promise.all([
      this.accountRepo.find({
        where: { email: In([...new Set(SEED_CART_ITEMS.map((item) => item.userEmail))]) },
        select: ['id', 'email'],
      }),
      this.productRepo.find({
        where: {
          slug: In(
            [...new Set(SEED_CART_ITEMS.map((item) => item.serviceSlug))].concat(
              SEED_COUPONS.map((item) => item.serviceSlug).filter(
                (slug): slug is string => slug !== null,
              ),
            ),
          ),
        },
        select: ['id', 'slug', 'salePrice', 'basePrice', 'categoryId'],
      }),
      this.categoryRepo.find({
        where: {
          slug: In(
            SEED_COUPONS.map((item) => item.categorySlug).filter(
              (slug): slug is string => slug !== null,
            ),
          ),
        },
        select: ['id', 'slug'],
      }),
    ]);

    const accountMap = buildMapBy(accounts, (item) => item.email);
    const productMap = buildMapBy(products, (item) => item.slug);
    const categoryMap = buildMapBy(categories, (item) => item.slug);

    await this.seedCoupons(productMap, categoryMap);
    await this.seedCartItems(accountMap, productMap);

    this.logger.log('Cart seeding completed');
  }

  private async seedCoupons(
    productMap: Map<string, Product>,
    categoryMap: Map<string, Category>,
  ): Promise<void> {
    for (const seed of SEED_COUPONS) {
      const existing = await this.couponRepo.findOne({ where: { code: seed.code } });

      const service = seed.serviceSlug ? productMap.get(seed.serviceSlug) : null;
      const category = seed.categorySlug ? categoryMap.get(seed.categorySlug) : null;

      if (seed.serviceSlug && !service) {
        this.logger.warn(`  ⚠ Product "${seed.serviceSlug}" not found — skipping coupon`);
        continue;
      }
      if (seed.categorySlug && !category) {
        this.logger.warn(`  ⚠ Category "${seed.categorySlug}" not found — skipping coupon`);
        continue;
      }

      if (!existing) {
        await this.couponRepo.save(
          this.couponRepo.create({
            code: seed.code,
            discountPercent: seed.discountPercent,
            maxDiscountAmount: seed.maxDiscountAmount,
            usageLimit: seed.usageLimit,
            usedCount: seed.usedCount,
            isActive: seed.isActive,
            expiresAt: seed.expiresAt,
            serviceId: service?.id ?? null,
            categoryId: category?.id ?? null,
          }),
        );
        this.logger.log(`  ✅ Created coupon "${seed.code}"`);
        continue;
      }

      existing.discountPercent = seed.discountPercent;
      existing.maxDiscountAmount = seed.maxDiscountAmount;
      existing.usageLimit = seed.usageLimit;
      existing.usedCount = seed.usedCount;
      existing.isActive = seed.isActive;
      existing.expiresAt = seed.expiresAt;
      existing.serviceId = service?.id ?? null;
      existing.categoryId = category?.id ?? null;
      await this.couponRepo.save(existing);
      this.logger.log(`  🔄 Updated coupon "${seed.code}"`);
    }
  }

  private async seedCartItems(
    accountMap: Map<string, Account>,
    productMap: Map<string, Product>,
  ): Promise<void> {
    const couponCodes = SEED_CART_ITEMS.map((item) => item.couponCode).filter(
      (code): code is string => code !== null,
    );
    const coupons = await this.couponRepo.find({
      where: { code: In(couponCodes) },
      select: ['code', 'discountPercent', 'maxDiscountAmount'],
    });
    const couponMap = buildMapBy(coupons, (item) => item.code);

    for (const seed of SEED_CART_ITEMS) {
      const user = accountMap.get(seed.userEmail);
      const service = productMap.get(seed.serviceSlug);

      if (!user || !service) {
        this.logger.warn(`  ⚠ Missing FK for cart item "${seed.serviceSlug}" — skipping`);
        continue;
      }

      const existing = await this.cartItemRepo.findOne({
        where: { userId: user.id, serviceId: service.id },
      });

      const coupon = seed.couponCode ? couponMap.get(seed.couponCode) : null;
      const servicePrice = Number(service.salePrice ?? service.basePrice ?? 0);
      const discountAmount =
        coupon && coupon.discountPercent
          ? this.calculateDiscountAmount(
              servicePrice,
              coupon.discountPercent,
              coupon.maxDiscountAmount,
            )
          : null;

      if (!existing) {
        await this.cartItemRepo.save(
          this.cartItemRepo.create({
            userId: user.id,
            serviceId: service.id,
            couponCode: coupon?.code ?? null,
            couponDiscountPercent: coupon?.discountPercent ?? null,
            couponDiscountAmount: discountAmount,
          }),
        );
        this.logger.log(`  ✅ Created cart item "${seed.serviceSlug}"`);
        continue;
      }

      existing.couponCode = coupon?.code ?? null;
      existing.couponDiscountPercent = coupon?.discountPercent ?? null;
      existing.couponDiscountAmount = discountAmount;
      await this.cartItemRepo.save(existing);
      this.logger.log(`  🔄 Updated cart item "${seed.serviceSlug}"`);
    }
  }

  private calculateDiscountAmount(
    servicePrice: number,
    discountPercent: number,
    maxDiscountAmount: number | null,
  ): number {
    const calculated = Math.floor((servicePrice * discountPercent) / 100);
    if (maxDiscountAmount === null) return calculated;
    return Math.min(calculated, maxDiscountAmount);
  }

  async clear(): Promise<void> {
    const productSlugs = SEED_CART_ITEMS.map((item) => item.serviceSlug);
    const [users, products] = await Promise.all([
      this.accountRepo.find({
        where: { email: In([...new Set(SEED_CART_ITEMS.map((item) => item.userEmail))]) },
        select: ['id'],
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

    const couponCodes = SEED_COUPONS.map((item) => item.code);
    const { affected: couponAffected } = await this.couponRepo.delete({
      code: In(couponCodes),
    });
    if (!couponAffected) {
      this.logger.warn('⚠ No seed coupons found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${couponAffected} seed coupon(s)`);
  }
}
