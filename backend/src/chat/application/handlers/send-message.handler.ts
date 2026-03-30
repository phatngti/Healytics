import {
  Injectable,
  Logger,
  ForbiddenException,
} from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { ChatMessage } from '@/common/entities/chat-message.entity';
import { Conversation } from '@/common/entities/conversation.entity';
import { SendMessageDto } from '@/chat/dto/send-message.dto';
import { ChatMessageResponseDto } from '@/chat/dto/chat-message-response.dto';
import { MessageType } from '@/chat/enums/message-type.enum';

/**
 * Handler: Send a message in a conversation.
 *
 * Flow:
 * 1. Transaction start
 * 2. Verify sender is a participant of the conversation
 * 3. Check for duplicate clientMessageId (idempotency)
 * 4. Create ChatMessage entity
 * 5. Update Conversation denormalized fields (lastMessage, unreadCounts)
 * 6. Commit
 * 7. Reload message with sender relation for response
 */
@Injectable()
export class SendMessageHandler {
  private readonly logger = new Logger(SendMessageHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(dto: SendMessageDto, senderId: string): Promise<ChatMessageResponseDto> {
    this.logger.log(`Sending message in conversation ${dto.conversationId} from ${senderId}`);

    const queryRunner: QueryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Load conversation
      const conversation = await queryRunner.manager.findOne(Conversation, {
        where: { id: dto.conversationId },
      });

      if (!conversation) {
        throw new ForbiddenException('Conversation not found');
      }

      // 2. Verify sender is a participant
      const isUser = conversation.userId === senderId;
      const isPartner = conversation.partnerAccountId === senderId;
      if (!isUser && !isPartner) {
        throw new ForbiddenException('You are not a participant of this conversation');
      }

      // 3. Idempotency check — if clientMessageId already exists, return existing
      if (dto.clientMessageId) {
        const existing = await queryRunner.manager.findOne(ChatMessage, {
          where: {
            conversationId: dto.conversationId,
            clientMessageId: dto.clientMessageId,
          },
          relations: ['sender', 'sender.userProfile', 'attachments'],
        });
        if (existing) {
          this.logger.log(`Duplicate clientMessageId ${dto.clientMessageId} — returning existing`);
          await queryRunner.rollbackTransaction();
          return ChatMessageResponseDto.fromEntity(existing);
        }
      }

      // 4. Create message
      const message = queryRunner.manager.create(ChatMessage, {
        conversationId: dto.conversationId,
        senderId,
        content: dto.content,
        messageType: dto.messageType ?? MessageType.TEXT,
        clientMessageId: dto.clientMessageId ?? null,
      });
      const saved = await queryRunner.manager.save(ChatMessage, message);

      // 5. Update conversation denormalized fields
      const updateData: Partial<Conversation> = {
        lastMessageText: dto.content.substring(0, 200),
        lastMessageAt: saved.createdAt,
        lastMessageSenderId: senderId,
      };

      // Increment the OTHER party's unread count
      if (isUser) {
        await queryRunner.manager
          .createQueryBuilder()
          .update(Conversation)
          .set({
            lastMessageText: updateData.lastMessageText,
            lastMessageAt: updateData.lastMessageAt,
            lastMessageSenderId: updateData.lastMessageSenderId,
          })
          .where('id = :id', { id: conversation.id })
          .execute();

        await queryRunner.query(
          `UPDATE conversations SET partner_unread_count = partner_unread_count + 1 WHERE id = $1`,
          [conversation.id],
        );
      } else {
        await queryRunner.manager
          .createQueryBuilder()
          .update(Conversation)
          .set({
            lastMessageText: updateData.lastMessageText,
            lastMessageAt: updateData.lastMessageAt,
            lastMessageSenderId: updateData.lastMessageSenderId,
          })
          .where('id = :id', { id: conversation.id })
          .execute();

        await queryRunner.query(
          `UPDATE conversations SET user_unread_count = user_unread_count + 1 WHERE id = $1`,
          [conversation.id],
        );
      }

      // 6. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Message sent: ${saved.id}`);

      // 7. Reload with relations for response
      const fullMessage = await this.dataSource.manager.findOne(ChatMessage, {
        where: { id: saved.id },
        relations: ['sender', 'sender.userProfile', 'attachments'],
      });

      return ChatMessageResponseDto.fromEntity(fullMessage!);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Send message failed: ${(error as Error).message}`, (error as Error).stack);
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
