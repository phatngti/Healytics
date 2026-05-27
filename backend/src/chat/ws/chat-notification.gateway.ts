import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayInit,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Logger, UsePipes, ValidationPipe } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Namespace, Socket } from 'socket.io';
import { AccountService } from '@/account/account.service';
import { Role } from '@/account/enum/role.enum';
import { ChatNotificationEvent } from './chat-notification-event.enum';
import { WsNewMessageNotificationDto } from '@/chat/dto/ws-docs.dto';
import { WsNamespace } from '@/common/decorators/ws';
import { ObservabilityMetricsService } from '@/observability/observability-metrics.service';
import {
  WsJwtAuthMiddleware,
  WsRoleMiddleware,
} from './ws-jwt-auth.middleware';

/**
 * Global WebSocket gateway for chat message notifications.
 *
 * Namespace: `/chat-notifications`
 * Auth: JWT handshake → Role.USER, Role.HEALTH_PARTNER, Role.EMPLOYEE
 *
 * Purpose:
 * Delivers real-time popup notifications for new chat messages
 * to ALL authenticated users regardless of which screen/page they are on.
 * This is a **push-only** gateway — it does NOT handle any client→server events.
 *
 * Each connected client auto-joins their personal room (userId) so
 * notifications can be targeted to specific recipients.
 *
 * Integration:
 * - Called by UserChatGateway and PartnerChatGateway after a message is sent
 * - Works alongside the existing /user-chat and /partner-chat namespaces
 * - Does NOT replace the message delivery on those namespaces
 */
@WsNamespace({
  name: 'chat-notifications',
  description:
    'Global chat notification gateway for popup notifications (all roles)',
  auth: { type: 'jwt', roles: ['user', 'health_partner', 'employee'] },
  serverEvents: [
    {
      event: ChatNotificationEvent.NEW_MESSAGE_NOTIFICATION,
      description:
        'A new chat message was received — show a popup notification',
      payload: WsNewMessageNotificationDto,
    },
  ],
})
@WebSocketGateway({
  namespace: 'chat-notifications',
  cors: { origin: process.env.WS_CORS_ORIGIN || '*' },
})
@UsePipes(new ValidationPipe({ whitelist: true }))
export class ChatNotificationGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  private readonly logger = new Logger(ChatNotificationGateway.name);

  @WebSocketServer()
  server: Namespace;

  constructor(
    private readonly jwtService: JwtService,
    private readonly accountService: AccountService,
    private readonly observabilityMetrics: ObservabilityMetricsService,
  ) {}

  // ── Lifecycle ────────────────────────────────────────────────

  afterInit(server: Namespace) {
    server.use(WsJwtAuthMiddleware(this.jwtService, this.accountService));
    server.use(
      WsRoleMiddleware([Role.USER, Role.HEALTH_PARTNER, Role.EMPLOYEE]),
    );
    this.observabilityMetrics.registerWsNamespace('chat-notifications', server);
    this.logger.log(
      'ChatNotificationGateway initialized on /chat-notifications',
    );
  }

  handleConnection(client: Socket) {
    const user = client.data.user;
    this.observabilityMetrics.recordWsConnect(
      client.id,
      'chat-notifications',
      user.role,
      user.id,
    );
    this.logger.log(
      `[ChatNotif WS Connected] user=${user.email} role=${user.role} userId=${user.id} socketId=${client.id}`,
    );

    // Join personal room for targeted notifications
    client.join(user.id);

    this.logger.log(
      `[ChatNotif WS Rooms] user=${user.email} joined personal room [${user.id}]`,
    );
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.observabilityMetrics.recordWsDisconnect(
      client.id,
      'chat-notifications',
    );
    this.logger.log(
      `[ChatNotif WS Disconnected] user=${user?.email ?? 'unknown'} socketId=${client.id}`,
    );
  }

  // ── Push Methods (called by chat gateways) ───────────────────

  /**
   * Push a new-message notification to a specific user/partner.
   *
   * The recipient may be connected across multiple devices/tabs —
   * Socket.IO rooms handle multi-device delivery automatically.
   *
   * @param receiverId - The account UUID of the message recipient
   * @param payload    - Notification data for the popup
   */
  pushNewMessageNotification(
    receiverId: string,
    payload: WsNewMessageNotificationDto,
  ): void {
    this.server
      .to(receiverId)
      .emit(ChatNotificationEvent.NEW_MESSAGE_NOTIFICATION, payload);
    this.logger.log(
      `[ChatNotif Pushed] receiverId=${receiverId} conversationId=${payload.conversationId} messageId=${payload.messageId} from=${payload.senderName}`,
    );
  }
}
