import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { DocumentType } from '@/partners/enum/document-type.enum';

/**
 * Maps business types to their required document types.
 * Used to validate which documents partners must upload based on their business category.
 */
@Entity('health_partner_document_requirement')
export class DocumentRequirement {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    name: 'business_type',
    type: 'enum',
    enum: BusinessType,
  })
  businessType: BusinessType;

  @Column({
    name: 'document_type',
    type: 'enum',
    enum: DocumentType,
  })
  documentType: DocumentType;

  @Column({ name: 'is_required', default: true })
  isRequired: boolean;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ name: 'display_order', default: 0 })
  displayOrder: number; // For frontend ordering
}
