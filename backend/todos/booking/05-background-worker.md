# 05 — Background Worker (RabbitMQ Consumer + Checkout Lock)

**Status:** ✅ COMPLETED

## Context

This is the **core of the anti-race-condition system** (Step 3 in the TDD). A background worker consumes messages from the `checkout_queue`, attempts to acquire a Redis checkout lock (600s), and either creates a Booking or marks the ticket as FAILED.

## Prerequisites

- ✅ Todo 04 — Checkout ticket created and published to queue
- ✅ `RedisService.acquireLock()` for checkout lock (600s)
- ✅ `Booking`, `CheckoutTicket`, `BookingStatusLog` entities
- ✅ `ProductDefinition` entity (for `durationMinutes`)

## Tasks

### 1. Create `src/booking/application/handlers/process-checkout.handler.ts`

This handler is a **RabbitMQ message consumer** using `@MessagePattern('checkout.process')`.

**Logic:**
```
1. Receive message: { ticketId, staffId, startTime, userId, productId, webhookUrl }

2. Load ticket from DB → update status to PROCESSING

3. Build Redis key: lock:checkout:{staffId}_{date}_{time}
   Attempt: redisService.acquireLock(key, 600)

4A. If lock ACQUIRED (Success path):
    - Begin DB transaction
    - Load ProductDefinition for durationMinutes (if productId provided)
    - Create Booking:
      - status: PENDING_PAYMENT
      - endTime: startTime + durationMinutes
      - paymentUrl: placeholder URL
      - paymentExpiresAt: now() + 10 minutes
    - Save Booking
    - Create BookingStatusLog: null → PENDING_PAYMENT
    - Update ticket: status = SUCCESS, bookingId = booking.id
    - Commit transaction
    - Call WebhookService.notify(webhookUrl, successPayload)

4B. If lock DENIED (Failure path):
    - Update ticket: status = FAILED, errorMessage = 'Slot already taken by another booking'
    - Call WebhookService.notify(webhookUrl, failPayload)

5. ACK the message (both paths — don't requeue deterministic failures)
```

**Webhook payloads:**
```typescript
// Success
{
  ticket_id: ticketId,
  status: 'SUCCESS',
  data: {
    booking_id: booking.id,
    payment_url: booking.paymentUrl,
    expires_at: booking.paymentExpiresAt,
  },
  error: null,
}

// Failure
{
  ticket_id: ticketId,
  status: 'FAILED',
  data: null,
  error: 'Slot already taken by another booking',
}
```

### 2. Register as RabbitMQ consumer in `booking.module.ts`
The handler uses `@MessagePattern` or `@EventPattern` from `@nestjs/microservices`.

### 3. Configure hybrid application in `main.ts`
To consume RabbitMQ messages, the NestJS app needs to be a **hybrid application**:
```typescript
// main.ts — after app.listen()
app.connectMicroservice({
  transport: Transport.RMQ,
  options: {
    urls: [process.env.RABBITMQ_URL],
    queue: process.env.RABBITMQ_QUEUE_CHECKOUT,
    queueOptions: { durable: true },
    noAck: false,
    prefetchCount: 1,
  },
});
await app.startAllMicroservices();
```

## Key Design Notes

- **Optimistic Locking**: The `Booking` entity has `@VersionColumn`. If two workers try to create the same booking concurrently, TypeORM throws `OptimisticLockVersionMismatchError`
- **Transaction**: The entire success path (create booking + update ticket + log) runs in a single `QueryRunner` transaction
- **ACK always**: Even on failure, we ACK the message. Deterministic failures (slot taken) should not be retried

## Completed

_To be filled when done._
