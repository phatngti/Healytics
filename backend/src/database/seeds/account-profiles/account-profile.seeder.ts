import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Address } from '@/common/entities/address.entity';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, likePrefix, seedKey } from '../utils/seed.utils';

interface SeedAddressProfile {
  accountEmail: string;
  code: string;
  street: string;
  ward: string;
  district: string;
  cityOrProvince: string;
}

const SEED_ADDRESS_PROFILES: SeedAddressProfile[] = [
  {
    accountEmail: 'user@healytics.vn',
    code: '001',
    street: '123 Nguyen Hue Street',
    ward: 'Ben Nghe Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
];

@Injectable()
export class AccountProfileSeeder implements ISeeder {
  private readonly logger = new Logger(AccountProfileSeeder.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(UserProfile)
    private readonly userProfileRepo: Repository<UserProfile>,
    @InjectRepository(Address)
    private readonly addressRepo: Repository<Address>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding account profile addresses...');

    const emails = SEED_ADDRESS_PROFILES.map((item) => item.accountEmail);
    const accounts = await this.accountRepo.find({
      where: { email: In(emails) },
      relations: ['userProfile', 'userProfile.address'],
    });
    const accountMap = new Map(accounts.map((account) => [account.email, account]));

    for (const entry of SEED_ADDRESS_PROFILES) {
      const account = accountMap.get(entry.accountEmail);
      if (!account?.userProfile) {
        this.logger.warn(
          `  ⚠ Account "${entry.accountEmail}" has no user profile — skipping address`,
        );
        continue;
      }

      const marker = seedKey(SEED_MARKERS.address, entry.code);
      const fullStreet = `${marker} ${entry.street}`;
      const profile = account.userProfile;

      if (profile.addressId) {
        const currentAddress = await this.addressRepo.findOne({
          where: { id: profile.addressId },
        });

        if (!currentAddress) {
          this.logger.warn(
            `  ⚠ Profile "${entry.accountEmail}" points to missing address — creating replacement`,
          );
        } else if (!currentAddress.street.startsWith(SEED_MARKERS.address)) {
          this.logger.log(
            `  ⏭ Profile "${entry.accountEmail}" already has non-seed address, skipping`,
          );
          continue;
        } else {
          currentAddress.street = fullStreet;
          currentAddress.ward = entry.ward;
          currentAddress.district = entry.district;
          currentAddress.cityOrProvince = entry.cityOrProvince;
          await this.addressRepo.save(currentAddress);
          this.logger.log(`  🔄 Updated seed address for "${entry.accountEmail}"`);
          continue;
        }
      }

      const address = this.addressRepo.create({
        street: fullStreet,
        ward: entry.ward,
        district: entry.district,
        cityOrProvince: entry.cityOrProvince,
      });
      const savedAddress = await this.addressRepo.save(address);

      profile.addressId = savedAddress.id;
      await this.userProfileRepo.save(profile);

      this.logger.log(`  ✅ Created seed address for "${entry.accountEmail}"`);
    }

    this.logger.log('Account profile address seeding completed');
  }

  async clear(): Promise<void> {
    const seedAddresses = await this.addressRepo.find({
      where: { street: Like(likePrefix(SEED_MARKERS.address)) },
      select: ['id'],
    });

    if (!seedAddresses.length) {
      this.logger.warn('⚠ No seed addresses found to delete');
      return;
    }

    const ids = seedAddresses.map((address) => address.id);

    await this.userProfileRepo
      .createQueryBuilder()
      .update(UserProfile)
      .set({ addressId: null })
      .where('address_id IN (:...ids)', { ids })
      .execute();

    const { affected } = await this.addressRepo.delete({ id: In(ids) });
    this.logger.log(`🗑️ Hard-deleted ${affected ?? 0} seed address(es)`);
  }
}
