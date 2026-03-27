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
import { Account } from './account.entity';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { Location } from './location.entity';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PartnerDocument } from './partner-document.entity';
import { PartnerReviewLog } from './partner-review-log.entity';
import { LegalRepresentative } from './legal-representative.entity';
import { Employee } from './employee.entity';

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
        type: 'varchar',
        length: 500,
        transformer: {
            // When saving: convert array to comma-separated string
            to: (value: BusinessType[] | BusinessType | null): string | null => {
                if (!value) return null;
                if (Array.isArray(value)) return value.join(',');
                return value; // backward compatibility for single value
            },
            // When loading: split comma-separated string to array
            from: (value: string | null): BusinessType[] => {
                if (!value) return [];
                return value.split(',').filter(v => v.trim()) as BusinessType[];
            },
        },
    })
    businessType: BusinessType[];

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

    @Column({ name: 'coordinates', type: 'text', nullable: true })
    coordinates: string | null;

    @Column({
        name: 'location',
        type: 'geography',
        spatialFeatureType: 'Point',
        srid: 4326,
        nullable: true,
    })
    location: object | null;

    /** Parse latitude from comma-separated coordinates string */
    get latitude(): number | null {
        if (!this.coordinates) return null;
        const lat = parseFloat(this.coordinates.split(',')[0]);
        return isNaN(lat) ? null : lat;
    }

    /** Parse longitude from comma-separated coordinates string */
    get longitude(): number | null {
        if (!this.coordinates) return null;
        const lng = parseFloat(this.coordinates.split(',')[1]);
        return isNaN(lng) ? null : lng;
    }

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

    @OneToMany(() => Employee, (employee) => employee.partner)
    employees: Employee[];
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
