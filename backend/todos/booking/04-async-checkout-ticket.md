# 04 — Async Checkout (Ticket Creation + RabbitMQ Publish)

**Status:** ✅ COMPLETED

## Context

This is the entry point for the async checkout flow (Step 2 in the TDD). When the customer confirms ("Ok đặt cho mình"), the AI calls this API. The server creates a ticket, publishes a message to RabbitMQ, and returns `202 Accepted` immediately.

## Prerequisites

- ✅ Todo 01 — DTOs (`AsyncCheckoutDto`, `AsyncCheckoutResponseDto`)
- ✅ Todo 02 — Module shell
- ✅ Todo 03 — Lock handlers (for slot availability pre-check)
- ✅ `RABBITMQ_CLIENT` provided by `RabbitMQModule`

## Tasks

### 1. Create `src/booking/application/handlers/create-checkout-ticket.handler.ts`

**Logic:**
```
1. Idempotency check:
   - Query checkout_tickets WHERE idempotency_key = dto.idempotencyKey
   - If found → return existing ticket (don't create duplicate)

2. Optional pre-check:
   - Call CheckSlotAvailabilityHandler
   - If slot not available → return FAILED immediately (skip queue)

3. Create CheckoutTicket entity:
   - status: QUEUED
   - Save to DB

4. Publish to RabbitMQ:
   - Pattern: 'checkout.process'
   - Payload: { ticketId, staffId, startTime, userId, productId, webhookUrl }

5. Return { ticketId: ticket.id, status: 'QUEUED', message: '...' }
```

**RabbitMQ publish pattern:**
```typescript
this.rmqClient.emit('checkout.process', {
  ticketId: ticket.id,
  staffId: dto.staffId,
  startTime: dto.startTime,
  userId: dto.userId,
  productId: dto.productId,
  webhookUrl: dto.webhookUrl,
});
```

### 2. Wire into `BookingService` and `BookingController`
- Add handler to module providers
- Connect `BookingService.asyncCheckout()` → handler
- Implement `BookingController.asyncCheckout()` endpoint
- Use `@HttpCode(HttpStatus.ACCEPTED)` for 202 response

### 3. Inject `RABBITMQ_CLIENT` into the handler
```typescript
constructor(
  @Inject('RABBITMQ_CLIENT') private readonly rmqClient: ClientProxy,
  @InjectRepository(CheckoutTicket) private ticketRepo: Repository<CheckoutTicket>,
  private readonly slotChecker: CheckSlotAvailabilityHandler,
)
```

## Completed

_To be filled when done._
