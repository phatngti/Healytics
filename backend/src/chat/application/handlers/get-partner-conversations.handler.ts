import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Conversation } from '@/common/entities/conversation.entity';
import { ConversationResponseDto } from '@/chat/dto/conversation-response.dto';

/**
 * Handler: Get all conversations for a health partner account.
 *
 * Returns conversations ordered by lastMessageAt DESC with
 * user info and unread counts.
 */
@Injectable()
export class GetPartnerConversationsHandler {
  private readonly logger = new Logger(GetPartnerConversationsHandler.name);

  constructor(
    @InjectRepository(Conversation)
    private readonly conversationRepo: Repository<Conversation>,
  ) {}

  async execute(partnerAccountId: string): Promise<ConversationResponseDto[]> {
    const conversations = await this.conversationRepo.find({
      where: { partnerAccountId },
      relations: [
        'user',
        'user.userProfile',
        'partnerAccount',
        'partnerAccount.userProfile',
      ],
      order: { lastMessageAt: { direction: 'DESC', nulls: 'LAST' } },
    });

    this.logger.log(`Fetched ${conversations.length} conversations for partner ${partnerAccountId}`);
    return ConversationResponseDto.fromEntities(conversations, partnerAccountId);
  }
}
