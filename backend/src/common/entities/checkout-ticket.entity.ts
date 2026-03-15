import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { Account } from './account.entity';
import { Employee } from './employee.entity';
import { Product } from './product.entity';
import { Booking } from './booking.entity';

@Entity('checkout_tickets')
export class CheckoutTicket {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  @Column({ name: 'staff_id', type: 'uuid' })
  staffId: string;

  @Column({ name: 'product_id', type: 'uuid', nullable: true })
  productId: string | null;

  @Column({ name: 'start_time', type: 'timestamptz' })
  startTime: Date;

  @Index({ unique: true })
  @Column({ name: 'idempotency_key', length: 255, unique: true })
  idempotencyKey: string;

  @Index()
  @Column({ type: 'varchar', length: 30, default: CheckoutTicketStatus.QUEUED })
  status: CheckoutTicketStatus;

  @Column({ name: 'webhook_url', type: 'text', nullable: true })
  webhookUrl: string | null;

  @Column({ name: 'booking_id', type: 'uuid', nullable: true })
  bookingId: string | null;

  @Column({ name: 'error_message', type: 'text', nullable: true })
  errorMessage: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @ManyToOne(() => Employee, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'staff_id' })
  staff: Employee;

  @ManyToOne(() => Product, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'product_id' })
  product: Product | null;

  @OneToOne(() => Booking, { nullable: true })
  @JoinColumn({ name: 'booking_id' })
  booking: Booking | null;
}
