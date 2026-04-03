import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { Notification } from './notification.entity';
import { Account } from './account.entity';

/**
 * Tracks per-user read status for broadcast notifications.
 *
 * Instead of creating N notification rows for N users,
 * broadcasts are stored as a single row in `notifications`
 * and this table tracks which users have read them.
 */
@Entity('notification_reads')
@Unique('UQ_NOTIF_READ', ['notificationId', 'userId'])
export class NotificationRead {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'notification_id', type: 'uuid' })
  @Index()
  notificationId: string;

  @Column({ name: 'user_id', type: 'uuid' })
  @Index()
  userId: string;

  @CreateDateColumn({ name: 'read_at', type: 'timestamptz' })
  readAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Notification, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'notification_id' })
  notification: Notification;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;
}
