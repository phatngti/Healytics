import {
  BadRequestException,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import {
  DataSource,
  EntityManager,
  EntityTarget,
  In,
  IsNull,
  ObjectLiteral,
} from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Account } from '@/common/entities/account.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Category } from '@/common/entities/category.entity';
import { Partner } from '@/common/entities/partner.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Notification } from '@/common/entities/notification.entity';
import { Payment } from '@/common/entities/payment.entity';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Coupon } from '@/cart/entities/coupon.entity';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { CartItemStatus } from '@/cart/enums/cart-item-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { NotificationType } from '@/notification/enums/notification-type.enum';

export interface SeedUserInput {
  key?: string;
  email: string;
  password: string;
  firstName?: string;
  lastName?: string;
  phone?: string;
}

export interface SeedCategoryInput {
  key?: string;
  name: string;
  slug?: string;
  description?: string;
  iconName?: string;
  colorValue?: string;
  sortOrder?: number;
}

export interface SeedPartnerInput {
  key?: string;
  email?: string;
  password?: string;
  taxCode?: string;
  legalName?: string;
  brandName: string;
  businessTypes?: BusinessType[];
  streetAddress?: string;
  phoneNumber?: string;
  status?: PartnerVerificationStatus;
}

export interface SeedEmployeeInput {
  key?: string;
  partnerKey?: string;
  partnerBrandName?: string;
  email?: string;
  employeeCode?: string;
  firstName?: string;
  lastName?: string;
  displayName: string;
  phone?: string;
  role?: EmployeeRole;
  status?: EmployeeStatus;
  schedule?: {
    day: string;
    start?: string;
    end?: string;
    isWorking: boolean;
  }[];
}

export interface SeedServiceInput {
  key?: string;
  partnerKey?: string;
  partnerBrandName?: string;
  employeeKeys?: string[];
  categoryKey?: string;
  categoryName?: string;
  name: string;
  slug?: string;
  description?: string;
  price?: number;
  durationMinutes?: number;
  vendorName?: string;
}

export interface SeedCartItemInput {
  key?: string;
  userKey?: string;
  userEmail?: string;
  serviceKey?: string;
  serviceSlug?: string;
  employeeKey?: string;
  employeeEmail?: string;
  startsAt: string;
}

export interface SeedBookingInput extends SeedCartItemInput {
  status?: BookingStatus;
  endsAt?: string;
  paymentUrl?: string;
  paymentExpiresAt?: string;
}

export interface SeedCouponInput {
  key?: string;
  code: string;
  discountPercent: number;
  maxDiscountAmount?: number;
  usageLimit?: number;
  serviceKey?: string;
  serviceSlug?: string;
  categoryName?: string;
  expiresAt?: string;
}

export interface SeedNotificationInput {
  key?: string;
  userKey?: string;
  userEmail?: string;
  senderKey?: string;
  senderEmail?: string;
  type: NotificationType;
  title: string;
  body: string;
  data?: Record<string, any>;
  isRead?: boolean;
  isBroadcast?: boolean;
}

export interface SeedPayload {
  users?: SeedUserInput[];
  categories?: SeedCategoryInput[];
  partners?: SeedPartnerInput[];
  employees?: SeedEmployeeInput[];
  services?: SeedServiceInput[];
  coupons?: SeedCouponInput[];
  cartItems?: SeedCartItemInput[];
  bookings?: SeedBookingInput[];
  notifications?: SeedNotificationInput[];
}

export interface BackdoorPrepareBody {
  scenario?: string;
  payload?: SeedPayload;
}

export type SeedIdsMap = Partial<
  Record<keyof SeedEntityRefs, Record<string, string>>
>;

interface SeedEntityRefs {
  users: Record<string, Account>;
  categories: Record<string, Category>;
  partners: Record<string, Partner>;
  employees: Record<string, Employee>;
  services: Record<string, Product>;
  cartItems: Record<string, CartItem>;
  bookings: Record<string, Booking>;
  coupons: Record<string, Coupon>;
  notifications: Record<string, Notification>;
}

interface SeedRefs extends SeedEntityRefs {
  created: SeedEntityRefs;
}

const MASTER_TABLES = new Set([
  'health_partner_document_requirement',
  'location',
]);

@Injectable()
export class TestBackdoorService {
  constructor(private readonly dataSource: DataSource) {}

  status() {
    this.assertTestOnly();
    return {
      ok: true,
      database: this.dataSource.options.database,
      nodeEnv: process.env.NODE_ENV,
    };
  }

  async resetDb() {
    this.assertTestOnly();

    const tables = this.dataSource.entityMetadatas
      .map((metadata) => ({
        name: metadata.tableName,
        quoted: this.quoteTable(metadata),
      }))
      .filter(({ name }) => !MASTER_TABLES.has(name))
      .map(({ quoted }) => quoted);

    if (tables.length > 0) {
      await this.dataSource.query(
        `TRUNCATE TABLE ${tables.join(', ')} RESTART IDENTITY CASCADE`,
      );
    }

    await this.ensureMasterData();
    return { ok: true, truncatedTables: tables.length };
  }

  async prepare(body: BackdoorPrepareBody) {
    await this.resetDb();
    const payload = body.payload ?? {};
    return this.seedPayload(payload, body.scenario);
  }

  async seedPayload(payload: SeedPayload, scenario = 'inline') {
    this.assertTestOnly();

    const refs = this.emptyRefs();
    await this.dataSource.transaction(async (manager) => {
      for (const category of payload.categories ?? []) {
        await this.createCategory(manager, category, refs);
      }
      for (const user of payload.users ?? []) {
        await this.createUser(manager, user, refs);
      }
      for (const partner of payload.partners ?? []) {
        await this.createPartner(manager, partner, refs);
      }
      for (const employee of payload.employees ?? []) {
        await this.createEmployee(manager, employee, refs);
      }
      for (const service of payload.services ?? []) {
        await this.createService(manager, service, refs);
      }
      for (const coupon of payload.coupons ?? []) {
        await this.createCoupon(manager, coupon, refs);
      }
      for (const cartItem of payload.cartItems ?? []) {
        await this.createCartItem(manager, cartItem, refs);
      }
      for (const booking of payload.bookings ?? []) {
        await this.createBooking(manager, booking, refs);
      }
      for (const notification of payload.notifications ?? []) {
        await this.createNotification(manager, notification, refs);
      }
    });

    return this.serializeRefs(refs, scenario);
  }

  async seedUser(body: SeedUserInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createUser(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-user');
  }

  async seedCategory(body: SeedCategoryInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createCategory(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-category');
  }

  async seedPartner(body: SeedPartnerInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createPartner(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-partner');
  }

  async seedEmployee(body: SeedEmployeeInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createEmployee(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-employee');
  }

  async seedService(body: SeedServiceInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createService(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-service');
  }

  async seedCartItem(body: SeedCartItemInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createCartItem(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-cart');
  }

  async seedCoupon(body: SeedCouponInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createCoupon(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-coupon');
  }

  async seedBooking(body: SeedBookingInput) {
    this.assertTestOnly();
    const refs = this.emptyRefs();
    await this.dataSource.transaction((manager) =>
      this.createBooking(manager, body, refs),
    );
    return this.serializeRefs(refs, 'seed-booking');
  }

  async cleanupSeedData(ids: SeedIdsMap = {}) {
    this.assertTestOnly();

    const uniqueIds = (key: keyof SeedEntityRefs) => [
      ...new Set(Object.values(ids[key] ?? {}).filter(Boolean)),
    ];

    const deleted: Record<string, number> = {};
    await this.dataSource.transaction(async (manager) => {
      const bookingIds = uniqueIds('bookings');
      const cartItemIds = uniqueIds('cartItems');
      const notificationIds = uniqueIds('notifications');
      const couponIds = uniqueIds('coupons');
      const serviceIds = uniqueIds('services');
      const employeeIds = uniqueIds('employees');
      const partnerIds = uniqueIds('partners');
      const categoryIds = uniqueIds('categories');
      const userIds = uniqueIds('users');

      await this.safeDelete(
        manager,
        deleted,
        'notifications',
        Notification,
        notificationIds,
      );
      await this.safeDelete(
        manager,
        deleted,
        'cartItems',
        CartItem,
        cartItemIds,
      );
      if (bookingIds.length) {
        await this.safeDeleteBy(
          manager,
          deleted,
          'bookingStatusLogs',
          BookingStatusLog,
          { bookingId: In(bookingIds) },
        );
        await this.safeDeleteBy(manager, deleted, 'payments', Payment, {
          bookingId: In(bookingIds),
        });
      }
      await this.safeDelete(manager, deleted, 'bookings', Booking, bookingIds);
      await this.safeDelete(manager, deleted, 'coupons', Coupon, couponIds);
      if (serviceIds.length) {
        await this.safeDeleteBy(
          manager,
          deleted,
          'productEmployeeEligibility',
          ProductEmployeeEligibility,
          { productId: In(serviceIds) },
        );
        await this.safeDelete(
          manager,
          deleted,
          'productDefinitions',
          ProductDefinition,
          serviceIds,
        );
      }
      await this.safeDelete(manager, deleted, 'services', Product, serviceIds);
      await this.safeDelete(
        manager,
        deleted,
        'employees',
        Employee,
        employeeIds,
      );
      await this.safeDelete(manager, deleted, 'partners', Partner, partnerIds);
      await this.safeDelete(
        manager,
        deleted,
        'categories',
        Category,
        categoryIds,
      );
      await this.safeDelete(manager, deleted, 'accounts', Account, userIds);
    });

    return { ok: true, deleted };
  }

  private assertTestOnly() {
    if (process.env.ENABLE_TEST_BACKDOOR === 'true') {
      return;
    }
    const dbName = String(this.dataSource.options.database ?? '');
    if (process.env.NODE_ENV !== 'test') {
      throw new ForbiddenException('Test backdoor is disabled');
    }
    if (!/test/i.test(dbName)) {
      throw new ForbiddenException('Test backdoor requires a test database');
    }
  }

  private async safeDelete<T extends ObjectLiteral>(
    manager: EntityManager,
    deleted: Record<string, number>,
    label: string,
    entity: EntityTarget<T>,
    ids: string[],
  ) {
    if (ids.length === 0) return;
    await this.safeDeleteBy(manager, deleted, label, entity, { id: In(ids) });
  }

  private async safeDeleteBy<T extends ObjectLiteral>(
    manager: EntityManager,
    deleted: Record<string, number>,
    label: string,
    entity: EntityTarget<T>,
    criteria: object,
  ) {
    try {
      const result = await manager.delete(entity, criteria);
      deleted[label] = (deleted[label] ?? 0) + (result.affected ?? 0);
    } catch {
      deleted[label] = deleted[label] ?? 0;
    }
  }

  private quoteTable(metadata: { schema?: string; tableName: string }) {
    return metadata.schema
      ? `"${metadata.schema}"."${metadata.tableName}"`
      : `"${metadata.tableName}"`;
  }

  private async ensureMasterData() {
    const adminEmail = process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn';
    const adminPassword = process.env.DEFAULT_ADMIN_PASSWORD || 'admin@123';
    const repo = this.dataSource.getRepository(Account);
    const existing = await repo.findOne({ where: { email: adminEmail } });
    if (existing) return;

    await repo.save(
      repo.create({
        email: adminEmail,
        passwordHash: await bcrypt.hash(adminPassword, 10),
        role: Role.ADMIN,
        isActive: true,
      }),
    );
  }

  private async createUser(
    manager: EntityManager,
    input: SeedUserInput,
    refs: SeedRefs,
  ) {
    this.require(input.email, 'users.email');
    this.require(input.password, 'users.password');

    let account = await manager.findOne(Account, {
      where: { email: input.email },
      withDeleted: true,
    });
    const accountCreated = !account || account.deletedAt != null;
    if (account) {
      account.passwordHash = await bcrypt.hash(input.password, 10);
      account.role = Role.USER;
      account.isActive = true;
      account.deletedAt = null;
      account = await manager.save(account);
    } else {
      account = await manager.save(
        manager.create(Account, {
          email: input.email,
          passwordHash: await bcrypt.hash(input.password, 10),
          role: Role.USER,
          isActive: true,
        }),
      );
    }

    const existingProfile = await manager.findOne(UserProfile, {
      where: { accountId: account.id },
      withDeleted: true,
    });
    if (existingProfile) {
      existingProfile.firstName = input.firstName ?? existingProfile.firstName;
      existingProfile.lastName = input.lastName ?? existingProfile.lastName;
      existingProfile.phone = input.phone ?? existingProfile.phone;
      existingProfile.profileCompleted = true;
      existingProfile.deletedAt = null;
      await manager.save(existingProfile);
    } else {
      await manager.save(
        manager.create(UserProfile, {
          firstName: input.firstName ?? 'Test',
          lastName: input.lastName ?? 'User',
          phone: input.phone,
          accountId: account.id,
          profileCompleted: true,
        }),
      );
    }

    refs.users[input.key ?? input.email] = account;
    refs.users[input.email] = account;
    if (accountCreated) {
      refs.created.users[input.key ?? input.email] = account;
      refs.created.users[input.email] = account;
    }
    return account;
  }

  private async createCategory(
    manager: EntityManager,
    input: SeedCategoryInput,
    refs: SeedRefs,
  ) {
    this.require(input.name, 'categories.name');
    const slug = input.slug ?? this.slugify(input.name);
    let category = await manager.findOne(Category, {
      where: { slug },
      withDeleted: true,
    });
    const categoryCreated = !category || category.deletedAt != null;

    if (category) {
      category.name = input.name;
      category.description = input.description ?? category.description;
      category.iconName = input.iconName ?? category.iconName;
      category.colorValue = input.colorValue ?? category.colorValue;
      category.sortOrder = input.sortOrder ?? category.sortOrder;
      category.isActive = true;
      category.deletedAt = null;
      category = await manager.save(category);
    } else {
      category = await manager.save(
        manager.create(Category, {
          name: input.name,
          slug,
          description: input.description ?? null,
          parentId: null,
          imageUrl: null,
          iconName: input.iconName ?? null,
          colorValue: input.colorValue ?? null,
          sortOrder: input.sortOrder ?? 0,
          isActive: true,
        }),
      );
    }

    refs.categories[input.key ?? input.name] = category;
    refs.categories[input.name] = category;
    refs.categories[slug] = category;
    if (categoryCreated) {
      refs.created.categories[input.key ?? input.name] = category;
      refs.created.categories[input.name] = category;
      refs.created.categories[slug] = category;
    }
    return category;
  }

  private async createPartner(
    manager: EntityManager,
    input: SeedPartnerInput,
    refs: SeedRefs,
  ) {
    this.require(input.brandName, 'partners.brandName');
    const key = input.key ?? this.slugify(input.brandName);
    const email = input.email ?? `${key}@partner.test.healytics.vn`;
    const password = input.password ?? 'Password123!';
    const taxCode = input.taxCode ?? `TAX-${key}`.slice(0, 20);

    let account = await manager.findOne(Account, {
      where: { email },
      withDeleted: true,
    });
    const accountCreated = !account || account.deletedAt != null;
    if (account) {
      account.passwordHash = await bcrypt.hash(password, 10);
      account.role = Role.HEALTH_PARTNER;
      account.isActive = true;
      account.deletedAt = null;
      account = await manager.save(account);
    } else {
      account = await manager.save(
        manager.create(Account, {
          email,
          passwordHash: await bcrypt.hash(password, 10),
          role: Role.HEALTH_PARTNER,
          isActive: true,
        }),
      );
    }

    let partner = await manager.findOne(Partner, {
      where: [{ taxCode }, { accountId: account.id }],
      withDeleted: true,
    });
    const partnerCreated = !partner || partner.deletedAt != null;
    if (partner) {
      partner.accountId = account.id;
      partner.taxCode = taxCode;
      partner.legalName = input.legalName ?? input.brandName;
      partner.brandName = input.brandName;
      partner.businessType = input.businessTypes ?? [BusinessType.SPA_BEAUTY];
      partner.streetAddress =
        input.streetAddress ?? 'District 1, Ho Chi Minh City';
      partner.phoneNumber = input.phoneNumber ?? partner.phoneNumber;
      partner.verificationStatus =
        input.status ?? PartnerVerificationStatus.APPROVED;
      partner.verificationCompletedAt = new Date();
      partner.deletedAt = null;
      partner = await manager.save(partner);
    } else {
      partner = await manager.save(
        manager.create(Partner, {
          accountId: account.id,
          taxCode,
          legalName: input.legalName ?? input.brandName,
          brandName: input.brandName,
          businessType: input.businessTypes ?? [BusinessType.SPA_BEAUTY],
          streetAddress: input.streetAddress ?? 'District 1, Ho Chi Minh City',
          phoneNumber: input.phoneNumber ?? null,
          coordinates: null,
          location: null,
          gallery: [],
          description: null,
          followerCount: 0,
          verificationStatus:
            input.status ?? PartnerVerificationStatus.APPROVED,
          verificationCompletedAt: new Date(),
        }),
      );
    }

    refs.partners[key] = partner;
    refs.partners[input.brandName] = partner;
    if (accountCreated) {
      refs.created.users[`${key}:account`] = account;
      refs.created.users[email] = account;
    }
    if (partnerCreated) {
      refs.created.partners[key] = partner;
      refs.created.partners[input.brandName] = partner;
    }
    return partner;
  }

  private async createEmployee(
    manager: EntityManager,
    input: SeedEmployeeInput,
    refs: SeedRefs,
  ) {
    this.require(input.displayName, 'employees.displayName');
    const key = input.key ?? this.slugify(input.displayName);
    const partner = await this.resolvePartner(manager, refs, input);
    const email = input.email ?? `${key}@employee.test.healytics.vn`;
    const employeeCode = input.employeeCode ?? `EMP-${key}`.slice(0, 50);

    let account = await manager.findOne(Account, {
      where: { email },
      withDeleted: true,
    });
    const accountCreated = !account || account.deletedAt != null;
    if (account) {
      account.passwordHash = await bcrypt.hash('Password123!', 10);
      account.role = Role.EMPLOYEE;
      account.isActive = true;
      account.deletedAt = null;
      account = await manager.save(account);
    } else {
      account = await manager.save(
        manager.create(Account, {
          email,
          passwordHash: await bcrypt.hash('Password123!', 10),
          role: Role.EMPLOYEE,
          isActive: true,
        }),
      );
    }

    const names = input.displayName.split(' ');
    let employee = await manager.findOne(Employee, {
      where: [{ email }, { employeeCode }],
      withDeleted: true,
    });
    const employeeCreated = !employee || employee.deletedAt != null;
    const employeeFields = {
      employeeCode,
      firstName: (input.firstName ?? names.slice(0, -1).join(' ')) || names[0],
      lastName: input.lastName ?? names.slice(-1).join(' '),
      fullName: input.displayName,
      email,
      phone: input.phone,
      avatarUrl: undefined,
      jobTitle: input.role ?? EmployeeRole.DOCTOR,
      startDate: undefined,
      employmentType: undefined,
      emergencyContactName: undefined,
      emergencyContactPhone: undefined,
      verificationDocuments: [],
      description: undefined,
      schedule: input.schedule,
      workHistory: undefined,
      dob: undefined,
      gender: undefined,
      role: input.role ?? EmployeeRole.DOCTOR,
      status: input.status ?? EmployeeStatus.ACTIVE,
      rating: 0,
      reviewCount: 0,
      partnerId: partner?.id ?? null,
      accountId: account.id,
    };
    if (employee) {
      Object.assign(employee, employeeFields, { deletedAt: null });
      employee = await manager.save(employee);
    } else {
      employee = await manager.save(manager.create(Employee, employeeFields));
    }

    refs.employees[key] = employee;
    refs.employees[email] = employee;
    refs.employees[input.displayName] = employee;
    if (accountCreated) {
      refs.created.users[`${key}:account`] = account;
      refs.created.users[email] = account;
    }
    if (employeeCreated) {
      refs.created.employees[key] = employee;
      refs.created.employees[email] = employee;
      refs.created.employees[input.displayName] = employee;
    }
    return employee;
  }

  private async createService(
    manager: EntityManager,
    input: SeedServiceInput,
    refs: SeedRefs,
  ) {
    this.require(input.name, 'services.name');
    const key = input.key ?? this.slugify(input.name);
    const slug = input.slug ?? key;
    const partner = await this.resolvePartner(manager, refs, input);
    const category = input.categoryName
      ? await this.createCategory(
          manager,
          {
            key: input.categoryKey,
            name: input.categoryName,
          },
          refs,
        )
      : null;

    let service = await manager.findOne(Product, {
      where: { partnerId: partner?.id ?? IsNull(), slug },
      withDeleted: true,
    });
    const serviceCreated = !service || service.deletedAt != null;
    const serviceFields = {
      partnerId: partner?.id ?? null,
      categoryId: category?.id ?? null,
      name: input.name,
      slug,
      description: input.description ?? null,
      type: HealthServiceType.SERVICE,
      basePrice: input.price ?? 500000,
      salePrice: null,
      currency: 'VND',
      status: HealthServiceStatus.ACTIVE,
      isVisibleOnline: true,
      serviceManual: null,
      vendorName: input.vendorName ?? partner?.brandName ?? null,
    };
    if (service) {
      Object.assign(service, serviceFields, { deletedAt: null });
      service = await manager.save(service);
    } else {
      service = await manager.save(manager.create(Product, serviceFields));
    }

    const existingDefinition = await manager.findOne(ProductDefinition, {
      where: { productId: service.id },
    });
    if (existingDefinition) {
      existingDefinition.durationMinutes = input.durationMinutes ?? 60;
      existingDefinition.bufferMinutes = 0;
      existingDefinition.maxCapacity = 1;
      existingDefinition.minLeadTimeHours = 0;
      existingDefinition.staffAssignmentType = StaffAssignmentType.ANY;
      await manager.save(existingDefinition);
    } else {
      await manager.save(
        manager.create(ProductDefinition, {
          productId: service.id,
          durationMinutes: input.durationMinutes ?? 60,
          bufferMinutes: 0,
          maxCapacity: 1,
          minLeadTimeHours: 0,
          staffAssignmentType: StaffAssignmentType.ANY,
        }),
      );
    }

    for (const employeeKey of input.employeeKeys ?? []) {
      const employee = await this.resolveEmployee(manager, refs, {
        employeeKey,
      });
      const existingEligibility = await manager.findOne(
        ProductEmployeeEligibility,
        {
          where: { productId: service.id, employeeId: employee.id },
        },
      );
      if (existingEligibility) {
        existingEligibility.isPrimary = true;
        await manager.save(existingEligibility);
      } else {
        await manager.save(
          manager.create(ProductEmployeeEligibility, {
            productId: service.id,
            employeeId: employee.id,
            isPrimary: true,
          }),
        );
      }
    }

    refs.services[key] = service;
    refs.services[slug] = service;
    refs.services[input.name] = service;
    if (serviceCreated) {
      refs.created.services[key] = service;
      refs.created.services[slug] = service;
      refs.created.services[input.name] = service;
    }
    return service;
  }

  private async createCoupon(
    manager: EntityManager,
    input: SeedCouponInput,
    refs: SeedRefs,
  ) {
    const service =
      input.serviceKey || input.serviceSlug
        ? await this.resolveService(manager, refs, input)
        : null;
    const category = input.categoryName
      ? await this.createCategory(manager, { name: input.categoryName }, refs)
      : null;

    let coupon = await manager.findOne(Coupon, { where: { code: input.code } });
    const couponCreated = !coupon;
    const couponFields = {
      code: input.code,
      discountPercent: input.discountPercent,
      maxDiscountAmount: input.maxDiscountAmount ?? null,
      usageLimit: input.usageLimit ?? null,
      usedCount: 0,
      isActive: true,
      expiresAt: input.expiresAt ? new Date(input.expiresAt) : null,
      serviceId: service?.id ?? null,
      categoryId: category?.id ?? null,
    };
    if (coupon) {
      Object.assign(coupon, couponFields);
      coupon = await manager.save(coupon);
    } else {
      coupon = await manager.save(manager.create(Coupon, couponFields));
    }

    refs.coupons[input.key ?? input.code] = coupon;
    if (couponCreated) {
      refs.created.coupons[input.key ?? input.code] = coupon;
    }
    return coupon;
  }

  private async createCartItem(
    manager: EntityManager,
    input: SeedCartItemInput,
    refs: SeedRefs,
  ) {
    const user = await this.resolveUser(manager, refs, input);
    const service = await this.resolveService(manager, refs, input);
    const employee = await this.resolveEmployee(manager, refs, input);
    const timeSlot = new Date(input.startsAt);

    let item = await manager.findOne(CartItem, {
      where: {
        userId: user.id,
        serviceId: service.id,
        employeeId: employee.id,
        timeSlot,
      },
    });
    const itemCreated = !item;
    if (item) {
      item.status = CartItemStatus.ACTIVE;
      item = await manager.save(item);
    } else {
      item = await manager.save(
        manager.create(CartItem, {
          userId: user.id,
          serviceId: service.id,
          employeeId: employee.id,
          timeSlot,
          status: CartItemStatus.ACTIVE,
        }),
      );
    }

    refs.cartItems[input.key ?? item.id] = item;
    if (itemCreated) {
      refs.created.cartItems[input.key ?? item.id] = item;
    }
    return item;
  }

  private async createBooking(
    manager: EntityManager,
    input: SeedBookingInput,
    refs: SeedRefs,
  ) {
    const user = await this.resolveUser(manager, refs, input);
    const service = await this.resolveService(manager, refs, input);
    const employee = await this.resolveEmployee(manager, refs, input);
    const start = new Date(input.startsAt);
    const end = input.endsAt
      ? new Date(input.endsAt)
      : new Date(start.getTime() + 60 * 60 * 1000);

    let booking = await manager.findOne(Booking, {
      where: {
        staffId: employee.id,
        startTime: start,
        status: In([BookingStatus.PENDING_PAYMENT, BookingStatus.CONFIRMED]),
      },
      withDeleted: true,
    });
    const bookingCreated = !booking || booking.deletedAt != null;
    const bookingFields = {
      userId: user.id,
      staffId: employee.id,
      productId: service.id,
      startTime: start,
      endTime: end,
      status: input.status ?? BookingStatus.CONFIRMED,
      paymentUrl: input.paymentUrl ?? null,
      paymentDeeplink: null,
      paymentExpiresAt: input.paymentExpiresAt
        ? new Date(input.paymentExpiresAt)
        : null,
      notes: null,
      isReviewed: false,
    };
    if (booking) {
      Object.assign(booking, bookingFields, { deletedAt: null });
      booking = await manager.save(booking);
    } else {
      booking = await manager.save(manager.create(Booking, bookingFields));
    }

    refs.bookings[input.key ?? booking.id] = booking;
    if (bookingCreated) {
      refs.created.bookings[input.key ?? booking.id] = booking;
    }
    return booking;
  }

  private async createNotification(
    manager: EntityManager,
    input: SeedNotificationInput,
    refs: SeedRefs,
  ) {
    this.require(input.type, 'notifications.type');
    this.require(input.title, 'notifications.title');
    this.require(input.body, 'notifications.body');

    const recipient = input.isBroadcast
      ? null
      : await this.resolveUser(manager, refs, input);
    const sender =
      input.senderKey || input.senderEmail
        ? await this.resolveUser(manager, refs, {
            userKey: input.senderKey,
            userEmail: input.senderEmail,
          })
        : null;
    const isRead = input.isRead ?? false;

    const notification = await manager.save(
      manager.create(Notification, {
        recipientId: recipient?.id ?? null,
        senderId: sender?.id ?? null,
        type: input.type,
        title: input.title,
        body: input.body,
        data: input.data ?? null,
        isRead,
        readAt: isRead ? new Date() : null,
        isBroadcast: input.isBroadcast ?? false,
      }),
    );

    refs.notifications[input.key ?? notification.id] = notification;
    refs.created.notifications[input.key ?? notification.id] = notification;
    return notification;
  }

  private async resolveUser(
    manager: EntityManager,
    refs: SeedRefs,
    input: { userKey?: string; userEmail?: string },
  ) {
    const user =
      (input.userKey && refs.users[input.userKey]) ||
      (input.userEmail && refs.users[input.userEmail]) ||
      (input.userEmail
        ? await manager.findOne(Account, { where: { email: input.userEmail } })
        : null);
    if (!user) throw new BadRequestException('Unable to resolve user');
    return user;
  }

  private async resolvePartner(
    manager: EntityManager,
    refs: SeedRefs,
    input: { partnerKey?: string; partnerBrandName?: string },
  ) {
    const partner =
      (input.partnerKey && refs.partners[input.partnerKey]) ||
      (input.partnerBrandName && refs.partners[input.partnerBrandName]) ||
      (input.partnerBrandName
        ? await manager.findOne(Partner, {
            where: { brandName: input.partnerBrandName },
          })
        : null);
    return partner;
  }

  private async resolveEmployee(
    manager: EntityManager,
    refs: SeedRefs,
    input: { employeeKey?: string; employeeEmail?: string },
  ) {
    const employee =
      (input.employeeKey && refs.employees[input.employeeKey]) ||
      (input.employeeEmail && refs.employees[input.employeeEmail]) ||
      (input.employeeEmail
        ? await manager.findOne(Employee, {
            where: { email: input.employeeEmail },
          })
        : null);
    if (!employee) throw new BadRequestException('Unable to resolve employee');
    return employee;
  }

  private async resolveService(
    manager: EntityManager,
    refs: SeedRefs,
    input: { serviceKey?: string; serviceSlug?: string },
  ) {
    const service =
      (input.serviceKey && refs.services[input.serviceKey]) ||
      (input.serviceSlug && refs.services[input.serviceSlug]) ||
      (input.serviceSlug
        ? await manager.findOne(Product, { where: { slug: input.serviceSlug } })
        : null);
    if (!service) throw new BadRequestException('Unable to resolve service');
    return service;
  }

  private emptyRefs(): SeedRefs {
    return {
      users: {},
      categories: {},
      partners: {},
      employees: {},
      services: {},
      cartItems: {},
      bookings: {},
      coupons: {},
      notifications: {},
      created: {
        users: {},
        categories: {},
        partners: {},
        employees: {},
        services: {},
        cartItems: {},
        bookings: {},
        coupons: {},
        notifications: {},
      },
    };
  }

  private serializeRefs(refs: SeedRefs, scenario: string) {
    const toRecord = <T extends { id: string }>(items: Record<string, T>) =>
      Object.fromEntries(
        Object.entries(items).map(([key, value]) => [key, value.id]),
      );

    return {
      ok: true,
      scenario,
      ids: {
        users: toRecord(refs.created.users),
        categories: toRecord(refs.created.categories),
        partners: toRecord(refs.created.partners),
        employees: toRecord(refs.created.employees),
        services: toRecord(refs.created.services),
        cartItems: toRecord(refs.created.cartItems),
        bookings: toRecord(refs.created.bookings),
        coupons: toRecord(refs.created.coupons),
        notifications: toRecord(refs.created.notifications),
      },
    };
  }

  private require(value: unknown, field: string) {
    if (value === undefined || value === null || value === '') {
      throw new BadRequestException(`${field} is required`);
    }
  }

  private slugify(value: string) {
    return value
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .replace(/[đĐ]/g, 'd')
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }
}
