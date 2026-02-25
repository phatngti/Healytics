import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { Account } from '@/common/entities/account.entity';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { ISeeder } from '../seeder.interface';

/**
 * Seed partner profiles.
 * FK dependency: `accountId` → Account (requires UserSeeder to create HEALTH_PARTNER account first).
 * Location FKs (provinceId, districtId, wardId) are all nullable — left null for seed data.
 */
const SEED_PARTNERS = [
  {
    accountEmail: 'partner@healytics.vn', // ← used to look up the Account FK
    taxCode: '0123456789',
    legalName: 'Healytics Spa & Wellness LLC',
    brandName: 'Healytics Spa & Wellness',
    businessType: [BusinessType.SPA_BEAUTY, BusinessType.MASSAGE_THERAPY],
    streetAddress: '123 Nguyen Hue Street, District 1',
    phoneNumber: '0281234567',
    verificationStatus: PartnerVerificationStatus.APPROVED,
  },
  {
    accountEmail: 'partner@healytics.vn',
    taxCode: '0987654321',
    legalName: 'Healytics Dental Clinic Ltd',
    brandName: 'Healytics Dental',
    businessType: [BusinessType.DENTAL],
    streetAddress: '456 Le Loi Street, District 3',
    phoneNumber: '0289876543',
    verificationStatus: PartnerVerificationStatus.PENDING,
  },
];

@Injectable()
export class PartnerSeeder implements ISeeder {
  private readonly logger = new Logger(PartnerSeeder.name);

  constructor(
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,

    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding partners...');

    for (const partnerData of SEED_PARTNERS) {
      const exists = await this.partnerRepo.findOne({
        where: { taxCode: partnerData.taxCode },
      });

      if (exists) {
        this.logger.log(`  ⏭ Partner "${partnerData.taxCode}" already exists, skipping`);
        continue;
      }

      // Resolve Account FK
      const account = await this.accountRepo.findOne({
        where: { email: partnerData.accountEmail, role: Role.HEALTH_PARTNER },
      });

      if (!account) {
        this.logger.warn(
          `  ⚠ No HEALTH_PARTNER account found for "${partnerData.accountEmail}" — skipping partner "${partnerData.brandName}". Run UserSeeder first.`,
        );
        continue;
      }

      // Check if this account already has a partner (OneToOne constraint)
      const existingPartnerForAccount = await this.partnerRepo.findOne({
        where: { accountId: account.id },
      });

      if (existingPartnerForAccount) {
        this.logger.log(
          `  ⏭ Account "${partnerData.accountEmail}" already has a partner profile, skipping "${partnerData.brandName}"`,
        );
        continue;
      }

      const partner = this.partnerRepo.create({
        taxCode: partnerData.taxCode,
        legalName: partnerData.legalName,
        brandName: partnerData.brandName,
        businessType: partnerData.businessType,
        streetAddress: partnerData.streetAddress,
        phoneNumber: partnerData.phoneNumber,
        verificationStatus: partnerData.verificationStatus,
        verificationCompletedAt: new Date(),
        accountId: account.id,
        // Location FKs — left null for seed data
        provinceId: null,
        districtId: null,
        wardId: null,
      });

      await this.partnerRepo.save(partner);
      this.logger.log(`  ✅ Created partner "${partnerData.brandName}" (${partnerData.taxCode})`);
    }

    this.logger.log('Partners seeding completed');
  }

  async clear(): Promise<void> {
    const taxCodes = SEED_PARTNERS.map((p) => p.taxCode);
    const { affected } = await this.partnerRepo.delete({ taxCode: In(taxCodes) });
    if (!affected) {
      this.logger.warn('⚠ No seed partners found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed partner(s)`);
    }
  }
}
