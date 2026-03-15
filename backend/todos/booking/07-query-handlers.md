# 07 — Query Handlers (Get Booking, Get Ticket, List Bookings)

**Status:** ✅ COMPLETED

## Context

With the write path complete (todos 03-06), this todo adds the read endpoints. These are straightforward DB queries returning response DTOs.

## Prerequisites

- ✅ Todo 01 — Response DTOs (`BookingResponseDto`, `CheckoutTicketResponseDto`)
- ✅ Todo 02 — Module shell, controller, service
- ✅ Entities with relations set up

## Tasks

### 1. Create `src/booking/application/handlers/get-booking.handler.ts`

```typescript
async execute(id: string): Promise<BookingResponseDto> {
  const booking = await bookingRepo.findOne({
    where: { id },
    relations: ['user', 'staff', 'product'],
  });
  if (!booking) throw new NotFoundException(`Booking ${id} not found`);
  return BookingResponseDto.fromEntity(booking);
}
```

### 2. Create `src/booking/application/handlers/get-checkout-ticket.handler.ts`

```typescript
async execute(id: string): Promise<CheckoutTicketResponseDto> {
  const ticket = await ticketRepo.findOne({
    where: { id },
    relations: ['booking'],
  });
  if (!ticket) throw new NotFoundException(`Ticket ${id} not found`);
  return CheckoutTicketResponseDto.fromEntity(ticket);
}
```

### 3. Create `src/booking/application/handlers/list-user-bookings.handler.ts`

```typescript
async execute(userId: string, page = 1, limit = 10): Promise<BookingResponseDto[]> {
  const bookings = await bookingRepo.find({
    where: { userId },
    relations: ['staff', 'product'],
    order: { startTime: 'DESC' },
    skip: (page - 1) * limit,
    take: limit,
  });
  return bookings.map(BookingResponseDto.fromEntity);
}
```

### 4. Wire all handlers into `BookingService` and `BookingController`
- Register handlers in module providers
- Connect service facade methods
- Implement controller endpoints (remove `NotImplementedException`)

## Completed

_To be filled when done._
