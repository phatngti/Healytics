import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    ManyToOne,
    CreateDateColumn,
    UpdateDateColumn,
    JoinColumn,
} from 'typeorm';
import { DocumentType } from '../enum/document-type.enum';
import { Partner } from './partner.entity';
import { DocumentStatus } from '../enum/document-status.enum';

/**
 * Tracks documents uploaded by partners for verification.
 * Each document is stored in R2 and tracked by its key.
 */
@Entity('partner_document')
export class PartnerDocument {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    // Relationship to Partner
    @Column({ name: 'business_entity_id' })
    businessEntityId: string;

    @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'business_entity_id' })
    partner: Partner;

    @Column({
        type: 'enum',
        enum: DocumentType,
    })
    documentType: DocumentType;

    @Column({ name: 'document_key' })
    documentKey: string; // S3/R2 object key

    @Column({
        type: 'enum',
        enum: DocumentStatus,
        default: DocumentStatus.PENDING,
    })
    status: DocumentStatus;

    @Column({ type: 'text', nullable: true, name: 'verification_notes' })
    verificationNotes: string | null;

    @Column({ type: 'text', nullable: true, name: 'admin_feedback' })
    adminFeedback: string | null; // Feedback when rejected for partner to fix

    @Column({
        type: 'uuid',
        name: 'verified_by',
        nullable: true,
    })
    verifiedBy: string | null; // Admin account ID who verified

    @CreateDateColumn({ name: 'uploaded_at' })
    uploadedAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;
}
