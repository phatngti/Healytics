import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    ManyToOne,
    JoinColumn
} from 'typeorm';
import { Partner } from './partner.entity';
import { Account } from '@/account/entities/account.entity';
import { PartnerVerificationStatus } from '../enum/partner-verification-status.enum';

@Entity('partner_review_log')
export class PartnerReviewLog {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ name: 'partner_id' })
    partnerId: string;

    @ManyToOne(() => Partner, (partner) => partner.reviewLogs, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'partner_id' })
    partner: Partner;

    // Review results
    @Column({
        type: 'enum',
        enum: PartnerVerificationStatus,
        comment: 'Kết quả của đợt review này (VD: REJECTED hoặc APPROVED)'
    })
    verdict: PartnerVerificationStatus;

    // 3. Review Fields
    @Column({ type: 'jsonb', nullable: true })
    fieldReviews: {
        [fieldName: string]: {
            value: any;       //  (Snapshot)
            isValid: boolean;
            reason?: string;  // rejection reason
        }
    } | null;

    // 4. Review Documents
    @Column({ type: 'jsonb', nullable: true })
    documentReviews: {
        [docId: string]: {
            documentType: string;
            url: string;
            isValid: boolean;
            feedback?: string;
        }
    } | null;

    // Reviewer
    @Column({ name: 'reviewer_id', nullable: true })
    reviewerId: string | null;

    @ManyToOne(() => Account)
    @JoinColumn({ name: 'reviewer_id' })
    reviewer: Account;

    @Column({ type: 'text', nullable: true })
    generalComment: string | null;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;
}
