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
 * Supports two types of documents:
 * 1. Registration documents (identity cards) - documentUrl only (HTTP link)
 * 2. Uploaded documents - documentUrl + documentKey (R2/S3 key)
 */
@Entity('partner_document')
export class PartnerDocument {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    // Relationship to Partner
    @Column({ name: 'partner_id' })
    partnerId: string;

    @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
    @JoinColumn({ name: 'partner_id' })
    partner: Partner;

    @Column({
        type: 'enum',
        enum: DocumentType,
    })
    documentType: DocumentType;

    // Document URL - always present for registration documents, can be null during initial upload steps
    @Column({ name: 'document_url', type: 'text', nullable: true })
    documentUrl: string | null;

    // R2/S3 object key - only for uploaded documents, null for registration documents
    @Column({ name: 'document_key', type: 'text', nullable: true })
    documentKey: string | null;

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
