import { Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { ChatMessage } from '@/common/entities/chat-message.entity';
import { Conversation } from '@/common/entities/conversation.entity';
import { MessagesQueryDto } from '@/chat/dto/messages-query.dto';
import { ChatMessageResponseDto } from '@/chat/dto/chat-message-response.dto';

/**
 * Handler: Get paginated message history for a conversation.
 *
 * Uses cursor-based pagination (beforeId) for efficient scrolling.
 */
@Injectable()
export class GetConversationMessagesHandler {
  private readonly logger = new Logger(GetConversationMessagesHandler.name);

  constructor(
    @InjectRepository(ChatMessage)
    private readonly messageRepo: Repository<ChatMessage>,
    @InjectRepository(Conversation)
    private readonly conversationRepo: Repository<Conversation>,
  ) {}

  async execute(
    conversationId: string,
    requesterId: string,
    query: MessagesQueryDto,
  ): Promise<{ messages: ChatMessageResponseDto[]; hasMore: boolean }> {
    // 1. Verify requester is a participant
    const conversation = await this.conversationRepo.findOne({
      where: { id: conversationId },
    });

    if (!conversation) {
      throw new ForbiddenException('Conversation not found');
    }

    if (conversation.userId !== requesterId && conversation.partnerAccountId !== requesterId) {
      throw new ForbiddenException('You are not a participant of this conversation');
    }

    // 2. Build cursor-based query
    const limit = query.limit ?? 20;

    const qb = this.messageRepo
      .createQueryBuilder('msg')
      .leftJoinAndSelect('msg.sender', 'sender')
      .leftJoinAndSelect('sender.userProfile', 'senderProfile')
      .leftJoinAndSelect('msg.attachments', 'attachments')
      .where('msg.conversationId = :conversationId', { conversationId })
      .orderBy('msg.createdAt', 'DESC')
      .take(limit + 1); // Fetch one extra to detect hasMore

    // Apply cursor if provided
    if (query.beforeId) {
      const cursorMessage = await this.messageRepo.findOne({
        where: { id: query.beforeId },
        select: ['createdAt'],
      });
      if (cursorMessage) {
        qb.andWhere('msg.createdAt < :cursorDate', {
          cursorDate: cursorMessage.createdAt,
        });
      }
    }

    const messages = await qb.getMany();

    // 3. Detect hasMore
    const hasMore = messages.length > limit;
    if (hasMore) {
      messages.pop(); // Remove the extra item
    }

    this.logger.log(
      `Fetched ${messages.length} messages for conversation ${conversationId} (hasMore: ${hasMore})`,
    );

    return {
      messages: ChatMessageResponseDto.fromEntities(messages),
      hasMore,
    };
  }
}
