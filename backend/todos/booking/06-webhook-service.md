# 06 — Webhook Service

**Status:** ✅ COMPLETED

## Context

The webhook service is used by the worker (todo 05) to notify the AI/Frontend of the checkout result. It's a fire-and-forget HTTP POST with retry logic.

## Prerequisites

- ✅ Todo 02 — Module shell (HttpModule imported)

## Tasks

### 1. Create `src/booking/services/webhook.service.ts`

```typescript
@Injectable()
export class WebhookService {
  constructor(private readonly httpService: HttpService) {}

  /**
   * Fire-and-forget POST to the webhook URL.
   * Retries up to 3 times with exponential backoff.
   * Never throws — logs errors instead.
   */
  async notify(url: string | null, payload: WebhookPayload): Promise<void> {
    if (!url) return; // no webhook configured

    for (let attempt = 1; attempt <= 3; attempt++) {
      try {
        await firstValueFrom(
          this.httpService.post(url, payload, { timeout: 5000 })
        );
        logger.log(`Webhook delivered to ${url}`);
        return;
      } catch (error) {
        logger.warn(`Webhook attempt ${attempt}/3 failed: ${error.message}`);
        if (attempt < 3) {
          await sleep(attempt * 1000); // 1s, 2s backoff
        }
      }
    }
    logger.error(`Webhook exhausted all retries for ${url}`);
  }
}
```

### 2. Define `WebhookPayload` interface
```typescript
interface WebhookPayload {
  ticket_id: string;
  status: 'SUCCESS' | 'FAILED';
  data: {
    booking_id: string;
    payment_url: string;
    expires_at: string; // ISO 8601
  } | null;
  error: string | null;
}
```

### 3. Register in `booking.module.ts` providers

## Completed

_To be filled when done._
