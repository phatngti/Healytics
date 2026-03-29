import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, In, Repository } from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';
import { Account } from '@/common/entities/account.entity';
import { Location } from '@/common/entities/location.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import {
  PartnerDocument,
  DocumentTypes,
  DocumentFileTypes,
  PartnerDocumentStatuses,
  type DocumentTypeValue,
  type DocumentFileType,
  type PartnerDocumentStatus,
} from '@/common/entities/partner-document.entity';
import { Role } from '@/account/enum/role.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { IdType } from '@/partners/enum/id-type.enum';
import { ISeeder } from '../seeder.interface';

// ============================================================================
// Seed Data Types
// ============================================================================

interface SeedLegalRepresentative {
  fullName: string;
  position: string;
  idType: IdType;
  idNumber: string;
  idIssueDate: string; // ISO date string
  phoneNumber?: string;
}

interface SeedDocument {
  documentKey: string;
  fileUrl: string | null;
  type: DocumentTypeValue;
  fileType: DocumentFileType;
  status: PartnerDocumentStatus;
}

interface SeedAddress {
  provinceCode: string; // Official VN administrative code (e.g. "79" for HCMC)
  districtCode: string; // e.g. "760" for District 1
  wardCode: string;     // e.g. "26734" for Bến Nghé ward
}

interface SeedPartner {
  accountEmail: string;
  taxCode: string;
  legalName: string;
  brandName: string;
  businessType: BusinessType[];
  streetAddress: string;
  phoneNumber: string;
  verificationStatus: PartnerVerificationStatus;
  coordinates: string | null;
  address: SeedAddress;
  legalRepresentative: SeedLegalRepresentative;
  documents: SeedDocument[];
}

// ============================================================================
// Seed Data — 6 diverse partners
// ============================================================================

/**
 * Seed partner profiles with related LegalRepresentative and PartnerDocument data.
 * FK dependency:
 *   - `accountId` → Account (requires UserSeeder to create HEALTH_PARTNER accounts first).
 *   - `provinceId`, `districtId`, `wardId` → Location (requires location seed data to be loaded).
 */
const SEED_PARTNERS: SeedPartner[] = [
  // ── 1. APPROVED — Spa & Wellness ──
  {
    accountEmail: 'partner@healytics.vn',
    taxCode: '0123456789',
    legalName: 'Healytics Spa & Wellness LLC',
    brandName: 'Healytics Spa & Wellness',
    businessType: [BusinessType.SPA_BEAUTY, BusinessType.MASSAGE_THERAPY],
    streetAddress: '123 Nguyen Hue Street',
    phoneNumber: '0281234567',
    verificationStatus: PartnerVerificationStatus.APPROVED,
    coordinates: '10.7769,106.7009',
    address: { provinceCode: '79', districtCode: '760', wardCode: '26740' }, // HCMC > Quận 1 > Bến Nghé
    legalRepresentative: {
      fullName: 'Nguyen Van An',
      position: 'Director',
      idType: IdType.CITIZEN_ID,
      idNumber: '079200001234',
      idIssueDate: '2020-06-15',
      phoneNumber: '0901234567',
    },
    documents: [
      {
        documentKey: 'partners/0123456789/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/0123456789/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/0123456789/id-front.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/0123456789/id-front.jpg',
        type: DocumentTypes.IDENTITY_FRONT,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/0123456789/id-back.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/0123456789/id-back.jpg',
        type: DocumentTypes.IDENTITY_BACK,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },

  // ── 2. PENDING — Dental Clinic ──
  {
    accountEmail: 'partner2@healytics.vn',
    taxCode: '0987654321',
    legalName: 'Healytics Dental Clinic Ltd',
    brandName: 'Healytics Dental',
    businessType: [BusinessType.DENTAL],
    streetAddress: '456 Le Loi Street',
    phoneNumber: '0289876543',
    verificationStatus: PartnerVerificationStatus.PENDING,
    coordinates: '10.7831,106.6916',
    address: { provinceCode: '79', districtCode: '770', wardCode: '27139' }, // HCMC > Quận 3 > Phường Võ Thị Sáu
    legalRepresentative: {
      fullName: 'Tran Thi Bich',
      position: 'Chief Dentist',
      idType: IdType.CITIZEN_ID,
      idNumber: '079200005678',
      idIssueDate: '2021-03-22',
      phoneNumber: '0912345678',
    },
    documents: [
      {
        documentKey: 'partners/0987654321/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/0987654321/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/0987654321/kcb-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/0987654321/kcb-license.pdf',
        type: DocumentTypes.KCB_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/0987654321/rhm-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/0987654321/rhm-license.pdf',
        type: DocumentTypes.RHM_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },

  // ── 3. REJECTED — Fitness Center ──
  {
    accountEmail: 'partner3@healytics.vn',
    taxCode: '1122334455',
    legalName: 'FitLife Vietnam JSC',
    brandName: 'FitLife Gym & Yoga',
    businessType: [BusinessType.FITNESS, BusinessType.MASSAGE_REHABILITATION],
    streetAddress: '789 Vo Van Tan',
    phoneNumber: '0283456789',
    verificationStatus: PartnerVerificationStatus.REJECTED,
    coordinates: '10.7756,106.6893',
    address: { provinceCode: '79', districtCode: '770', wardCode: '27142' }, // HCMC > Quận 3 > Phường 9
    legalRepresentative: {
      fullName: 'Le Minh Duc',
      position: 'CEO',
      idType: IdType.PASSPORT,
      idNumber: 'P12345678',
      idIssueDate: '2019-11-10',
      phoneNumber: '0923456789',
    },
    documents: [
      {
        documentKey: 'partners/1122334455/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/1122334455/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.REJECTED,
      },
      {
        documentKey: 'partners/1122334455/id-front.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/1122334455/id-front.jpg',
        type: DocumentTypes.IDENTITY_FRONT,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },

  // ── 4. REQUIRED_RESUBMIT — Pharmacy ──
  {
    accountEmail: 'partner4@healytics.vn',
    taxCode: '5566778899',
    legalName: 'Saigon Pharma Co., Ltd',
    brandName: 'Saigon Pharma',
    businessType: [BusinessType.PHARMACY, BusinessType.NUTRITION],
    streetAddress: '12 Hai Ba Trung',
    phoneNumber: '0284567890',
    verificationStatus: PartnerVerificationStatus.REQUIRED_RESUBMIT,
    coordinates: '10.7741,106.7030',
    address: { provinceCode: '79', districtCode: '760', wardCode: '26743' }, // HCMC > Quận 1 > Bến Thành
    legalRepresentative: {
      fullName: 'Pham Hoang Long',
      position: 'Pharmacist Manager',
      idType: IdType.CITIZEN_ID,
      idNumber: '079200009012',
      idIssueDate: '2022-01-05',
      phoneNumber: '0934567890',
    },
    documents: [
      {
        documentKey: 'partners/5566778899/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/5566778899/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/5566778899/gpp.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/5566778899/gpp.pdf',
        type: DocumentTypes.GPP,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.REJECTED,
      },
      {
        documentKey: 'partners/5566778899/id-front.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/5566778899/id-front.jpg',
        type: DocumentTypes.IDENTITY_FRONT,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/5566778899/id-back.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/5566778899/id-back.jpg',
        type: DocumentTypes.IDENTITY_BACK,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },

  // ── 5. ONBOARDING — Traditional Medicine ──
  {
    accountEmail: 'partner5@healytics.vn',
    taxCode: '6677889900',
    legalName: 'Dong Y Viet Nam Heritage',
    brandName: 'Heritage Traditional Medicine',
    businessType: [BusinessType.TRADITIONAL_MEDICINE],
    streetAddress: '88 Tran Quoc Toan',
    phoneNumber: '0285678901',
    verificationStatus: PartnerVerificationStatus.ONBOARDING,
    coordinates: '10.7800,106.6870',
    address: { provinceCode: '79', districtCode: '770', wardCode: '27130' }, // HCMC > Quận 3 > Phường 12
    legalRepresentative: {
      fullName: 'Vo Thi Lan',
      position: 'Owner',
      idType: IdType.CITIZEN_ID,
      idNumber: '079200003456',
      idIssueDate: '2023-08-20',
    },
    documents: [
      {
        documentKey: 'partners/6677889900/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/6677889900/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/6677889900/yhct-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/6677889900/yhct-license.pdf',
        type: DocumentTypes.YHCT_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },

  // ── 6. APPROVED — Dermatology & Psychology multi-specialty ──
  {
    accountEmail: 'partner6@healytics.vn',
    taxCode: '7788990011',
    legalName: 'MindSkin Wellness Center',
    brandName: 'MindSkin Clinic',
    businessType: [BusinessType.DERMATOLOGY, BusinessType.PSYCHOLOGY, BusinessType.PSYCHIATRY],
    streetAddress: '55 Nguyen Dinh Chieu',
    phoneNumber: '0286789012',
    verificationStatus: PartnerVerificationStatus.APPROVED,
    coordinates: '10.7810,106.6940',
    address: { provinceCode: '79', districtCode: '770', wardCode: '27151' }, // HCMC > Quận 3 > Phường 5
    legalRepresentative: {
      fullName: 'Hoang Quoc Viet',
      position: 'Medical Director',
      idType: IdType.MILITARY_ID,
      idNumber: 'QD20230001',
      idIssueDate: '2023-02-14',
      phoneNumber: '0945678901',
    },
    documents: [
      {
        documentKey: 'partners/7788990011/business-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/7788990011/business-license.pdf',
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/7788990011/dermatology-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/7788990011/dermatology-license.pdf',
        type: DocumentTypes.DERMATOLOGY_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/7788990011/psychology-license.pdf',
        fileUrl: 'https://storage.healytics.vn/partners/7788990011/psychology-license.pdf',
        type: DocumentTypes.PSYCHOLOGY_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/7788990011/id-front.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/7788990011/id-front.jpg',
        type: DocumentTypes.IDENTITY_FRONT,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: 'partners/7788990011/id-back.jpg',
        fileUrl: 'https://storage.healytics.vn/partners/7788990011/id-back.jpg',
        type: DocumentTypes.IDENTITY_BACK,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  },
];

// ============================================================================
// Seeder Implementation
// ============================================================================

@Injectable()
export class PartnerSeeder implements ISeeder {
  private readonly logger = new Logger(PartnerSeeder.name);

  constructor(
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,

    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,

    @InjectRepository(LegalRepresentative)
    private readonly legalRepRepo: Repository<LegalRepresentative>,

    @InjectRepository(PartnerDocument)
    private readonly partnerDocRepo: Repository<PartnerDocument>,

    @InjectRepository(Location)
    private readonly locationRepo: Repository<Location>,

    private readonly dataSource: DataSource,
  ) {}

  /**
   * Resolve a Location record by its official administrative code.
   * Returns null (with a warning) if the code is not found.
   */
  private async resolveLocationByCode(code: string, label: string): Promise<string | null> {
    const location = await this.locationRepo.findOne({ where: { code } });
    if (!location) {
      this.logger.warn(`  ⚠ Location ${label} with code "${code}" not found — setting to null. Ensure location seed data is loaded.`);
      return null;
    }
    return location.id;
  }

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

      // ── Resolve Location FKs ──
      const { address } = partnerData;
      const [provinceId, districtId, wardId] = await Promise.all([
        this.resolveLocationByCode(address.provinceCode, 'province'),
        this.resolveLocationByCode(address.districtCode, 'district'),
        this.resolveLocationByCode(address.wardCode, 'ward'),
      ]);

      // ── Create Partner ──
      const partner = this.partnerRepo.create({
        taxCode: partnerData.taxCode,
        legalName: partnerData.legalName,
        brandName: partnerData.brandName,
        businessType: partnerData.businessType,
        streetAddress: partnerData.streetAddress,
        phoneNumber: partnerData.phoneNumber,
        verificationStatus: partnerData.verificationStatus,
        verificationCompletedAt:
          partnerData.verificationStatus === PartnerVerificationStatus.APPROVED
            ? new Date()
            : null,
        accountId: account.id,
        coordinates: partnerData.coordinates ?? null,
        provinceId,
        districtId,
        wardId,
      });

      const savedPartner = await this.partnerRepo.save(partner);

      // Set PostGIS location column via raw SQL
      if (partnerData.coordinates) {
        const [lat, lng] = partnerData.coordinates.split(',').map(Number);
        await this.dataSource.query(
          `UPDATE health_partner_profile SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography WHERE id = $3`,
          [lng, lat, savedPartner.id],
        );
      }

      // ── Create Legal Representative ──
      const repData = partnerData.legalRepresentative;
      const legalRep = this.legalRepRepo.create({
        fullName: repData.fullName,
        position: repData.position,
        idType: repData.idType,
        idNumber: repData.idNumber,
        idIssueDate: new Date(repData.idIssueDate),
        phoneNumber: repData.phoneNumber ?? null,
        partnerId: savedPartner.id,
      });
      await this.legalRepRepo.save(legalRep);

      // ── Create Partner Documents ──
      for (const docData of partnerData.documents) {
        const doc = this.partnerDocRepo.create({
          partnerId: savedPartner.id,
          documentKey: docData.documentKey,
          fileUrl: docData.fileUrl,
          type: docData.type,
          fileType: docData.fileType,
          status: docData.status,
        });
        await this.partnerDocRepo.save(doc);
      }

      this.logger.log(
        `  ✅ Created partner "${partnerData.brandName}" (${partnerData.taxCode}) ` +
        `[status: ${partnerData.verificationStatus}, docs: ${partnerData.documents.length}, coords: ${partnerData.coordinates ?? 'none'}]`,
      );
    }

    this.logger.log('Partners seeding completed');
  }

  async clear(): Promise<void> {
    const taxCodes = SEED_PARTNERS.map((p) => p.taxCode);

    // Documents and legal representatives are cascade-deleted via FK
    const { affected } = await this.partnerRepo.delete({ taxCode: In(taxCodes) });
    if (!affected) {
      this.logger.warn('⚠ No seed partners found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed partner(s) (with cascaded docs & legal reps)`);
    }
  }
}
