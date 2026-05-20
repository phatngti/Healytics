import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Partner } from './partner.entity';
import { PartnerLedgerTransaction } from './partner-ledger-transaction.entity';
import { PartnerRefundCaseType } from '@/partner-finance/enums/partner-refund-case-type.enum';
import { PartnerRefundCaseStatus } from '@/partner-finance/enums/partner-refund-case-status.enum';

/**
 * Refund or dispute case linked to a partner ledger transaction.
 *
 * Tracks the lifecycle from customer request through partner
 * approval or rejection, including SLA deadlines.
 */
@Entity('partner_refund_cases')
@Index('IDX_PRC_PARTNER_REQUESTED', ['partnerId', 'requestedAt'])
export class PartnerRefundCase {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Index()
  @Column({ name: 'transaction_id', type: 'uuid' })
  transactionId: string;

  @Column({ name: 'case_type', type: 'varchar', length: 30 })
  caseType: PartnerRefundCaseType;

  @Column({ name: 'requested_at', type: 'timestamptz' })
  requestedAt: Date;

  @Column({
    name: 'amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  amount: number;

  @Column({ name: 'currency', type: 'varchar', length: 10, default: 'VND' })
  currency: string;

  @Column({ name: 'reason', type: 'text', nullable: true })
  reason: string | null;

  @Column({ name: 'owner', type: 'varchar', length: 255 })
  owner: string;

  @Column({ name: 'status', type: 'varchar', length: 30 })
  status: PartnerRefundCaseStatus;

  @Column({ name: 'sla_due_at', type: 'timestamptz', nullable: true })
  slaDueAt: Date | null;

  @Column({ name: 'customer_request', type: 'text', nullable: true })
  customerRequest: string | null;

  @Column({ name: 'partner_response', type: 'text', nullable: true })
  partnerResponse: string | null;

  @Column({
    name: 'evidence_links',
    type: 'jsonb',
    default: () => "'[]'::jsonb",
  })
  evidenceLinks: string[];

  @Column({ name: 'decision_note', type: 'text', nullable: true })
  decisionNote: string | null;

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

  @ManyToOne(() => PartnerLedgerTransaction, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'transaction_id' })
  transaction: PartnerLedgerTransaction;
}
