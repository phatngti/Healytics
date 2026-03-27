# 03 — Redis Lock Handlers (Micro-Lock + Slot Check)

**Status:** ✅ COMPLETED

## Context

With the module shell ready (todo 02), this todo implements the **Level 1 — Micro-Lock** from the TDD. When the AI chatbot suggests a time slot to the customer, it calls this API to temporarily hide the slot from others.

## Prerequisites

- ✅ Todo 01 — DTOs (`MicroLockDto`, `MicroLockResponseDto`)
- ✅ Todo 02 — Module shell, controller, service facade
- ✅ `RedisService` with `acquireLock()`, `releaseLock()`, `getLockTTL()` in `src/redis/`

## Redis Key Format

```
lock:intent:{staffId}_{YYYY-MM-DD}_{HH:mm}   → TTL: 120 seconds
lock:checkout:{staffId}_{YYYY-MM-DD}_{HH:mm}  → TTL: 600 seconds (used in todo 04)
```

## Tasks

### 1. Create `src/booking/application/handlers/acquire-micro-lock.handler.ts`

```typescript
@Injectable()
export class AcquireMicroLockHandler {
  constructor(private readonly redisService: RedisService) {}

  async execute(dto: MicroLockDto): Promise<MicroLockResponseDto> {
    const dateStr = format startTime to 'YYYY-MM-DD_HH:mm'
    const key = `lock:intent:${dto.staffId}_${dateStr}`;
    const token = await this.redisService.acquireLock(key, 120);
    return { locked: token !== null, expiresIn: 120 };
  }
}
```

### 2. Create `src/booking/application/handlers/check-slot-availability.handler.ts`

```typescript
@Injectable()
export class CheckSlotAvailabilityHandler {
  constructor(
    @InjectRepository(Booking) private bookingRepo: Repository<Booking>,
    private readonly redisService: RedisService,
  ) {}

  async execute(staffId: string, startTime: Date): Promise<boolean> {
    // 1. Check DB for existing non-cancelled booking
    const existing = await this.bookingRepo.findOne({
      where: {
        staffId, startTime,
        status: Not(In([BookingStatus.CANCELLED]))
      }
    });
    if (existing) return false;

    // 2. Check Redis for checkout lock
    const dateStr = format(startTime);
    const ttl = await this.redisService.getLockTTL(`lock:checkout:${staffId}_${dateStr}`);
    return ttl <= 0; // available if no lock
  }
}
```

### 3. Wire into `BookingService` and `SlotsController`
- Add handler to module providers
- Connect `BookingService.acquireMicroLock()` → handler
- Implement `SlotsController.microLock()` endpoint (remove `NotImplementedException`)

## Completed

_To be filled when done._
