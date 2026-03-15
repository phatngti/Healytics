# 02 — Module Shell & Service Facade

**Status:** ✅ COMPLETED

## Context

After DTOs are created (todo 01), we set up the module structure and service facade. This creates the wiring so handlers (todo 03-06) can be added incrementally.

## Prerequisites

- ✅ Todo 01 — DTOs created
- ✅ Entities registered in `TypeOrmModule`
- ✅ `RedisModule` and `RabbitMQModule` already global

## Tasks

### 1. Create `src/booking/booking.module.ts`
```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([Booking, CheckoutTicket, BookingStatusLog]),
    HttpModule, // for WebhookService
  ],
  controllers: [BookingController],
  providers: [
    BookingService,
    // Handlers added in subsequent todos
  ],
  exports: [BookingService],
})
```

### 2. Create `src/booking/booking.service.ts` (Facade Shell)
Empty facade with constructor injection placeholders. Methods will be added as handlers are implemented:
- `acquireMicroLock(dto)` — todo 03
- `asyncCheckout(dto)` — todo 04
- `getTicketStatus(id)` — todo 06
- `getBooking(id)` — todo 06
- `listMyBookings(userId, page, limit)` — todo 06

### 3. Create `src/booking/booking.controller.ts` (Shell)
Controller shell with endpoint stubs that throw `NotImplementedException`. Per TDD:

| Method | Path | Response |
|---|---|---|
| `POST /v1/slots/micro-lock` | JWT auth | `MicroLockResponseDto` |
| `POST /v1/bookings/async-checkout` | JWT auth | `AsyncCheckoutResponseDto` |
| `GET /v1/bookings/tickets/:id` | JWT auth | `CheckoutTicketResponseDto` |
| `GET /v1/bookings/:id` | JWT auth | `BookingResponseDto` |
| `GET /v1/bookings` | JWT auth | `BookingResponseDto[]` |

> **Note:** The `slots/micro-lock` endpoint has a different path prefix. Use a separate `@Controller({ path: 'slots', version: '1' })` (SlotsController) OR handle via a second route in the same controller.
> **Decision:** Create a separate `SlotsController` for `/slots/*` endpoints — cleaner separation.

### 4. Register `BookingModule` in `AppModule`

## Completed

_To be filled when done._
