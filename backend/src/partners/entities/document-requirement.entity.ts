import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';
import { BusinessType } from '../enum/business-type.enum';
import { DocumentType } from '../enum/document-type.enum';

/**
 * Maps business types to their required document types.
 * Used to validate which documents partners must upload based on their business category.
 */
@Entity('document_requirement')
export class DocumentRequirement {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({
        type: 'enum',
        enum: BusinessType,
    })
    businessType: BusinessType;

    @Column({
        type: 'enum',
        enum: DocumentType,
    })
    documentType: DocumentType;

    @Column({ default: true })
    isRequired: boolean;

    @Column({ type: 'text', nullable: true })
    description: string;

    @Column({ default: 0 })
    displayOrder: number; // For frontend ordering
}
