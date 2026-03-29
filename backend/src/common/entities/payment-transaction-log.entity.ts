import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Payment } from './payment.entity';

/**
 * Immutable audit trail for every payment gateway interaction.
 *
 * Append-only — no update/delete columns by design.
 * Records IPN callbacks, refund requests, signature verifications, etc.
 */
@Entity('payment_transaction_logs')
export class PaymentTransactionLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'payment_id', type: 'uuid' })
  paymentId: string;

  /**
   * Action type: CREATE_PAYMENT, IPN_RECEIVED, IPN_VERIFIED,
   * IPN_REJECTED, REFUND_REQUESTED, REFUND_CONFIRMED
   */
  @Index()
  @Column({ name: 'action', type: 'varchar', length: 50 })
  action: string;

  /** Gateway name: MOMO, VNPAY, etc. */
  @Column({ name: 'gateway', type: 'varchar', length: 30 })
  gateway: string;

  /** Gateway result code */
  @Column({ name: 'result_code', type: 'int', nullable: true })
  resultCode: number | null;

  /** Gateway message */
  @Column({ name: 'message', type: 'text', nullable: true })
  message: string | null;

  /** Full request payload (JSONB for queryability) */
  @Column({ name: 'request_payload', type: 'jsonb', nullable: true })
  requestPayload: Record<string, unknown> | null;

  /** Full response payload (JSONB for queryability) */
  @Column({ name: 'response_payload', type: 'jsonb', nullable: true })
  responsePayload: Record<string, unknown> | null;

  /** IP address (IPN source verification) */
  @Column({ name: 'ip_address', type: 'varchar', length: 45, nullable: true })
  ipAddress: string | null;

  /** Actor: user UUID or 'system' for IPN */
  @Column({ name: 'actor', type: 'varchar', length: 255, nullable: true })
  actor: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Payment, (payment) => payment.transactionLogs, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'payment_id' })
  payment: Payment;
}
