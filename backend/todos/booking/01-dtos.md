# 01 — Request & Response DTOs

**Status:** ✅ COMPLETED

## Context

Entities and enums already exist in `src/common/entities/` and `src/booking/enums/`. This todo creates the DTO layer that defines the API contract for all booking endpoints.

## Prerequisites

- ✅ `Booking` entity (`src/common/entities/booking.entity.ts`)
- ✅ `CheckoutTicket` entity (`src/common/entities/checkout-ticket.entity.ts`)
- ✅ `BookingStatusLog` entity (`src/common/entities/booking-status-log.entity.ts`)
- ✅ `BookingStatus` enum, `CheckoutTicketStatus` enum

## Tasks

### 1. Create `src/booking/dto/micro-lock.dto.ts`
```typescript
// Request: POST /api/v1/slots/micro-lock
{
  staffId: string;    // @IsUUID()
  startTime: string;  // @IsDateString()
  productId?: string; // @IsUUID(), @IsOptional()
}
```

### 2. Create `src/booking/dto/micro-lock-response.dto.ts`
```typescript
{
  locked: boolean;
  expiresIn: number; // seconds
}
```

### 3. Create `src/booking/dto/async-checkout.dto.ts`
```typescript
// Request: POST /api/v1/bookings/async-checkout
{
  userId: string;         // @IsUUID()
  staffId: string;        // @IsUUID()
  startTime: string;      // @IsDateString()
  productId?: string;     // @IsUUID(), @IsOptional()
  idempotencyKey: string; // @IsString(), @MaxLength(255)
  webhookUrl?: string;    // @IsUrl(), @IsOptional()
}
```

### 4. Create `src/booking/dto/async-checkout-response.dto.ts`
```typescript
{
  ticketId: string;
  status: 'QUEUED';
  message: string;
}
```

### 5. Create `src/booking/dto/booking-response.dto.ts`
Response DTO with static `fromEntity(booking: Booking)` method. Fields:
- `id`, `userId`, `staffId`, `productId`, `startTime`, `endTime`
- `status`, `paymentUrl`, `paymentExpiresAt`, `notes`
- `createdAt`, `updatedAt`

### 6. Create `src/booking/dto/checkout-ticket-response.dto.ts`
Response DTO with static `fromEntity(ticket: CheckoutTicket)` method. Fields:
- `id` (= ticketId), `userId`, `staffId`, `startTime`
- `status`, `idempotencyKey`, `bookingId`, `errorMessage`
- `createdAt`, `updatedAt`

## Validation Rules

- Use `class-validator` decorators on all request DTOs
- Use `@ApiProperty()` from `@nestjs/swagger` on all fields
- Response DTOs use static `fromEntity()` pattern (not `class-transformer`)

## Completed

_To be filled when done._
