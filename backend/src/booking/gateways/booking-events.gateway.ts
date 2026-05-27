import {
  Inject,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import Redis from 'ioredis';
import { Namespace, Socket } from 'socket.io';
import { AccountService } from '@/account/account.service';
import { Role } from '@/account/enum/role.enum';
import { WsNamespace } from '@/common/decorators/ws';
import { ObservabilityMetricsService } from '@/observability/observability-metrics.service';
import { REDIS_CLIENT } from '@/redis/redis.service';
import {
  WsJwtAuthMiddleware,
  WsRoleMiddleware,
} from '@/chat/ws/ws-jwt-auth.middleware';
import { BookingStatusChangeEventDto } from '../dto/booking-status-change-event.dto';
import { BookingAccessService } from '../services/booking-access.service';
import {
  BOOKING_STATUS_REDIS_CHANNEL,
  BOOKING_STATUS_SOCKET_EVENT,
  bookingPartnerRoom,
  bookingUserRoom,
} from '../constants/booking-realtime.constants';

@WsNamespace({
  name: 'booking-events',
  description: 'Booking lifecycle event gateway',
  auth: { type: 'jwt', roles: ['user', 'health_partner'] },
  serverEvents: [
    {
      event: BOOKING_STATUS_SOCKET_EVENT,
      description: 'A booking status changed and should update local UI state',
      payload: BookingStatusChangeEventDto,
    },
  ],
})
@WebSocketGateway({
  namespace: 'booking-events',
  cors: { origin: process.env.WS_CORS_ORIGIN || '*' },
})
@UsePipes(new ValidationPipe({ whitelist: true }))
export class BookingEventsGateway
  implements
    OnGatewayInit,
    OnGatewayConnection,
    OnGatewayDisconnect,
    OnModuleInit,
    OnModuleDestroy
{
  private readonly logger = new Logger(BookingEventsGateway.name);
  private subscriber: Redis | null = null;

  @WebSocketServer()
  server: Namespace;

  constructor(
    private readonly jwtService: JwtService,
    private readonly accountService: AccountService,
    private readonly bookingAccessService: BookingAccessService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly observabilityMetrics: ObservabilityMetricsService,
  ) {}

  afterInit(server: Namespace) {
    server.use(WsJwtAuthMiddleware(this.jwtService, this.accountService));
    server.use(WsRoleMiddleware([Role.USER, Role.HEALTH_PARTNER]));
    this.observabilityMetrics.registerWsNamespace('booking-events', server);
    this.logger.log('BookingEventsGateway initialized on /booking-events');
  }

  async onModuleInit(): Promise<void> {
    this.subscriber = this.redis.duplicate();
    this.subscriber.on('error', (error) => {
      this.logger.error(`Booking Redis subscriber error: ${error.message}`);
    });

    try {
      await this.subscriber.connect();
      await this.subscriber.subscribe(
        BOOKING_STATUS_REDIS_CHANNEL,
        (_error, count) => {
          this.logger.log(
            `Subscribed to ${BOOKING_STATUS_REDIS_CHANNEL} (${count} channel(s))`,
          );
        },
      );
      this.subscriber.on('message', (channel, message) => {
        if (channel !== BOOKING_STATUS_REDIS_CHANNEL) return;
        this.emitStatusChange(message);
      });
    } catch (error) {
      this.logger.error(
        `Failed to subscribe to booking status Redis events: ${(error as Error).message}`,
      );
    }
  }

  async onModuleDestroy(): Promise<void> {
    if (!this.subscriber) return;
    await this.subscriber
      .unsubscribe(BOOKING_STATUS_REDIS_CHANNEL)
      .catch(() => undefined);
    await this.subscriber.quit().catch(() => undefined);
  }

  async handleConnection(client: Socket): Promise<void> {
    const user = client.data.user;
    if (user.role === Role.USER) {
      const room = bookingUserRoom(user.id);
      await client.join(room);
      this.observabilityMetrics.recordWsConnect(
        client.id,
        'booking-events',
        user.role,
        user.id,
      );
      this.logger.log(`Booking WS user=${user.id} joined ${room}`);
      return;
    }

    if (user.role === Role.HEALTH_PARTNER) {
      const partnerId =
        await this.bookingAccessService.resolvePartnerIdForAccount(user.id);
      if (!partnerId) {
        this.logger.warn(
          `Booking WS partner account=${user.id} has no profile`,
        );
        client.disconnect(true);
        return;
      }
      const room = bookingPartnerRoom(partnerId);
      await client.join(room);
      this.observabilityMetrics.recordWsConnect(
        client.id,
        'booking-events',
        user.role,
        user.id,
      );
      this.logger.log(`Booking WS partner=${partnerId} joined ${room}`);
    }
  }

  handleDisconnect(client: Socket): void {
    const user = client.data.user;
    this.observabilityMetrics.recordWsDisconnect(client.id, 'booking-events');
    this.logger.log(
      `Booking WS disconnected user=${user?.id ?? 'unknown'} socket=${client.id}`,
    );
  }

  private emitStatusChange(message: string): void {
    try {
      const payload = BookingStatusChangeEventDto.fromPlain(
        JSON.parse(message),
      );
      // Redis Pub/Sub decouples the transaction writer from every API instance
      // that may own the user's or partner's active WebSocket connection.
      this.server
        .to(bookingUserRoom(payload.userId))
        .emit(BOOKING_STATUS_SOCKET_EVENT, payload);
      if (payload.partnerId) {
        this.server
          .to(bookingPartnerRoom(payload.partnerId))
          .emit(BOOKING_STATUS_SOCKET_EVENT, payload);
      }
    } catch (error) {
      this.logger.warn(
        `Ignored malformed booking status event: ${(error as Error).message}`,
      );
    }
  }
}
