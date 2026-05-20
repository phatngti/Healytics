import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { AdminFinanceNoteEntityType } from '@/admin/finance/dto/admin-finance.enums';

@Entity('admin_finance_notes')
@Index('IDX_AFN_ENTITY', ['entityType', 'entityId'])
export class AdminFinanceNote {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'entity_type', type: 'varchar', length: 40 })
  entityType: AdminFinanceNoteEntityType;

  @Column({ name: 'entity_id', type: 'uuid' })
  entityId: string;

  @Column({ name: 'content', type: 'text' })
  content: string;

  @Column({ name: 'created_by_account_id', type: 'uuid', nullable: true })
  createdByAccountId: string | null;

  @Column({
    name: 'created_by_name',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  createdByName: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}
