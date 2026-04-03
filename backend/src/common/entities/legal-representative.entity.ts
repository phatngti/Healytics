import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { Partner } from './partner.entity';
import { IdType } from '@/partners/enum/id-type.enum';

/**
 * Legal Representative entity.
 * Document-related fields (id_front_img_url, id_back_img_url, is_authorized_user,
 * auth_letter_doc_url) have been migrated to the partner_document table.
 * @see migrations/scripts/1769427340000-RefactorLegalRepDocumentColumns.ts
 */
@Entity('health_partner_legal_representative')
export class LegalRepresentative {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'full_name', length: 150 })
  fullName: string;

  @Column({ length: 100 })
  position: string;

  @Column({
    name: 'id_type',
    type: 'enum',
    enum: IdType,
  })
  idType: IdType;

  @Column({ name: 'id_number', length: 20 })
  idNumber: string;

  @Column({ name: 'id_issue_date', type: 'date' })
  idIssueDate: Date;

  @Column({ name: 'phone_number', type: 'varchar', length: 20, nullable: true })
  phoneNumber: string | null;

  // Relationship to Partner
  @Column({ name: 'partner_id' })
  partnerId: string;

  @OneToOne(() => Partner, (entity) => entity.legalRepresentative)
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;
}
