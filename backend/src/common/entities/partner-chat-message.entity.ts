import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { MessageType } from '@/chat/enums/message-type.enum';
import { Account } from './account.entity';
import { PartnerConversation } from './partner-conversation.entity';
import { PartnerChatAttachment } from './partner-chat-attachment.entity';

/**
 * Individual chat message within a partner P2P conversation.
 * Supports text, image, file, and system message types.
 */
@Entity('partner_chat_messages')
@Index('IDX_PARTNER_MSG_CONV_CREATED', ['conversationId', 'createdAt'])
export class PartnerChatMessage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'conversation_id', type: 'uuid' })
  conversationId: string;

  @Index()
  @Column({ name: 'sender_id', type: 'uuid' })
  senderId: string;

  @Column({ type: 'text' })
  content: string;

  @Column({
    name: 'message_type',
    type: 'enum',
    enum: MessageType,
    default: MessageType.TEXT,
  })
  messageType: MessageType;

  /**
   * Client-generated ID for idempotent message delivery.
   * Prevents duplicate messages on retry / reconnect.
   */
  @Index()
  @Column({
    name: 'client_message_id',
    type: 'varchar',
    length: 100,
    nullable: true,
  })
  clientMessageId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => PartnerConversation, (c) => c.messages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'conversation_id' })
  conversation: PartnerConversation;

  @ManyToOne(() => Account, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'sender_id' })
  sender: Account;

  @OneToMany(() => PartnerChatAttachment, (a) => a.message, {
    cascade: true,
    eager: false,
  })
  attachments: PartnerChatAttachment[];
}
