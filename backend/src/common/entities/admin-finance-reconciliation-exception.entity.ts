import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import {
  AdminFinanceProvider,
  AdminFinanceReconciliationStatus,
  AdminFinanceReconciliationType,
} from '@/admin/finance/dto/admin-finance.enums';
import { PartnerLedgerTransaction } from './partner-ledger-transaction.entity';

@Entity('admin_finance_reconciliation_exceptions')
@Index('IDX_AFRE_STATUS_DETECTED', ['status', 'detectedAt'])
@Index('IDX_AFRE_PROVIDER_EVENT', ['provider', 'providerEventId'])
export class AdminFinanceReconciliationException {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'detected_at', type: 'timestamptz' })
  detectedAt: Date;

  @Column({ name: 'provider', type: 'varchar', length: 30 })
  provider: AdminFinanceProvider;

  @Column({ name: 'provider_event_id', type: 'varchar', length: 150 })
  providerEventId: string;

  @Index()
  @Column({ name: 'related_transaction_id', type: 'uuid', nullable: true })
  relatedTransactionId: string | null;

  @Column({
    name: 'expected_amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  expectedAmount: number;

  @Column({
    name: 'provider_amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  providerAmount: number;

  @Column({
    name: 'difference',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  difference: number;

  @Column({ name: 'currency', type: 'varchar', length: 10, default: 'VND' })
  currency: string;

  @Column({ name: 'type', type: 'varchar', length: 50 })
  type: AdminFinanceReconciliationType;

  @Column({
    name: 'status',
    type: 'varchar',
    length: 30,
    default: AdminFinanceReconciliationStatus.OPEN,
  })
  status: AdminFinanceReconciliationStatus;

  @Column({ name: 'owner', type: 'varchar', length: 255 })
  owner: string;

  @Column({ name: 'summary', type: 'text' })
  summary: string;

  @Column({ name: 'provider_event_context', type: 'text', nullable: true })
  providerEventContext: string | null;

  @Column({ name: 'ledger_context', type: 'text', nullable: true })
  ledgerContext: string | null;

  @Column({ name: 'resolution_notes', type: 'text', nullable: true })
  resolutionNotes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  @ManyToOne(() => PartnerLedgerTransaction, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'related_transaction_id' })
  relatedTransaction: PartnerLedgerTransaction | null;
}
