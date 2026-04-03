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
import {
  WsSendMessagePayloadDto,
  WsTypingPayloadDto,
  WsMarkReadPayloadDto,
  WsJoinConversationPayloadDto,
  WsNewMessageEventDto,
  WsMessageSentAckDto,
  WsMessagesReadEventDto,
  WsTypingEventDto,
  WsStopTypingEventDto,
  WsErrorEventDto,
} from '@/chat/dto/ws-docs.dto';
import { WsNamespace, WsEventDoc } from '@/common/decorators/ws';
import {
  WsJwtAuthMiddleware,
  WsRoleMiddleware,
} from './ws-jwt-auth.middleware';

/**
 * WebSocket gateway for the **Health Partner** side of the chat.
 *
 * Namespace: `/partner-chat`
 * Auth: JWT handshake → Role.HEALTH_PARTNER or Role.EMPLOYEE
 *
 * Mirrors UserChatGateway but with partner-specific role enforcement
 * and conversation resolution.
 */
@WsNamespace({
  name: 'partner-chat',
  description: 'Health Partner WebSocket gateway',
  auth: { type: 'jwt', roles: ['health_partner', 'employee'] },
  extends: 'user-chat',
})
@WebSocketGateway({
  namespace: 'partner-chat',
  cors: { origin: process.env.WS_CORS_ORIGIN || '*' },
})
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
    this.logger.log(
      `[WS Connected] partner=${user.email} userId=${user.id} role=${user.role} socketId=${client.id} transport=${client.conn?.transport?.name ?? 'unknown'}`,
    );

    client.onAny((event, ...args) => {
      let payloadStr = '';
      try {
        payloadStr = JSON.stringify(args).substring(0, 300);
      } catch (e) {
        payloadStr = '[Circular/Unserializable]';
      }
      this.logger.log(
        `[WS Received] from=${user.email} socketId=${client.id} event=${event} payload=${payloadStr}`,
      );
    });

    if (typeof client.onAnyOutgoing === 'function') {
      client.onAnyOutgoing((event, ...args) => {
        let payloadStr = '';
        try {
          payloadStr = JSON.stringify(args).substring(0, 300);
        } catch (e) {
          payloadStr = '[Circular/Unserializable]';
        }
        this.logger.log(
          `[WS Sent] to=${user.email} socketId=${client.id} event=${event} payload=${payloadStr}`,
        );
      });
    }

    this.logActiveConnections();

    // Auto-join the partner to their own identity room
    client.join(user.id);
    this.logger.log(
      `[WS Auto-Join] partner=${user.email} joined personal room ${user.id}`,
    );
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.logger.log(
      `[WS Disconnected] partner=${user?.email ?? 'unknown'} userId=${user?.id ?? 'N/A'} socketId=${client.id}`,
    );
    this.logActiveConnections();
  }

  // ── Event Handlers ───────────────────────────────────────────

  @WsEventDoc({
    description: 'Send a chat message',
    payload: WsSendMessagePayloadDto,
    ack: WsMessageSentAckDto,
  })
  @SubscribeMessage(ChatEvent.SEND_MESSAGE)
  async handleSendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: SendMessageDto,
  ) {
    const user = client.data.user;
    this.logger.log(
      `[WS Received] event=send_message partner=${user.email} conversationId=${payload.conversationId} receiverId=${payload.receiverId} clientMessageId=${payload.clientMessageId ?? 'none'}`,
    );
    this.logger.debug(
      `[WS Received Payload] event=send_message content="${payload.content?.substring(0, 100)}" type=${payload.messageType ?? 'text'}`,
    );

    try {
      const message = await this.chatService.send(payload, user.id);

      // Broadcast within this namespace's room (sender's other sessions)
      this.server.to(user.id).emit(ChatEvent.NEW_MESSAGE, message);

      // Emit to user gateway using explicit receiverId
      this.emitToUserGateway(
        message.receiverId,
        ChatEvent.NEW_MESSAGE,
        message,
      );

      this.logger.log(
        `[WS Sent] event=new_message messageId=${message.id} conversationId=${payload.conversationId} sender=${user.email}`,
      );

      // Acknowledge to the sender
      return {
        event: ChatEvent.MESSAGE_SENT,
        data: { id: message.id, clientMessageId: payload.clientMessageId },
      };
    } catch (error) {
      this.logger.error(
        `[WS Send Failed] event=send_message partner=${user.email} conversationId=${payload.conversationId} error=${(error as Error).message}`,
      );
      return {
        event: ChatEvent.ERROR,
        data: { message: (error as Error).message },
      };
    }
  }

  @WsEventDoc({
    description: 'Notify the other party that the user is typing',
    payload: WsTypingPayloadDto,
  })
  @SubscribeMessage(ChatEvent.TYPING)
  handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string; receiverId: string },
  ) {
    const user = client.data.user;
    this.emitToUserGateway(payload.receiverId, ChatEvent.TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
      receiverId: payload.receiverId,
      userName: user.userProfile?.fullName ?? user.username ?? user.email,
    });
  }

  @WsEventDoc({
    description: 'Notify the other party that the user stopped typing',
    payload: WsTypingPayloadDto,
  })
  @SubscribeMessage(ChatEvent.STOP_TYPING)
  handleStopTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string; receiverId: string },
  ) {
    const user = client.data.user;
    this.emitToUserGateway(payload.receiverId, ChatEvent.STOP_TYPING, {
      conversationId: payload.conversationId,
      userId: user.id,
      receiverId: payload.receiverId,
    });
  }

  @WsEventDoc({
    description: 'Mark all messages in a conversation as read',
    payload: WsMarkReadPayloadDto,
  })
  @SubscribeMessage(ChatEvent.MARK_READ)
  async handleMarkRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string; receiverId: string },
  ) {
    const user = client.data.user;
    try {
      await this.chatService.markAsRead(payload.conversationId, user.id);

      client.to(user.id).emit(ChatEvent.MESSAGES_READ, {
        conversationId: payload.conversationId,
        readerId: user.id,
        receiverId: payload.receiverId,
        readAt: new Date(),
      });
      this.emitToUserGateway(payload.receiverId, ChatEvent.MESSAGES_READ, {
        conversationId: payload.conversationId,
        readerId: user.id,
        receiverId: payload.receiverId,
        readAt: new Date(),
      });
    } catch (error) {
      this.logger.error(`Mark read failed: ${(error as Error).message}`);
    }
  }

  @WsEventDoc({
    description:
      'Join a conversation room (auto-joined on connect; use for new conversations)',
    payload: WsJoinConversationPayloadDto,
  })
  @SubscribeMessage(ChatEvent.JOIN_CONVERSATION)
  handleJoinConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: { conversationId: string },
  ) {
    // client.join(payload.conversationId);
    this.logger.log(
      `Partner ${client.data.user.email} requested join for conversation ${payload.conversationId} (deprecated)`,
    );
  }

  // ── Cross-Gateway Communication ──────────────────────────────

  private emitToUserGateway(room: string, event: string, data: any) {
    const userServer = this.chatService.getUserServer();
    if (userServer) {
      userServer.to(room).emit(event, data);
    }
  }

  private logActiveConnections() {
    try {
      const ioServer = (this.server as any).server;
      if (ioServer && ioServer._nsps) {
        const stats: string[] = [];
        ioServer._nsps.forEach((nsp: any, name: string) => {
          stats.push(`[namespace: ${name} = ${nsp.sockets.size} terminals]`);
        });
        const engineClients = ioServer.engine?.clientsCount;
        this.logger.log(
          `[WS Status] All Terminals -> ${stats.join(' ')} | Total Raw Connections: ${engineClients ?? 'N/A'}`,
        );
      } else {
        this.logger.log(
          `[WS Status] Current Namespace (${this.server.name}) Terminals: ${this.server.sockets.size}`,
        );
      }
    } catch (error) {
      this.logger.error(
        `[WS Status] Could not retrieve active connections: ${(error as Error).message}`,
      );
    }
  }
}
