import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { DevicePlatform } from '@/notification/enums/device-platform.enum';
import { Account } from './account.entity';

/**
 * Stores device tokens for push notification delivery (FCM / APNs).
 * Users register their device token on login; unregister on logout or uninstall.
 */
@Entity('device_tokens')
@Unique('UQ_DEVICE_TOKEN', ['token'])
export class DeviceToken {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid' })
  @Index()
  userId: string;

  @Column({ type: 'text' })
  token: string;

  @Column({
    type: 'enum',
    enum: DevicePlatform,
  })
  platform: DevicePlatform;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;
}
