import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    UpdateDateColumn,
    DeleteDateColumn,
    OneToOne,
    JoinColumn,
    ManyToOne,
    OneToMany,
} from 'typeorm';
import { Account } from '@/account/entities/account.entity';
import { BusinessType } from '../enum/business-type.enum';
import { Location } from '@/locations/entities/location.entity';
import { PartnerVerificationStatus } from '../enum/partner-verification-status.enum';
import { PartnerDocument } from './partner-document.entity';
import { PartnerReviewLog } from '../../admin/entities/partner-review-log.entity';
import { LegalRepresentative } from './legal-representative.entity';

@Entity('health_partner_profile')
export class Partner {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'tax_code', unique: true, length: 20 })
    taxCode: string;

    @Column({ name: 'legal_name', length: 200 })
    legalName: string;

    @Column({ name: 'brand_name', length: 150 })
    brandName: string;

    @Column({
        name: 'business_type',
        type: 'enum',
        enum: BusinessType,
    })
    businessType: BusinessType;

    // Address information using administrative divisions (Tree Entity)
    @Column({ name: 'province_id', type: 'uuid', nullable: true })
    provinceId: string | null;

    @ManyToOne(() => Location, { onDelete: 'SET NULL' })
    @JoinColumn({ name: 'province_id' })
    province: Location | null;

    @Column({ name: 'district_id', type: 'uuid', nullable: true })
    districtId: string | null;

    @ManyToOne(() => Location, { onDelete: 'SET NULL' })
    @JoinColumn({ name: 'district_id' })
    district: Location | null;

    @Column({ name: 'ward_id', type: 'uuid', nullable: true })
    wardId: string | null;

    @ManyToOne(() => Location, { onDelete: 'SET NULL' })
    @JoinColumn({ name: 'ward_id' })
    ward: Location | null;

    @Column({ name: 'street_address', length: 300 })
    streetAddress: string;

    @Column({ name: 'phone_number', type: 'varchar', length: 20, nullable: true })
    phoneNumber: string | null;

    // Relationship to Account
    @Column({ name: 'account_id' })
    accountId: string;

    @OneToOne(() => Account, (account) => account.partner)
    @JoinColumn({ name: 'account_id' })
    account: Account;

    // Relationship to Legal Representative (using string to avoid circular dependency)
    @OneToOne(() => LegalRepresentative, (legalRepresentative) => legalRepresentative.partner, {
        cascade: true,
    })
    legalRepresentative: LegalRepresentative;

    @OneToMany(() => PartnerDocument, (document) => document.partner)
    documents: PartnerDocument[];

    @OneToMany(() => PartnerReviewLog, (log) => log.partner)
    reviewLogs: PartnerReviewLog[];
    // --- Verification Logic ---

    @Column({
        name: 'verification_status',
        type: 'enum',
        enum: PartnerVerificationStatus,
        default: PartnerVerificationStatus.PENDING,
    })
    verificationStatus: PartnerVerificationStatus;

    // ----------------------------------

    @Column({ name: 'verification_completed_at', type: 'timestamptz', nullable: true })
    verificationCompletedAt: Date | null;

    @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
    deletedAt: Date | null;
}
