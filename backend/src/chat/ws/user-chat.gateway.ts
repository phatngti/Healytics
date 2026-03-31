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
 * WebSocket gateway for the **User** (patient) side of the chat.
 *
 * Namespace: `/user-chat`
 * Auth: JWT handshake → Role.USER only
 *
 * Socket.IO rooms are used internally for routing messages to the correct
 * conversation — this is NOT a "chat room" feature. Each conversation maps
 * to one Socket.IO room named by its UUID.
 */
@WebSocketGateway({
  namespace: 'user-chat',
  cors: { origin: process.env.WS_CORS_ORIGIN || '*' },
})
@UsePipes(new ValidationPipe({ whitelist: true }))
export class UserChatGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  private readonly logger = new Logger(UserChatGateway.name);

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
    server.use(WsRoleMiddleware([Role.USER]));
    this.logger.log('UserChatGateway initialized on /user-chat');
  }

  async handleConnection(client: Socket) {
    const user = client.data.user;
    this.logger.log(
      `[WS Connected] user=${user.email} userId=${user.id} socketId=${client.id} transport=${client.conn?.transport?.name ?? 'unknown'}`,
    );

    // Auto-join the user to all their conversation rooms
    try {
      const conversations = await this.chatService.getUserConversationIds(user.id);
      for (const convId of conversations) {
        client.join(convId);
      }
      this.logger.log(
        `[WS Auto-Join] user=${user.email} rooms=${conversations.length} roomIds=[${conversations.join(', ')}]`,
      );
    } catch (error) {
      this.logger.error(
        `[WS Auto-Join Failed] user=${user.email} error=${(error as Error).message}`,
      );
    }
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.logger.log(
      `[WS Disconnected] user=${user?.email ?? 'unknown'} userId=${user?.id ?? 'N/A'} socketId=${client.id}`,
    );
  }

  // ── Event Handlers ───────────────────────────────────────────

  @SubscribeMessage(ChatEvent.SEND_MESSAGE)
  async handleSendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: SendMessageDto,
  ) {
    const user = client.data.user;
    this.logger.log(
      `[WS Received] event=send_message user=${user.email} conversationId=${payload.conversationId} clientMessageId=${payload.clientMessageId ?? 'none'}`,
    );
    this.logger.debug(
      `[WS Received Payload] event=send_message content="${payload.content?.substring(0, 100)}" type=${payload.messageType ?? 'text'}`,
    );

    try {
      const message = await this.chatService.send(payload, user.id);

      // Broadcast to all sockets in the conversation room (including partner gateway)
      this.server.to(payload.conversationId).emit(ChatEvent.NEW_MESSAGE, message);

      // Also emit to the partner gateway's namespace via the shared room
      this.emitToPartnerGateway(payload.conversationId, ChatEvent.NEW_MESSAGE, message);

      this.logger.log(
        `[WS Sent] event=new_message messageId=${message.id} conversationId=${payload.conversationId} sender=${user.email}`,
      );

      // Acknowledge to the sender
      return { event: ChatEvent.MESSAGE_SENT, data: { id: message.id, clientMessageId: payload.clientMessageId } };
    } catch (error) {
      this.logger.error(
        `[WS Send Failed] event=send_message user=${user.email} conversationId=${payload.conversationId} error=${(error as Error).message}`,
      );
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
    this.emitToPartnerGateway(payload.conversationId, ChatEvent.TYPING, {
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
    this.emitToPartnerGateway(payload.conversationId, ChatEvent.STOP_TYPING, {
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

      // Notify the other party that messages have been read
      client.to(payload.conversationId).emit(ChatEvent.MESSAGES_READ, {
        conversationId: payload.conversationId,
        readerId: user.id,
        readAt: new Date(),
      });
      this.emitToPartnerGateway(payload.conversationId, ChatEvent.MESSAGES_READ, {
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
    this.logger.log(`User ${client.data.user.email} joined conversation ${payload.conversationId}`);
  }

  // ── Cross-Gateway Communication ──────────────────────────────

  /**
   * Emit an event to the partner chat gateway's namespace.
   * This is used when a user sends a message/typing indicator that the
   * partner needs to receive on their own gateway namespace.
   *
   * Uses the injected ChatService to access the partner gateway's server
   * instance. The partner gateway registers itself with ChatService.
   */
  private emitToPartnerGateway(room: string, event: string, data: any) {
    const partnerServer = this.chatService.getPartnerServer();
    if (partnerServer) {
      partnerServer.to(room).emit(event, data);
    }
  }
}
