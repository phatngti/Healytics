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
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { Account } from './account.entity';
import { Booking } from './booking.entity';
import { PaymentTransactionLog } from './payment-transaction-log.entity';

/**
 * Records each payment attempt for a booking.
 *
 * One booking can have multiple payment attempts
 * (e.g., failed → retry, or partial deposit → full payment).
 */
@Entity('payments')
export class Payment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'booking_id', type: 'uuid' })
  bookingId: string;

  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ name: 'payment_method', type: 'varchar', length: 30 })
  paymentMethod: PaymentMethod;

  @Index()
  @Column({
    name: 'payment_status',
    type: 'varchar',
    length: 30,
    default: PaymentStatus.UNPAID,
  })
  paymentStatus: PaymentStatus;

  /** Amount in VND — decimal(15,2) per project convention */
  @Column({
    name: 'amount',
    type: 'decimal',
    precision: 15,
    scale: 2,
    default: 0,
  })
  amount: number;

  /** Gateway order ID (e.g., "BK-abcd1234_xyz12") */
  @Column({
    name: 'gateway_order_id',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  gatewayOrderId: string | null;

  /** Gateway transaction ID (MoMo transId — needed for refund) */
  @Column({
    name: 'gateway_trans_id',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  gatewayTransId: string | null;

  /** Payment URL (MoMo payUrl for redirect — shows QR on desktop) */
  @Column({ name: 'payment_url', type: 'text', nullable: true })
  paymentUrl: string | null;

  /** Deep link to open MoMo app directly on mobile */
  @Column({ name: 'payment_deeplink', type: 'text', nullable: true })
  paymentDeeplink: string | null;

  /** Gateway result code (0 = success) */
  @Column({ name: 'gateway_result_code', type: 'int', nullable: true })
  gatewayResultCode: number | null;

  /** Gateway message */
  @Column({ name: 'gateway_message', type: 'text', nullable: true })
  gatewayMessage: string | null;

  @Column({ name: 'paid_at', type: 'timestamptz', nullable: true })
  paidAt: Date | null;

  @Column({ name: 'refunded_at', type: 'timestamptz', nullable: true })
  refundedAt: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Booking, (booking) => booking.payments, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'booking_id' })
  booking: Booking;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @OneToMany(() => PaymentTransactionLog, (log) => log.payment, {
    cascade: true,
  })
  transactionLogs: PaymentTransactionLog[];
}
