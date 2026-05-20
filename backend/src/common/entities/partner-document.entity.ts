import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  JoinColumn,
  Index,
} from 'typeorm';
import { Partner } from './partner.entity';

/**
 * Partner document statuses (stored as text in DB)
 */
export const PartnerDocumentStatuses = {
  ACCEPTED: 'accepted',
  REJECTED: 'rejected',
} as const;

export type PartnerDocumentStatus =
  (typeof PartnerDocumentStatuses)[keyof typeof PartnerDocumentStatuses];

/**
 * Document file types (stored as text in DB)
 */
export const DocumentFileTypes = {
  IMAGE: 'image',
  PDF: 'pdf',
  TXT: 'txt',
  DOC: 'doc',
  OTHER: 'other',
} as const;

export type DocumentFileType =
  (typeof DocumentFileTypes)[keyof typeof DocumentFileTypes];

/**
 * Document types/categories (stored as text in DB)
 * e.g., IDENTITY_FRONT, BUSINESS_LICENSE, etc.
 */
export const DocumentTypes = {
  IDENTITY_FRONT: 'IDENTITY_FRONT',
  IDENTITY_BACK: 'IDENTITY_BACK',
  BUSINESS_LICENSE: 'BUSINESS_LICENSE',
  AUTHORIZATION_LETTER: 'AUTHORIZATION_LETTER',
  ANTT: 'ANTT',
  KCB_LICENSE: 'KCB_LICENSE',
  GCN_FITNESS: 'GCN_FITNESS',
  GPP: 'GPP',
  RHM_LICENSE: 'RHM_LICENSE',
  MEDICAL_WASTE_CONTRACT: 'MEDICAL_WASTE_CONTRACT',
  YHCT_LICENSE: 'YHCT_LICENSE',
  PSYCHOLOGY_LICENSE: 'PSYCHOLOGY_LICENSE',
  DERMATOLOGY_LICENSE: 'DERMATOLOGY_LICENSE',
  TECHNICAL_PORTFOLIO: 'TECHNICAL_PORTFOLIO',
  NUTRITION_LICENSE: 'NUTRITION_LICENSE',
  PSYCHIATRY_LICENSE: 'PSYCHIATRY_LICENSE',
  OTHER_DOCUMENTS: 'OTHER_DOCUMENTS',
} as const;

export type DocumentTypeValue =
  (typeof DocumentTypes)[keyof typeof DocumentTypes];

/**
 * Tracks documents uploaded by partners for verification.
 * Uses TEXT columns for type and status for flexibility.
 */
@Entity('health_partner_document')
export class PartnerDocument {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'partner_id' })
  @Index('IDX_partner_document_partner_id')
  partnerId: string;

  @ManyToOne(() => Partner, (partner) => partner.documents, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;

  /** Storage key (R2/S3 path) */
  @Column({ name: 'document_key', type: 'text' })
  documentKey: string;

  /** Public URL to access the document */
  @Column({ name: 'file_url', type: 'text', nullable: true })
  fileUrl: string | null;

  /** Document category: IDENTITY_FRONT, BUSINESS_LICENSE, etc. */
  @Column({ name: 'type', type: 'text' })
  type: DocumentTypeValue;

  /** File type: image, pdf, txt, etc. */
  @Column({ name: 'file_type', type: 'text', default: DocumentFileTypes.IMAGE })
  fileType: DocumentFileType;

  /** Document status: pending, accepted, rejected */
  @Column({ type: 'text', default: PartnerDocumentStatuses.ACCEPTED })
  status: PartnerDocumentStatus;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;
}
