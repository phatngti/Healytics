import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { Account } from './account.entity';
import { AiChatMessage } from './chat-message.entity';

/**
 * AI chatbot conversation.
 * Simple conversation container for Dr. AI chat sessions.
 * Maps to the original `conversations` table.
 */
@Entity('conversations')
export class AiConversation {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index('IDX_CONVERSATIONS_USER_ID')
  @Column({ name: 'user_id', type: 'varchar', nullable: true })
  userId: string | null;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => Account, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'user_id' })
  user: Account | null;

  @OneToMany(() => AiChatMessage, (m) => m.conversation)
  messages: AiChatMessage[];
}
