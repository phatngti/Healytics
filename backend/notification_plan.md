# Notification Feature — Comprehensive Implementation Plan

## Background & Goal

Implement a full notification system for Healytics that supports:
1. **Targeted Notifications** — triggered by specific user events (booking confirmed, appointment reminder, new chat message, etc.)
2. **System-wide Broadcasts** — admin-initiated announcements sent to all users

The system must handle **~1,000 CCU/s** (Concurrent Connections per second) and leverage the **existing project stack** wherever possible.

---

## Technology Decision: Why Socket.IO + Redis Adapter (No New Dependencies)

> [!IMPORTANT]
> **Recommendation: Extend the existing Socket.IO + Redis + RabbitMQ infrastructure. No new real-time transport technology is needed.**

### Current Stack Inventory

| Technology | Already in use | Role in Notification System |
|---|---|---|
| **Socket.IO** (`socket.io@4.8.3`, `@nestjs/websockets`, `@nestjs/platform-socket.io`) | ✅ Chat gateways | Real-time delivery to connected clients |
| **Redis** (`ioredis@5.10`) | ✅ Distributed locks, KV store, Pub/Sub | WebSocket adapter for horizontal scaling + notification caching |
| **RabbitMQ** (`@nestjs/microservices`, `amqp-connection-manager`) | ✅ Checkout queue consumer | Event bus for decoupled notification production |
| **PostgreSQL** (`pg@8.11`, `typeorm@0.3.23`) | ✅ Primary database | Notification persistence & history |
| **NestJS** (`@nestjs/core@10.4.22`) | ✅ Application framework | Module architecture, guards, gateways |

### CCU/s Capacity Analysis

| Factor | Assessment |
|---|---|
| **1,000 CCU on a single Node.js process** | ✅ Well within safe range. A single Node.js process can handle 5,000–10,000+ idle WebSocket connections. Active notification pushes (small JSON payloads) are lightweight. |
| **Socket.IO Redis Adapter** | ✅ Required only when horizontally scaling (multiple server instances). Trivial to add — only requires `@socket.io/redis-adapter` package + a custom `RedisIoAdapter` class. Uses the existing `ioredis` connection. |
| **RabbitMQ Fan-out Exchange** | ✅ Already configured. Can add a `notifications` fanout exchange for decoupled event processing. Enables independent scaling of notification workers. |
| **OS file descriptor limit** | ⚠️ Default `ulimit -n 1024` must be raised on production hosts (e.g., `65535`). This is a deployment concern, not a code change. |

### New Package Required

| Package | Purpose | Size |
|---|---|---|
| `@socket.io/redis-adapter` | Synchronize WebSocket events across multiple server instances for horizontal scaling | ~15KB |

> [!NOTE]
> This is the **only** new dependency needed. Everything else reuses existing infrastructure.

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                        PRODUCERS (Event Sources)                 │
│                                                                  │
│  BookingModule    AppointmentModule    ChatModule    AdminModule  │
│       │                  │                │              │        │
│       └──────────────────┴────────────────┴──────────────┘        │
│                              │                                    │
│                    NotificationEventService                       │
│                    (emits domain events)                          │
└──────────────────────────────┬───────────────────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │     RabbitMQ         │
                    │  (fanout exchange:   │
                    │  notification.events)│
                    └──────────┬──────────┘
                               │
┌──────────────────────────────▼───────────────────────────────────┐
│                    CONSUMER (Notification Worker)                 │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │              NotificationProcessorService               │     │
│  │                                                         │     │
│  │  1. Resolve recipients (targeted or broadcast)          │     │
│  │  2. Persist to DB (notification table)                  │     │
│  │  3. Push via Socket.IO gateway (real-time)              │     │
│  │  4. (Future) Push via FCM/APNs for offline users        │     │
│  └─────────────────────────────────────────────────────────┘     │
│                              │                                    │
│               ┌──────────────┼──────────────┐                    │
│               ▼              ▼              ▼                    │
│          PostgreSQL    NotificationGateway  (Future: FCM)         │
│          (persistence)  (Socket.IO /notif)                       │
└──────────────────────────────────────────────────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   Redis Adapter      │
                    │  (cross-instance     │
                    │   WS sync)           │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              ▼                ▼                ▼
         Client A         Client B         Client C
        (User App)       (User App)     (Admin Panel)
```

---

## Proposed Changes

### Component 1: Database Layer (Entities & Migration)

#### [NEW] `src/common/entities/notification.entity.ts`

Core notification entity with polymorphic targeting:

```typescript
@Entity('notifications')
@Index(['recipientId', 'isRead', 'createdAt'])
@Index(['type', 'createdAt'])
export class Notification {
  @PrimaryGeneratedColumn('uuid') id: string;
  
  // NULL for system-wide broadcasts (all users)
  @Column({ name: 'recipient_id', type: 'uuid', nullable: true })
  @Index()
  recipientId: string | null;
  
  @Column({ type: 'enum', enum: NotificationType })
  type: NotificationType;
  
  @Column() title: string;
  @Column({ type: 'text' }) body: string;
  
  // Deep-link data for frontend routing
  @Column({ type: 'jsonb', nullable: true })
  data: Record<string, any> | null;
  
  @Column({ name: 'is_read', default: false }) isRead: boolean;
  @Column({ name: 'read_at', type: 'timestamptz', nullable: true }) readAt: Date | null;
  
  // Track broadcast origin
  @Column({ name: 'is_broadcast', default: false }) isBroadcast: boolean;
  @Column({ name: 'sender_id', type: 'uuid', nullable: true }) senderId: string | null;
  
  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' }) createdAt: Date;
  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' }) deletedAt: Date | null;
  
  @ManyToOne(() => Account, { onDelete: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'recipient_id' }) recipient: Account | null;
}
```

#### [NEW] `src/notification/enums/notification-type.enum.ts`

```typescript
export enum NotificationType {
  // Booking lifecycle
  BOOKING_CONFIRMED = 'booking_confirmed',
  BOOKING_CANCELLED = 'booking_cancelled',
  BOOKING_COMPLETED = 'booking_completed',
  
  // Appointment
  APPOINTMENT_REMINDER = 'appointment_reminder',
  APPOINTMENT_UPDATED = 'appointment_updated',
  
  // Chat
  NEW_CHAT_MESSAGE = 'new_chat_message',
  
  // Payment
  PAYMENT_SUCCESS = 'payment_success',
  PAYMENT_FAILED = 'payment_failed',
  
  // System
  SYSTEM_BROADCAST = 'system_broadcast',
  SYSTEM_MAINTENANCE = 'system_maintenance',
  
  // Partner
  PARTNER_VERIFIED = 'partner_verified',
  PARTNER_REJECTED = 'partner_rejected',
}
```

#### [NEW] Migration: `CreateNotificationsTable`

Standard TypeORM migration following project patterns (UUID PK, `timestamptz`, proper indexes, `ifNotExists`).

---

### Component 2: Notification Module (Core)

#### [NEW] `src/notification/notification.module.ts`

```
src/notification/
├── application/
│   └── handlers/
│       ├── create-notification.handler.ts      # Persist + push single notification
│       ├── create-broadcast.handler.ts         # Admin broadcast to all users
│       ├── mark-notification-read.handler.ts   # Mark one as read
│       └── mark-all-read.handler.ts            # Mark all as read for a user
├── dto/
│   ├── notification-response.dto.ts            # Response DTO
│   ├── create-broadcast.dto.ts                 # Admin broadcast input
│   └── notifications-query.dto.ts              # Pagination query
├── enums/
│   └── notification-type.enum.ts
│   └── notification-event.enum.ts              # WS event names
├── ws/
│   └── notification.gateway.ts                 # New Socket.IO namespace: /notifications
├── services/
│   └── notification-event.service.ts           # Event producer (used by other modules)
├── notification.service.ts                     # Service facade
└── notification.module.ts
```

#### Key Files

##### [NEW] `src/notification/ws/notification.gateway.ts`

A **new WebSocket namespace** `/notifications` dedicated to real-time notification delivery:

```typescript
@WebSocketGateway({ namespace: 'notifications', cors: { origin: '*' } })
export class NotificationGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Namespace;
  
  afterInit(server: Namespace) {
    // Reuse existing WS JWT auth middleware
    server.use(WsJwtAuthMiddleware(this.jwtService, this.accountService));
  }
  
  handleConnection(client: Socket) {
    const user = client.data.user;
    client.join(user.id);           // Personal room for targeted notifications
    client.join('broadcast');        // Global room for broadcasts
  }
  
  // Called by NotificationService after persisting
  pushToUser(userId: string, notification: NotificationResponseDto) {
    this.server.to(userId).emit('new_notification', notification);
  }
  
  pushBroadcast(notification: NotificationResponseDto) {
    this.server.to('broadcast').emit('new_notification', notification);
  }
}
```

##### [NEW] `src/notification/services/notification-event.service.ts`

A lightweight event producer injected by other modules to trigger notifications **without tight coupling**:

```typescript
@Injectable()
export class NotificationEventService {
  constructor(@Inject(RABBITMQ_CLIENT) private readonly rmqClient: ClientProxy) {}
  
  // Other modules call this — fire-and-forget via RabbitMQ
  emit(event: NotificationEventPayload): void {
    this.rmqClient.emit('notification.event', event);
  }
}
```

##### [NEW] `src/notification/services/notification-processor.service.ts`

RabbitMQ consumer that processes notification events:

```typescript
@Controller()
export class NotificationProcessorService {
  @EventPattern('notification.event')
  async handleNotificationEvent(payload: NotificationEventPayload) {
    // 1. Resolve recipient(s) — single user or all users for broadcast
    // 2. Persist notification(s) to DB
    // 3. Push real-time via NotificationGateway
  }
}
```

---

### Component 3: REST APIs

#### [NEW] `src/notification/user-notification.controller.ts`

User-facing notification endpoints:

| Method | Path | Description |
|---|---|---|
| `GET` | `/v1/user/notifications` | List notifications (paginated, cursor-based) |
| `GET` | `/v1/user/notifications/unread-count` | Unread count badge |
| `PATCH` | `/v1/user/notifications/:id/read` | Mark single as read |
| `PATCH` | `/v1/user/notifications/read-all` | Mark all as read |

#### [NEW] `src/notification/admin-notification.controller.ts`

Admin-facing endpoints for broadcast management:

| Method | Path | Description |
|---|---|---|
| `POST` | `/v1/admin/notifications/broadcast` | Create & send system-wide broadcast |
| `GET` | `/v1/admin/notifications/broadcasts` | List sent broadcasts (audit) |

---

### Component 4: Redis Socket.IO Adapter (Horizontal Scaling)

#### [NEW] `src/common/adapters/redis-io.adapter.ts`

Custom WebSocket adapter for cross-instance synchronization:

```typescript
export class RedisIoAdapter extends IoAdapter {
  private adapterConstructor: ReturnType<typeof createAdapter>;
  
  async connectToRedis(redisUrl: string): Promise<void> {
    const pubClient = new Redis(redisUrl);
    const subClient = pubClient.duplicate();
    this.adapterConstructor = createAdapter(pubClient, subClient);
  }
  
  createIOServer(port: number, options?: ServerOptions): any {
    const server = super.createIOServer(port, options);
    server.adapter(this.adapterConstructor);
    return server;
  }
}
```

#### [MODIFY] `src/main.ts`

Register the Redis adapter before app bootstrap:

```typescript
const redisIoAdapter = new RedisIoAdapter(app);
await redisIoAdapter.connectToRedis(process.env.REDIS_URL);
app.useWebSocketAdapter(redisIoAdapter);
```

---

### Component 5: Event Integration Points

Other modules will use `NotificationEventService` to fire events:

#### [MODIFY] `src/booking/application/handlers/` (existing handlers)

After booking status transitions, emit notification events:

```typescript
// In confirm-booking handler, after successful commit:
this.notificationEventService.emit({
  type: NotificationType.BOOKING_CONFIRMED,
  recipientId: booking.userId,
  title: 'Booking Confirmed',
  body: `Your booking for ${serviceName} has been confirmed.`,
  data: { bookingId: booking.id, action: 'view_booking' },
});
```

#### Trigger Points (by domain)

| Domain | Event | Recipient | Notification Type |
|---|---|---|---|
| **Booking** | Status → `CONFIRMED` | User | `BOOKING_CONFIRMED` |
| **Booking** | Status → `CANCELLED` | User | `BOOKING_CANCELLED` |
| **Booking** | Status → `COMPLETED` | User | `BOOKING_COMPLETED` |
| **Appointment** | Reminder (24h before) | User | `APPOINTMENT_REMINDER` |
| **Payment** | Payment success IPN | User | `PAYMENT_SUCCESS` |
| **Payment** | Payment failure | User | `PAYMENT_FAILED` |
| **Partner** | Verification approved | Partner | `PARTNER_VERIFIED` |
| **Partner** | Verification rejected | Partner | `PARTNER_REJECTED` |
| **Admin** | System broadcast | All Users | `SYSTEM_BROADCAST` |

---

### Component 6: WebSocket Contract Extension

#### [MODIFY] `openapi/ws-contract.json`

Add the new `/notifications` namespace and its events to the contract for frontend code generation.

---

## Broadcast Strategy (1,000 CCU)

> [!IMPORTANT]
> **Broadcasts do NOT create 1,000 rows in the `notifications` table.** Instead:

### Approach: Single-Row Broadcast + Per-User Read Tracking

1. **Persist**: Insert a **single** `Notification` row with `recipientId = NULL` and `isBroadcast = true`.
2. **Push**: Emit to the `broadcast` Socket.IO room — all connected clients receive it instantly.
3. **Read Tracking**: Use a separate lightweight `notification_reads` table:

```typescript
@Entity('notification_reads')
@Unique('UQ_NOTIF_READ', ['notificationId', 'userId'])
export class NotificationRead {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ name: 'notification_id', type: 'uuid' }) @Index() notificationId: string;
  @Column({ name: 'user_id', type: 'uuid' }) @Index() userId: string;
  @CreateDateColumn({ name: 'read_at', type: 'timestamptz' }) readAt: Date;
}
```

4. **Query**: "Unread notifications" = targeted notifications WHERE `isRead = false` UNION broadcasts WHERE NOT EXISTS in `notification_reads`.

This ensures the database remains lean even with thousands of users.

---

## Open Questions

> [!WARNING]
> ### 1. Appointment Reminders — CRON-Based Scheduling
> Appointment reminders (24h before) require a scheduled job. Options:
> - **A)** `@nestjs/schedule` with `@Cron()` decorator (simplest, runs in-process)
> - **B)** Separate cron worker service (better isolation)
>
> **Which approach do you prefer?**

> [!IMPORTANT]
> ### 2. Push Notifications for Offline Users
> Should we plan for **Firebase Cloud Messaging (FCM)** / **APNs** integration in this iteration?
> This would require users to register device tokens and a new `device_tokens` table. Or should this be deferred to a future phase?

> [!IMPORTANT]
> ### 3. Notification Preferences
> Should users be able to opt out of specific notification types? This would require a `notification_preferences` table. Or is this out of scope for the initial implementation?

> [!IMPORTANT]
> ### 4. Admin Panel Notifications
> Should health partners also receive notifications via the same system (e.g., new booking request, new chat message)? The current WebSocket contract has separate namespaces for users vs. partners.

---

## Verification Plan

### Automated Tests

```bash
# 1. Typecheck
npm run build

# 2. Unit tests for handlers and service
npm run test -- --testPathPattern=notification

# 3. Migration verification
npm run migration:run
npm run migration:revert
```

### Manual Verification

1. **Targeted Notification Flow**: Create a booking → confirm it → verify the user receives a real-time `new_notification` event on the `/notifications` WebSocket namespace.
2. **Broadcast Flow**: Admin sends a broadcast via `POST /v1/admin/notifications/broadcast` → verify all connected users receive it.
3. **Offline User**: User connects after a broadcast was sent → verify they see it in `GET /v1/user/notifications`.
4. **Unread Count**: Verify `GET /v1/user/notifications/unread-count` reflects the correct count after marking notifications as read.
5. **Horizontal Scaling**: Start two server instances behind a load balancer → verify notifications arrive regardless of which instance the user is connected to.

---

## File Summary

| Action | File | Description |
|---|---|---|
| **NEW** | `src/notification/notification.module.ts` | Module registration |
| **NEW** | `src/notification/notification.service.ts` | Service facade |
| **NEW** | `src/notification/ws/notification.gateway.ts` | WebSocket gateway (`/notifications`) |
| **NEW** | `src/notification/services/notification-event.service.ts` | RabbitMQ event producer |
| **NEW** | `src/notification/services/notification-processor.service.ts` | RabbitMQ event consumer |
| **NEW** | `src/notification/user-notification.controller.ts` | User REST APIs |
| **NEW** | `src/notification/admin-notification.controller.ts` | Admin REST APIs |
| **NEW** | `src/notification/application/handlers/*.ts` | 4 domain handlers |
| **NEW** | `src/notification/dto/*.ts` | Request/Response DTOs |
| **NEW** | `src/notification/enums/*.ts` | Notification & event enums |
| **NEW** | `src/common/entities/notification.entity.ts` | Notification entity |
| **NEW** | `src/common/entities/notification-read.entity.ts` | Broadcast read tracking |
| **NEW** | `src/common/adapters/redis-io.adapter.ts` | Redis Socket.IO adapter |
| **NEW** | `migrations/scripts/CreateNotificationsTable*.ts` | Database migration |
| **MODIFY** | `src/main.ts` | Register Redis WS adapter |
| **MODIFY** | `src/app.module.ts` | Import NotificationModule |
| **MODIFY** | `src/common/entities/index.ts` | Export new entities |
| **MODIFY** | `openapi/ws-contract.json` | Add `/notifications` namespace |
| **MODIFY** | `src/booking/` handlers (future) | Emit notification events |
