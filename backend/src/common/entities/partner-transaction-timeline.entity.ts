import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { PartnerLedgerTransaction } from './partner-ledger-transaction.entity';

/**
 * Immutable timeline event attached to a partner ledger transaction.
 *
 * Records payment capture, authorization, failure, refund request,
 * settlement scheduling, payout assignment, review flag, and
 * manual finance actions.
 */
@Entity('partner_transaction_timeline_events')
export class PartnerTransactionTimeline {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'transaction_id', type: 'uuid' })
  transactionId: string;

  @Index()
  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'title', type: 'varchar', length: 255 })
  title: string;

  @Column({ name: 'description', type: 'text', nullable: true })
  description: string | null;

  @Column({ name: 'occurred_at', type: 'timestamptz' })
  occurredAt: Date;

  @Column({ name: 'actor_account_id', type: 'uuid', nullable: true })
  actorAccountId: string | null;

  @Column({ name: 'metadata', type: 'jsonb', nullable: true })
  metadata: Record<string, unknown> | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => PartnerLedgerTransaction, (txn) => txn.timelineEvents, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'transaction_id' })
  transaction: PartnerLedgerTransaction;
}
