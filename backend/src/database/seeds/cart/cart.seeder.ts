import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Product } from '@/common/entities/product.entity';
import { Employee } from '@/common/entities/employee.entity';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';
import { ISeeder } from '../seeder.interface';
import { buildMapBy } from '../utils/seed.utils';

interface SeedCartItem {
  userEmail: string;
  serviceSlug: string;
  /** Must be an employee email that is eligible for the service. */
  employeeEmail: string;
  /** Time slot in ISO 8601 format. */
  timeSlot: string;
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
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding cart data...');

    const [accounts, products, employees] = await Promise.all([
      this.accountRepo.find({
        where: { email: In([...new Set(SEED_CART_ITEMS.map((item) => item.userEmail))]) },
        select: ['id', 'email'],
      }),
      this.productRepo.find({
        where: {
          slug: In([...new Set(SEED_CART_ITEMS.map((item) => item.serviceSlug))]),
        },
        select: ['id', 'slug'],
      }),
      this.employeeRepo.find({
        where: {
          email: In([...new Set(SEED_CART_ITEMS.map((item) => item.employeeEmail))]),
        },
        select: ['id', 'email'],
      }),
    ]);

    const accountMap = buildMapBy(accounts, (item) => item.email);
    const productMap = buildMapBy(products, (item) => item.slug);
    const employeeMap = buildMapBy(employees, (item) => item.email);

    await this.seedCartItems(accountMap, productMap, employeeMap);

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
  }
}
