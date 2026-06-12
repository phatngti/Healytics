import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { Partner } from './partner.entity';
import { PartnerTransactionTimeline } from './partner-transaction-timeline.entity';
import { PartnerTransactionType } from '@/partner-finance/enums/partner-transaction-type.enum';
import { PartnerCommerceSourceType } from '@/partner-finance/enums/partner-commerce-source-type.enum';
import { PartnerTransactionStatus } from '@/partner-finance/enums/partner-transaction-status.enum';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import { PartnerPayoutStatus } from '@/partner-finance/enums/partner-payout-status.enum';

/**
 * Core ledger entity for partner-scoped financial transactions.
 *
 * Records charges, refunds, adjustments, payouts, and fees
 * linked to a partner's commerce activity (bookings, orders).
 */
@Entity('partner_ledger_transactions')
@Index('IDX_PLT_PARTNER_CREATED', ['partnerId', 'createdAt'])
@Index('IDX_PLT_PARTNER_STATUS_CREATED', ['partnerId', 'status', 'createdAt'])
@Index('IDX_PLT_PARTNER_SETTLEMENT_CREATED', [
  'partnerId',
  'settlementStatus',
  'createdAt',
])
@Index('IDX_PLT_PARTNER_PAYOUT_STATUS_CREATED', [
  'partnerId',
  'payoutStatus',
  'createdAt',
])
@Index('IDX_PLT_PARTNER_SOURCE_TYPE_CREATED', [
  'partnerId',
  'sourceType',
  'createdAt',
])
@Index('IDX_PLT_PARTNER_REFERENCE', ['partnerId', 'reference'])
export class PartnerLedgerTransaction {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'type', type: 'varchar', length: 30 })
  type: PartnerTransactionType;

  @Column({ name: 'source_type', type: 'varchar', length: 30 })
  sourceType: PartnerCommerceSourceType;

  @Column({ name: 'source_id', type: 'uuid', nullable: true })
  sourceId: string | null;

  @Column({ name: 'reference', type: 'varchar', length: 100 })
  reference: string;

  @Column({ name: 'customer_name_snapshot', type: 'varchar', length: 255 })
  customerNameSnapshot: string;

  @Column({
    name: 'gross_amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  grossAmount: number;

  @Column({
    name: 'fee_amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  feeAmount: number;

  @Column({ name: 'currency', type: 'varchar', length: 10, default: 'VND' })
  currency: string;

  @Column({ name: 'status', type: 'varchar', length: 30 })
  status: PartnerTransactionStatus;

  @Column({ name: 'settlement_status', type: 'varchar', length: 30 })
  settlementStatus: PartnerSettlementStatus;

  @Column({ name: 'payout_status', type: 'varchar', length: 30 })
  payoutStatus: PartnerPayoutStatus;

  @Column({
    name: 'payment_method_label',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  paymentMethodLabel: string | null;

  @Column({
    name: 'source_title_snapshot',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  sourceTitleSnapshot: string | null;

  @Column({
    name: 'source_subtitle_snapshot',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  sourceSubtitleSnapshot: string | null;

  @Column({ name: 'flagged_for_review', type: 'boolean', default: false })
  flaggedForReview: boolean;

  @Column({ name: 'notes', type: 'text', nullable: true })
  notes: string | null;

  @Index()
  @Column({ name: 'payout_id', type: 'uuid', nullable: true })
  payoutId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;

  @OneToMany(() => PartnerTransactionTimeline, (event) => event.transaction, {
    cascade: true,
  })
  timelineEvents: PartnerTransactionTimeline[];
}
