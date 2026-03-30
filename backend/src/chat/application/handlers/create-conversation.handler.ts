import {
  Injectable,
  Logger,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Conversation } from '@/common/entities/conversation.entity';
import { ChatMessage } from '@/common/entities/chat-message.entity';
import { ConversationStatus } from '@/chat/enums/conversation-status.enum';
import { MessageType } from '@/chat/enums/message-type.enum';
import { CreateConversationDto } from '@/chat/dto/create-conversation.dto';
import { ConversationResponseDto } from '@/chat/dto/conversation-response.dto';
import { Role } from '@/account/enum/role.enum';

/**
 * Handler: Create a new P2P conversation.
 *
 * Flow:
 * 1. Transaction start
 * 2. Validate participant exists
 * 3. Determine user/partner roles from accounts
 * 4. Check for existing active conversation (reuse if exists)
 * 5. Create Conversation
 * 6. Optionally create initial message
 * 7. Commit
 */
@Injectable()
export class CreateConversationHandler {
  private readonly logger = new Logger(CreateConversationHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    dto: CreateConversationDto,
    initiatorAccountId: string,
  ): Promise<ConversationResponseDto> {
    this.logger.log(
      `Creating conversation: initiator=${initiatorAccountId}, participant=${dto.participantAccountId}`,
    );

    const queryRunner: QueryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Load both accounts
      const initiator = await queryRunner.manager.findOne(Account, {
        where: { id: initiatorAccountId },
        relations: ['userProfile'],
      });
      const participant = await queryRunner.manager.findOne(Account, {
        where: { id: dto.participantAccountId },
        relations: ['userProfile'],
      });

      if (!initiator) throw new NotFoundException('Initiator account not found');
      if (!participant) throw new NotFoundException('Participant account not found');

      // 2. Determine user vs partner
      // The "user" in the conversation is always the one with Role.USER
      let userId: string;
      let partnerAccountId: string;

      if (initiator.role === Role.USER && [Role.HEALTH_PARTNER, Role.EMPLOYEE].includes(participant.role)) {
        userId = initiator.id;
        partnerAccountId = participant.id;
      } else if ([Role.HEALTH_PARTNER, Role.EMPLOYEE].includes(initiator.role) && participant.role === Role.USER) {
        userId = participant.id;
        partnerAccountId = initiator.id;
      } else {
        throw new ConflictException(
          'Conversations can only be created between a USER and a HEALTH_PARTNER/EMPLOYEE',
        );
      }

      // 3. Check for existing active conversation
      let conversation = await queryRunner.manager.findOne(Conversation, {
        where: { userId, partnerAccountId },
        relations: ['user', 'user.userProfile', 'partnerAccount', 'partnerAccount.userProfile'],
      });

      if (conversation && conversation.status === ConversationStatus.ACTIVE) {
        this.logger.log(`Reusing existing conversation: ${conversation.id}`);
        await queryRunner.rollbackTransaction();
        return ConversationResponseDto.fromEntity(conversation, initiatorAccountId);
      }

      // If conversation exists but is closed/archived, reactivate it
      if (conversation) {
        conversation.status = ConversationStatus.ACTIVE;
        await queryRunner.manager.save(Conversation, conversation);
        this.logger.log(`Reactivated conversation: ${conversation.id}`);
      } else {
        // 4. Create new conversation
        conversation = queryRunner.manager.create(Conversation, {
          userId,
          partnerAccountId,
          bookingId: dto.bookingId ?? null,
          status: ConversationStatus.ACTIVE,
        });
        conversation = await queryRunner.manager.save(Conversation, conversation);
        this.logger.log(`Created new conversation: ${conversation.id}`);
      }

      // 5. Optionally send initial message
      if (dto.initialMessage) {
        const message = queryRunner.manager.create(ChatMessage, {
          conversationId: conversation.id,
          senderId: initiatorAccountId,
          content: dto.initialMessage,
          messageType: MessageType.TEXT,
        });
        const savedMsg = await queryRunner.manager.save(ChatMessage, message);

        conversation.lastMessageText = dto.initialMessage.substring(0, 200);
        conversation.lastMessageAt = savedMsg.createdAt;
        conversation.lastMessageSenderId = initiatorAccountId;

        // Set unread for the other party
        if (initiatorAccountId === userId) {
          conversation.partnerUnreadCount = 1;
        } else {
          conversation.userUnreadCount = 1;
        }
        await queryRunner.manager.save(Conversation, conversation);
      }

      // 6. Commit
      await queryRunner.commitTransaction();

      // 7. Reload with relations
      const fullConversation = await this.dataSource.manager.findOne(Conversation, {
        where: { id: conversation.id },
        relations: ['user', 'user.userProfile', 'partnerAccount', 'partnerAccount.userProfile'],
      });

      return ConversationResponseDto.fromEntity(fullConversation!, initiatorAccountId);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Create conversation failed: ${(error as Error).message}`, (error as Error).stack);
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
