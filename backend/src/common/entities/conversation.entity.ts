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
  Unique,
} from 'typeorm';
import { ConversationStatus } from '@/chat/enums/conversation-status.enum';
import { Account } from './account.entity';
import { Booking } from './booking.entity';
import { ChatMessage } from './chat-message.entity';

/**
 * P2P conversation between a user (patient) and a partner account (health partner).
 * Optionally tied to a booking for contextual discussions.
 */
@Entity('conversations')
@Unique('UQ_CONVERSATION_USER_PARTNER', ['userId', 'partnerAccountId'])
export class Conversation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  /** The patient / end-user side of the conversation */
  @Index()
  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  /** The health-partner account side of the conversation */
  @Index()
  @Column({ name: 'partner_account_id', type: 'uuid' })
  partnerAccountId: string;

  /** Optional booking context — nullable for free-form chats */
  @Index()
  @Column({ name: 'booking_id', type: 'uuid', nullable: true })
  bookingId: string | null;

  @Column({
    type: 'enum',
    enum: ConversationStatus,
    default: ConversationStatus.ACTIVE,
  })
  status: ConversationStatus;

  /** Denormalized for fast conversation-list queries */
  @Column({ name: 'last_message_text', type: 'text', nullable: true })
  lastMessageText: string | null;

  @Column({ name: 'last_message_at', type: 'timestamptz', nullable: true })
  lastMessageAt: Date | null;

  @Column({ name: 'last_message_sender_id', type: 'uuid', nullable: true })
  lastMessageSenderId: string | null;

  /** Unread count for the user side */
  @Column({ name: 'user_unread_count', type: 'int', default: 0 })
  userUnreadCount: number;

  /** Unread count for the partner side */
  @Column({ name: 'partner_unread_count', type: 'int', default: 0 })
  partnerUnreadCount: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: Account;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_account_id' })
  partnerAccount: Account;

  @ManyToOne(() => Booking, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'booking_id' })
  booking: Booking | null;

  @OneToMany(() => ChatMessage, (m) => m.conversation)
  messages: ChatMessage[];
}
