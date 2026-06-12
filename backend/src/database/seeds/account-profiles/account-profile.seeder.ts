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
  {
    accountEmail: 'nguyenvana@healytics.vn',
    code: '002',
    street: '45 Pasteur Street',
    ward: 'Vo Thi Sau Ward',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'tranthib@healytics.vn',
    code: '003',
    street: '18 Truong Dinh Street',
    ward: 'Ward 6',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'levanc@healytics.vn',
    code: '004',
    street: '220 Le Van Sy Street',
    ward: 'Ward 14',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'phamthid@healytics.vn',
    code: '005',
    street: '91 Cach Mang Thang Tam Street',
    ward: 'Ward 5',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'hoangvane@healytics.vn',
    code: '006',
    street: '70 Ly Tu Trong Street',
    ward: 'Ben Thanh Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'vuthif@healytics.vn',
    code: '007',
    street: '11 Mac Dinh Chi Street',
    ward: 'Da Kao Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'dangvang@healytics.vn',
    code: '008',
    street: '36 Nguyen Thi Minh Khai Street',
    ward: 'Da Kao Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'buithih@healytics.vn',
    code: '009',
    street: '24 Dien Bien Phu Street',
    ward: 'Ward 4',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'ngothii@healytics.vn',
    code: '010',
    street: '9 Nguyen Dinh Chieu Street',
    ward: 'Da Kao Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'dovank@healytics.vn',
    code: '011',
    street: '51 Nam Ky Khoi Nghia Street',
    ward: 'Ben Nghe Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'nguyenminh@healytics.vn',
    code: '012',
    street: '73 Nguyen Trai Street',
    ward: 'Ben Thanh Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'lehoanglinh@healytics.vn',
    code: '013',
    street: '102 Vo Van Tan Street',
    ward: 'Ward 6',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'phamquang@healytics.vn',
    code: '014',
    street: '29 Nguyen Van Chiem Street',
    ward: 'Ben Nghe Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'trandangthao@healytics.vn',
    code: '015',
    street: '61 Nguyen Du Street',
    ward: 'Ben Nghe Ward',
    district: 'District 1',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'maianh@healytics.vn',
    code: '016',
    street: '14 Tran Cao Van Street',
    ward: 'Vo Thi Sau Ward',
    district: 'District 3',
    cityOrProvince: 'Ho Chi Minh City',
  },
  {
    accountEmail: 'votuankiet@healytics.vn',
    code: '017',
    street: '5 Pham Ngoc Thach Street',
    ward: 'Vo Thi Sau Ward',
    district: 'District 3',
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
      relations: ['userProfile'],
      loadEagerRelations: false,
    });
    const accountMap = new Map(
      accounts.map((account) => [account.email, account]),
    );

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
        const [currentAddress] = await this.addressRepo.query(
          `
          SELECT id, street
          FROM address
          WHERE id = $1 AND deleted_at IS NULL
          LIMIT 1
          `,
          [profile.addressId],
        );

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
          await this.addressRepo.query(
            `
            UPDATE address
            SET street = $1,
                ward = $2,
                district = $3,
                city_or_province = $4,
                updated_at = NOW()
            WHERE id = $5
            `,
            [
              fullStreet,
              entry.ward,
              entry.district,
              entry.cityOrProvince,
              profile.addressId,
            ],
          );
          this.logger.log(
            `  🔄 Updated seed address for "${entry.accountEmail}"`,
          );
          continue;
        }
      }

      const [savedAddress] = await this.addressRepo.query(
        `
        INSERT INTO address (id, street, ward, district, city_or_province, created_at, updated_at)
        VALUES (uuid_generate_v4(), $1, $2, $3, $4, NOW(), NOW())
        RETURNING id
        `,
        [fullStreet, entry.ward, entry.district, entry.cityOrProvince],
      );

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
