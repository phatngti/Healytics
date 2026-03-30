import { Injectable, Logger, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Conversation } from '@/common/entities/conversation.entity';

/**
 * Handler: Mark all messages in a conversation as read for the requester.
 *
 * Resets the unread count for the viewer's side of the conversation.
 */
@Injectable()
export class MarkMessagesReadHandler {
  private readonly logger = new Logger(MarkMessagesReadHandler.name);

  constructor(
    @InjectRepository(Conversation)
    private readonly conversationRepo: Repository<Conversation>,
  ) {}

  async execute(conversationId: string, requesterId: string): Promise<void> {
    const conversation = await this.conversationRepo.findOne({
      where: { id: conversationId },
    });

    if (!conversation) {
      throw new ForbiddenException('Conversation not found');
    }

    const isUser = conversation.userId === requesterId;
    const isPartner = conversation.partnerAccountId === requesterId;

    if (!isUser && !isPartner) {
      throw new ForbiddenException('You are not a participant of this conversation');
    }

    // Reset the viewer's unread count
    if (isUser) {
      await this.conversationRepo.update(conversationId, { userUnreadCount: 0 });
    } else {
      await this.conversationRepo.update(conversationId, { partnerUnreadCount: 0 });
    }

    this.logger.log(
      `Marked messages read: conversation=${conversationId}, reader=${requesterId} (${isUser ? 'user' : 'partner'})`,
    );
  }
}
