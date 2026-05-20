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
import { NotificationEvent } from '@/notification/enums/notification-event.enum';
import { NotificationResponseDto } from '@/notification/dto/notification-response.dto';
import {
  WsNewNotificationEventDto,
  WsUnreadCountEventDto,
  WsBroadcastSentEventDto,
} from '@/notification/dto/ws-docs.dto';
import {
  WsJwtAuthMiddleware,
  WsRoleMiddleware,
} from '@/chat/ws/ws-jwt-auth.middleware';
import { Role } from '@/account/enum/role.enum';
import { WsNamespace } from '@/common/decorators/ws';

/**
 * WebSocket gateway for real-time notification delivery.
 *
 * Namespace: `/notifications`
 * Auth: JWT handshake → Role.USER
 *
 * Each connected client joins:
 * - Their personal room (user UUID) for targeted notifications
 * - The `broadcast` room for system-wide announcements
 */
@WsNamespace({
  name: 'notifications',
  description: 'Real-time notification delivery gateway',
  auth: { type: 'jwt', roles: ['user'] },
  serverEvents: [
    {
      event: NotificationEvent.NEW_NOTIFICATION,
      description: 'A new notification was pushed to the user',
      payload: WsNewNotificationEventDto,
    },
    {
      event: NotificationEvent.UNREAD_COUNT,
      description:
        'The unread notification count changed (after new notification or mark-read)',
      payload: WsUnreadCountEventDto,
    },
    {
      event: NotificationEvent.BROADCAST_SENT,
      description: 'A system-wide broadcast was sent (admin-facing)',
      payload: WsBroadcastSentEventDto,
    },
  ],
})
@WebSocketGateway({
  namespace: 'notifications',
  cors: { origin: process.env.WS_CORS_ORIGIN || '*' },
})
@UsePipes(new ValidationPipe({ whitelist: true }))
export class NotificationGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  private readonly logger = new Logger(NotificationGateway.name);

  @WebSocketServer()
  server: Namespace;

  constructor(
    private readonly jwtService: JwtService,
    private readonly accountService: AccountService,
  ) {}

  // ── Lifecycle ────────────────────────────────────────────────

  afterInit(server: Namespace) {
    server.use(WsJwtAuthMiddleware(this.jwtService, this.accountService));
    server.use(WsRoleMiddleware([Role.USER]));
    this.logger.log('NotificationGateway initialized on /notifications');
  }

  handleConnection(client: Socket) {
    const user = client.data.user;
    this.logger.log(
      `[Notif WS Connected] user=${user.email} userId=${user.id} socketId=${client.id}`,
    );

    // Join personal room for targeted notifications
    client.join(user.id);

    // Join broadcast room for system-wide announcements
    client.join('broadcast');

    this.logger.log(
      `[Notif WS Rooms] user=${user.email} joined [${user.id}, broadcast]`,
    );
  }

  handleDisconnect(client: Socket) {
    const user = client.data.user;
    this.logger.log(
      `[Notif WS Disconnected] user=${user?.email ?? 'unknown'} socketId=${client.id}`,
    );
  }

  // ── Push Methods (called by NotificationService) ─────────────

  /**
   * Push a targeted notification to a specific user.
   * The user may be connected across multiple devices/tabs.
   */
  pushToUser(userId: string, notification: NotificationResponseDto): void {
    this.server
      .to(userId)
      .emit(NotificationEvent.NEW_NOTIFICATION, notification);
    this.logger.log(
      `[Notif Pushed] targeted userId=${userId} notificationId=${notification.id}`,
    );
  }

  /**
   * Push a system-wide broadcast to all connected users.
   */
  pushBroadcast(notification: NotificationResponseDto): void {
    this.server
      .to('broadcast')
      .emit(NotificationEvent.NEW_NOTIFICATION, notification);
    this.logger.log(
      `[Notif Broadcast] notificationId=${notification.id} title="${notification.title}"`,
    );
  }

  /**
   * Push an updated unread count to a specific user.
   */
  pushUnreadCount(userId: string, count: number): void {
    this.server.to(userId).emit(NotificationEvent.UNREAD_COUNT, { count });
  }
}
