import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { AiConversation } from './conversation.entity';

/**
 * Individual message within an AI chatbot conversation.
 * Role is either 'user' or 'assistant'.
 * Maps to the original `messages` table.
 */
@Entity('messages')
export class AiChatMessage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index('IDX_MESSAGES_CONVERSATION_ID')
  @Column({ name: 'conversation_id', type: 'uuid' })
  conversationId: string;

  /** 'user' or 'assistant' */
  @Column({ type: 'varchar', length: 20 })
  role: string;

  @Column({ type: 'text' })
  content: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => AiConversation, (c) => c.messages, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'conversation_id' })
  conversation: AiConversation;
}
