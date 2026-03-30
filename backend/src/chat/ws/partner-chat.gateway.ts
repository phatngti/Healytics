import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayInit,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Logger, UsePipes, ValidationPipe } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Namespace, Socket } from 'socket.io';
import { AccountService } from '@/account/account.service';
import { Role } from '@/account/enum/role.enum';
import { ChatService } from '@/chat/chat.service';
import { ChatEvent } from '@/chat/enums/chat-event.enum';
import { SendMessageDto } from '@/chat/dto/send-message.dto';
import { WsJwtAuthMiddleware, WsRoleMiddleware } from './ws-jwt-auth.middleware';

/**
 * WebSocket gateway for the **Health Partner** side of the chat.
 *
 * Namespace: `/partner-chat`
 * Auth: JWT handshake → Role.HEALTH_PARTNER or Role.EMPLOYEE
 *
 * Mirrors UserChatGateway but with partner-specific role enforcement
 * and conversation resolution.
 */
@WebSocketGateway({ namespace: 'partner-chat', cors: { origin: '*' } })
@UsePipes(new ValidationPipe({ whitelist: true }))
export class PartnerChatGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  private readonly logger = new Logger(PartnerChatGateway.name);

  @WebSocketServer()
  server: Namespace;

  constructor(
    private readonly chatService: ChatService,
    private readonly jwtService: JwtService,
    private readonly accountService: AccountService,
  ) {}

  // ── Lifecycle ────────────────────────────────────────────────

  afterInit(server: Namespace) {
    server.use(WsJwtAuthMiddleware(this.jwtService, this.accountService));
    server.use(WsRoleMiddleware([Role.HEALTH_PARTNER, Role.EMPLOYEE]));

    // Register this gateway's server instance for cross-gateway communication
    this.chatService.setPartnerServer(server);
    this.logger.log('PartnerChatGateway initialized on /partner-chat');
  }

  async handleConnection(client: Socket) {
    const user = client.data.user;
    this.logger.log(`Partner connected: ${user.email} (${client.id})`);

    // Auto-join the partner to all their conversation rooms
    try {
      const conversations = await this.chatService.getPartnerConversationIds(user.id);
      for (const convId of conversations) {
        client.join(convId);
      }
      this.logger.log(`Partner ${user.email} joined ${conversations.length} conversation rooms`);
    } catch (error) {
      this.logger.error(`Failed to join rooms for ${user.email}: ${(error as Error).message}`);
    }
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.logger.log(`Partner disconnected: ${user?.email ?? 'unknown'} (${client.id})`);
  }

  // ── Event Handlers ───────────────────────────────────────────

  @SubscribeMessage(ChatEvent.SEND_MESSAGE)
  async handleSendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: SendMessageDto,
  ) {
    const user = client.data.user;
    try {
      const message = await this.chatService.send(payload, user.id);

      // Broadcast within this namespace's room
      this.server.to(payload.conversationId).emit(ChatEvent.NEW_MESSAGE, message);

      // Also emit to user gateway
      this.emitToUserGateway(payload.conversationId, ChatEvent.NEW_MESSAGE, message);

      // Acknowledge to the sender
      return { event: ChatEvent.MESSAGE_SENT, data: { id: message.id, clientMessageId: payload.clientMessageId } };
    } catch (error) {
      this.logger.error(`Send message failed: ${(error as Error).message}`);
      return { event: ChatEvent.ERROR, data: { message: (error as Error).message } };
    }
  }

  @SubscribeMessage(ChatEvent.TYPING)
  handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string },
  ) {
    const user = client.data.user;
    client.to(payload.conversationId).emit(ChatEvent.TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
      userName: user.userProfile?.fullName ?? user.username ?? user.email,
    });
    this.emitToUserGateway(payload.conversationId, ChatEvent.TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
      userName: user.userProfile?.fullName ?? user.username ?? user.email,
    });
  }

  @SubscribeMessage(ChatEvent.STOP_TYPING)
  handleStopTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string },
  ) {
    const user = client.data.user;
    client.to(payload.conversationId).emit(ChatEvent.STOP_TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
    });
    this.emitToUserGateway(payload.conversationId, ChatEvent.STOP_TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
    });
  }

  @SubscribeMessage(ChatEvent.MARK_READ)
  async handleMarkRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string },
  ) {
    const user = client.data.user;
    try {
      await this.chatService.markAsRead(payload.conversationId, user.id);

      client.to(payload.conversationId).emit(ChatEvent.MESSAGES_READ, {
        conversationId: payload.conversationId,
        readerId: user.id,
        readAt: new Date(),
      });
      this.emitToUserGateway(payload.conversationId, ChatEvent.MESSAGES_READ, {
        conversationId: payload.conversationId,
        readerId: user.id,
        readAt: new Date(),
      });
    } catch (error) {
      this.logger.error(`Mark read failed: ${(error as Error).message}`);
    }
  }

  @SubscribeMessage(ChatEvent.JOIN_CONVERSATION)
  handleJoinConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string },
  ) {
    client.join(payload.conversationId);
    this.logger.log(`Partner ${client.data.user.email} joined conversation ${payload.conversationId}`);
  }

  // ── Cross-Gateway Communication ──────────────────────────────

  private emitToUserGateway(room: string, event: string, data: any) {
    const userServer = this.chatService.getUserServer();
    if (userServer) {
      userServer.to(room).emit(event, data);
    }
  }
}
