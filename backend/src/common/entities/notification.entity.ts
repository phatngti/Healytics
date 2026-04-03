import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { Account } from './account.entity';

/**
 * Core notification entity.
 *
 * - **Targeted notifications**: `recipientId` is set to a specific user UUID.
 * - **System broadcasts**: `recipientId` is NULL and `isBroadcast` is true.
 *   Read tracking for broadcasts is handled by the `NotificationRead` entity.
 */
@Entity('notifications')
@Index('IDX_NOTIF_RECIPIENT_READ_CREATED', [
  'recipientId',
  'isRead',
  'createdAt',
])
@Index('IDX_NOTIF_TYPE_CREATED', ['type', 'createdAt'])
@Index('IDX_NOTIF_BROADCAST_CREATED', ['isBroadcast', 'createdAt'])
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  /**
   * NULL for system-wide broadcasts (all users).
   * Set to a specific account UUID for targeted notifications.
   */
  @Column({ name: 'recipient_id', type: 'uuid', nullable: true })
  @Index()
  recipientId: string | null;

  @Column({
    type: 'enum',
    enum: NotificationType,
  })
  type: NotificationType;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  body: string;

  /**
   * Deep-link data for frontend routing.
   * Example: { bookingId: 'uuid', action: 'view_booking' }
   */
  @Column({ type: 'jsonb', nullable: true })
  data: Record<string, any> | null;

  /**
   * For targeted notifications only.
   * Broadcasts use the `notification_reads` table for per-user tracking.
   */
  @Column({ name: 'is_read', type: 'boolean', default: false })
  isRead: boolean;

  @Column({ name: 'read_at', type: 'timestamptz', nullable: true })
  readAt: Date | null;

  /** True for system-wide broadcasts */
  @Column({ name: 'is_broadcast', type: 'boolean', default: false })
  isBroadcast: boolean;

  /** Admin who sent the broadcast (NULL for event-triggered notifications) */
  @Column({ name: 'sender_id', type: 'uuid', nullable: true })
  senderId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'recipient_id' })
  recipient: Account | null;

  @ManyToOne(() => Account, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'sender_id' })
  sender: Account | null;
}
