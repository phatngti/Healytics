import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { Account } from '@/common/entities/account.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Role } from '@/account/enum/role.enum';
import { ISeeder } from '../seeder.interface';

const SEED_USERS = [
  {
    email: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    username: 'admin',
    password: process.env.DEFAULT_ADMIN_PASSWORD || 'admin@123',
    role: Role.ADMIN,
  },
  {
    email: 'user@healytics.vn',
    username: 'testuser',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Test',
    lastName: 'User',
    phone: '0900000001',
  },
  {
    email: 'nguyenvana@healytics.vn',
    username: 'nguyenvana',
    password: 'user@123',
    role: Role.USER,
    firstName: 'An',
    lastName: 'Nguyen Van',
    phone: '0901000001',
  },
  {
    email: 'tranthib@healytics.vn',
    username: 'tranthib',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Binh',
    lastName: 'Tran Thi',
    phone: '0901000002',
  },
  {
    email: 'levanc@healytics.vn',
    username: 'levanc',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Cuong',
    lastName: 'Le Van',
    phone: '0901000003',
  },
  {
    email: 'phamthid@healytics.vn',
    username: 'phamthid',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Dung',
    lastName: 'Pham Thi',
    phone: '0901000004',
  },
  {
    email: 'hoangvane@healytics.vn',
    username: 'hoangvane',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Em',
    lastName: 'Hoang Van',
    phone: '0901000005',
  },
  {
    email: 'vuthif@healytics.vn',
    username: 'vuthif',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Fang',
    lastName: 'Vu Thi',
    phone: '0901000006',
  },
  {
    email: 'dangvang@healytics.vn',
    username: 'dangvang',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Giang',
    lastName: 'Dang Van',
    phone: '0901000007',
  },
  {
    email: 'buithih@healytics.vn',
    username: 'buithih',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Huong',
    lastName: 'Bui Thi',
    phone: '0901000008',
  },
  {
    email: 'ngothii@healytics.vn',
    username: 'ngothii',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Ich',
    lastName: 'Ngo Thi',
    phone: '0901000009',
  },
  {
    email: 'dovank@healytics.vn',
    username: 'dovank',
    password: 'user@123',
    role: Role.USER,
    firstName: 'Khoa',
    lastName: 'Do Van',
    phone: '0901000010',
  },
  {
    email: 'partner@healytics.vn',
    username: 'testpartner',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
  {
    email: 'partner2@healytics.vn',
    username: 'partner_dental',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
  {
    email: 'partner3@healytics.vn',
    username: 'partner_fitness',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
  {
    email: 'partner4@healytics.vn',
    username: 'partner_pharmacy',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
  {
    email: 'partner5@healytics.vn',
    username: 'partner_traditional',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
  {
    email: 'partner6@healytics.vn',
    username: 'partner_psychology',
    password: 'partner@123',
    role: Role.HEALTH_PARTNER,
  },
];

@Injectable()
export class UserSeeder implements ISeeder {
  private readonly logger = new Logger(UserSeeder.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(UserProfile)
    private readonly userProfileRepo: Repository<UserProfile>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding users...');

    for (const userData of SEED_USERS) {
      const exists = await this.accountRepo.findOne({
        where: { email: userData.email },
      });

      if (exists) {
        this.logger.log(
          `  ⏭ User "${userData.email}" already exists, skipping`,
        );
        continue;
      }

      const passwordHash = await bcrypt.hash(userData.password, 10);

      const account = this.accountRepo.create({
        email: userData.email,
        username: userData.username,
        passwordHash,
        role: userData.role,
        isActive: true,
      });

      await this.accountRepo.save(account);
      this.logger.log(
        `  ✅ Created user "${userData.email}" (${userData.role})`,
      );

      // Create UserProfile for USER-role accounts
      if (userData.role === Role.USER) {
        const profile = this.userProfileRepo.create({
          firstName: userData.firstName,
          lastName: userData.lastName,
          phone: userData.phone,
          accountId: account.id,
        });
        await this.userProfileRepo.save(profile);
        this.logger.log(`    👤 Created user profile for "${userData.email}"`);
      }
    }

    this.logger.log('Users seeding completed');
  }

  async clear(): Promise<void> {
    const emails = SEED_USERS.map((u) => u.email);
    const { affected } = await this.accountRepo.delete({ email: In(emails) });
    if (!affected) {
      this.logger.warn('⚠ No seed users found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed user(s)`);
    }
  }
}
