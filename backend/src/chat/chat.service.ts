import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Namespace } from 'socket.io';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { SendMessageDto } from './dto/send-message.dto';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { MessagesQueryDto } from './dto/messages-query.dto';
import { ChatMessageResponseDto } from './dto/chat-message-response.dto';
import { ConversationResponseDto } from './dto/conversation-response.dto';
import { SendMessageHandler } from './application/handlers/send-message.handler';
import { CreateConversationHandler } from './application/handlers/create-conversation.handler';
import { GetConversationMessagesHandler } from './application/handlers/get-conversation-messages.handler';
import { MarkMessagesReadHandler } from './application/handlers/mark-messages-read.handler';
import { GetUserConversationsHandler } from './application/handlers/get-user-conversations.handler';
import { GetPartnerConversationsHandler } from './application/handlers/get-partner-conversations.handler';

/**
 * Service façade for the Chat module.
 *
 * Delegates mutations to handlers and holds references to the
 * WebSocket gateway server instances for cross-namespace communication.
 */
@Injectable()
export class ChatService {
  private readonly logger = new Logger(ChatService.name);

  /** References to gateway namespace servers for cross-gateway emission */
  private userServer: Namespace | null = null;
  private partnerServer: Namespace | null = null;

  constructor(
    @InjectRepository(PartnerConversation)
    private readonly conversationRepo: Repository<PartnerConversation>,
    private readonly sendMessageHandler: SendMessageHandler,
    private readonly createConversationHandler: CreateConversationHandler,
    private readonly getMessagesHandler: GetConversationMessagesHandler,
    private readonly markReadHandler: MarkMessagesReadHandler,
    private readonly getUserConversationsHandler: GetUserConversationsHandler,
    private readonly getPartnerConversationsHandler: GetPartnerConversationsHandler,
  ) {}

  // ── Gateway Server Registry ──────────────────────────────────

  setUserServer(server: Namespace) {
    this.userServer = server;
  }

  getUserServer(): Namespace | null {
    return this.userServer;
  }

  setPartnerServer(server: Namespace) {
    this.partnerServer = server;
  }

  getPartnerServer(): Namespace | null {
    return this.partnerServer;
  }

  // ── Mutations (delegated to handlers) ────────────────────────

  send(dto: SendMessageDto, senderId: string): Promise<ChatMessageResponseDto> {
    return this.sendMessageHandler.execute(dto, senderId);
  }

  create(
    dto: CreateConversationDto,
    initiatorAccountId: string,
  ): Promise<ConversationResponseDto> {
    return this.createConversationHandler.execute(dto, initiatorAccountId);
  }

  markAsRead(conversationId: string, requesterId: string): Promise<void> {
    return this.markReadHandler.execute(conversationId, requesterId);
  }

  // ── Queries ──────────────────────────────────────────────────

  messagesFor(
    conversationId: string,
    requesterId: string,
    query: MessagesQueryDto,
  ): Promise<{
    messages: ChatMessageResponseDto[];
    hasMore: boolean;
    nextCursor: string | null;
  }> {
    return this.getMessagesHandler.execute(conversationId, requesterId, query);
  }

  userConversations(userId: string): Promise<ConversationResponseDto[]> {
    return this.getUserConversationsHandler.execute(userId);
  }

  partnerConversations(
    partnerAccountId: string,
  ): Promise<ConversationResponseDto[]> {
    return this.getPartnerConversationsHandler.execute(partnerAccountId);
  }

  // ── Helpers for Gateway auto-join ────────────────────────────

  /**
   * Get all conversation IDs where the account is the user (patient).
   */
  async getUserConversationIds(userId: string): Promise<string[]> {
    const conversations = await this.conversationRepo.find({
      where: { userId },
      select: ['id'],
    });
    return conversations.map((c) => c.id);
  }

  /**
   * Get all conversation IDs where the account is the partner.
   */
  async getPartnerConversationIds(partnerAccountId: string): Promise<string[]> {
    const conversations = await this.conversationRepo.find({
      where: { partnerAccountId },
      select: ['id'],
    });
    return conversations.map((c) => c.id);
  }
}
