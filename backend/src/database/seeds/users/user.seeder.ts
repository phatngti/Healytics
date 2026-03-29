import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
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
        this.logger.log(`  ⏭ User "${userData.email}" already exists, skipping`);
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
      this.logger.log(`  ✅ Created user "${userData.email}" (${userData.role})`);

      // Create UserProfile for USER-role accounts
      if (userData.role === Role.USER) {
        const profile = this.userProfileRepo.create({
          firstName: 'Test',
          lastName: 'User',
          phone: '0900000001',
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
