import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { PartnerChatMessage } from './partner-chat-message.entity';

/**
 * File or image attachment linked to a partner chat message.
 */
@Entity('partner_chat_attachments')
export class PartnerChatAttachment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'message_id', type: 'uuid' })
  messageId: string;

  @Column({ name: 'file_url', type: 'text' })
  fileUrl: string;

  @Column({ name: 'file_name', type: 'varchar', length: 255 })
  fileName: string;

  @Column({ name: 'file_type', type: 'varchar', length: 100 })
  fileType: string;

  @Column({ name: 'file_size', type: 'int' })
  fileSize: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  // ── Relations ────────────────────────────────────────────────

  @ManyToOne(() => PartnerChatMessage, (m) => m.attachments, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'message_id' })
  message: PartnerChatMessage;
}
