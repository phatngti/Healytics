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
} from 'typeorm';
import { Account } from '@/account/entities/account.entity';
import { BusinessType } from '../enum/business-type.enum';
import { Location } from '@/locations/entities/location.entity';

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
    @Column({ name: 'province_id', type: 'uuid' })
    provinceId: string;

    @ManyToOne(() => Location)
    @JoinColumn({ name: 'province_id' })
    province: Location;

    @Column({ name: 'district_id', type: 'uuid' })
    districtId: string;

    @ManyToOne(() => Location)
    @JoinColumn({ name: 'district_id' })
    district: Location;

    @Column({ name: 'ward_id', type: 'uuid' })
    wardId: string;

    @ManyToOne(() => Location)
    @JoinColumn({ name: 'ward_id' })
    ward: Location;

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
    @OneToOne('LegalRepresentative', 'partner', {
        cascade: true,
    })
    legalRepresentative: any;

    @Column({ name: 'is_verified', default: false })
    isVerified: boolean;

    @Column({ name: 'verification_completed_at', nullable: true })
    verificationCompletedAt: Date;

    @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
    createdAt: Date;

    @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
    updatedAt: Date;

    @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
    deletedAt: Date | null;
}
