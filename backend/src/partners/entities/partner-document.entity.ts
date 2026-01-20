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

/**
 * Tracks documents uploaded by partners for verification.
 * Uses two separate flags to track review and validity status.
 */
@Entity('partner_document')
export class PartnerDocument {
    @PrimaryGeneratedColumn('uuid')
    id: string;

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

    // URL is always present for registration documents
    @Column({ name: 'document_url', type: 'text', nullable: true })
    documentUrl: string | null;

    // R2/S3 key for uploaded documents
    @Column({ name: 'document_key', type: 'text', nullable: true })
    documentKey: string | null;

    // --- Separate Review and Validity Status ---

    /** Indicates if this document has been reviewed by an admin */
    @Column({ name: 'is_reviewed', default: false })
    isReviewed: boolean;

    /** Indicates if this document is valid (optimistic: true by default until admin marks invalid) */
    @Column({ name: 'is_valid', default: true })
    isValid: boolean;

    // -------------------------------------------

    @Column({ type: 'text', nullable: true, name: 'verification_notes' })
    verificationNotes: string | null;

    @Column({ type: 'text', nullable: true, name: 'admin_feedback' })
    adminFeedback: string | null;

    @Column({
        type: 'uuid',
        name: 'verified_by',
        nullable: true,
    })
    verifiedBy: string | null;

    @CreateDateColumn({ name: 'uploaded_at' })
    uploadedAt: Date;

    @UpdateDateColumn({ name: 'updated_at' })
    updatedAt: Date;
}
