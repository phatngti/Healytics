import { Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { PartnerChatMessage } from '@/common/entities/partner-chat-message.entity';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
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
    @InjectRepository(PartnerChatMessage)
    private readonly messageRepo: Repository<PartnerChatMessage>,
    @InjectRepository(PartnerConversation)
    private readonly conversationRepo: Repository<PartnerConversation>,
  ) {}

  async execute(
    conversationId: string,
    requesterId: string,
    query: MessagesQueryDto,
  ): Promise<{
    messages: ChatMessageResponseDto[];
    hasMore: boolean;
    nextCursor: string | null;
  }> {
    // 1. Verify requester is a participant
    const conversation = await this.conversationRepo.findOne({
      where: { id: conversationId },
    });

    if (!conversation) {
      throw new ForbiddenException('Conversation not found');
    }

    if (
      conversation.userId !== requesterId &&
      conversation.partnerAccountId !== requesterId
    ) {
      throw new ForbiddenException(
        'You are not a participant of this conversation',
      );
    }

    // 2. Build cursor-based query
    const limit = query.limit ?? 50;

    const qb = this.messageRepo
      .createQueryBuilder('msg')
      .leftJoinAndSelect('msg.sender', 'sender')
      .leftJoinAndSelect('sender.userProfile', 'senderProfile')
      .leftJoinAndSelect('msg.attachments', 'attachments')
      .where('msg.conversationId = :conversationId', { conversationId })
      .orderBy('msg.createdAt', 'DESC')
      .take(limit + 1); // Fetch one extra to detect hasMore

    // Apply cursor if provided — resolve cursor ID to timestamp for indexed scan
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

    // 3. Detect hasMore and compute nextCursor
    const hasMore = messages.length > limit;
    if (hasMore) {
      messages.pop(); // Remove the extra item
    }

    // nextCursor = ID of the oldest message in this page (last element)
    const nextCursor =
      hasMore && messages.length > 0 ? messages[messages.length - 1].id : null;

    this.logger.log(
      `Fetched ${messages.length} messages for conversation ${conversationId} (hasMore: ${hasMore}, nextCursor: ${nextCursor ?? 'none'})`,
    );

    // Return messages in chronological order (ASC) so clients
    // can render directly without reversing.
    // The query uses DESC internally for cursor-based "fetch older"
    // to work with the composite index.
    messages.reverse();

    return {
      messages: ChatMessageResponseDto.fromEntities(messages),
      hasMore,
      nextCursor,
    };
  }
}
