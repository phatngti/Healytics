import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import {
  AdminFinanceExportStatus,
  AdminFinanceExportType,
} from '@/admin/finance/dto/admin-finance.enums';

@Entity('admin_finance_export_jobs')
export class AdminFinanceExportJob {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'type', type: 'varchar', length: 40 })
  type: AdminFinanceExportType;

  @Column({ name: 'requested_by_account_id', type: 'uuid', nullable: true })
  requestedByAccountId: string | null;

  @Column({
    name: 'requested_by_name',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  requestedByName: string | null;

  @Column({
    name: 'status',
    type: 'varchar',
    length: 30,
    default: AdminFinanceExportStatus.QUEUED,
  })
  status: AdminFinanceExportStatus;

  @Column({ name: 'row_count', type: 'integer', default: 0 })
  rowCount: number;

  @Column({ name: 'download_url', type: 'text', nullable: true })
  downloadUrl: string | null;

  @Column({ name: 'expires_at', type: 'timestamptz', nullable: true })
  expiresAt: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}
