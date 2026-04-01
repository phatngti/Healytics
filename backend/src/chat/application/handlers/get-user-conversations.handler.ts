import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { ConversationResponseDto } from '@/chat/dto/conversation-response.dto';

/**
 * Handler: Get all conversations for a user (patient).
 *
 * Returns conversations ordered by lastMessageAt DESC with
 * other-participant info and unread counts.
 */
@Injectable()
export class GetUserConversationsHandler {
  private readonly logger = new Logger(GetUserConversationsHandler.name);

  constructor(
    @InjectRepository(PartnerConversation)
    private readonly conversationRepo: Repository<PartnerConversation>,
  ) {}

  async execute(userId: string): Promise<ConversationResponseDto[]> {
    const conversations = await this.conversationRepo.find({
      where: { userId },
      relations: [
        'user',
        'user.userProfile',
        'partnerAccount',
        'partnerAccount.userProfile',
      ],
      order: { lastMessageAt: { direction: 'DESC', nulls: 'LAST' } },
    });

    this.logger.log(
      `Fetched ${conversations.length} conversations for user ${userId}`,
    );
    return ConversationResponseDto.fromEntities(conversations, userId);
  }
}
