import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

export interface WebhookPayload {
  ticket_id: string;
  status: 'SUCCESS' | 'FAILED';
  data: {
    booking_id: string;
    payment_url: string;
    expires_at: string;
  } | null;
  error: string | null;
}

@Injectable()
export class WebhookService {
  private readonly logger = new Logger(WebhookService.name);

  constructor(private readonly httpService: HttpService) {}

  /**
   * Fire-and-forget POST to the webhook URL.
   * Retries up to 3 times with exponential backoff.
   * Never throws — logs errors instead.
   */
  async notify(url: string | null, payload: WebhookPayload): Promise<void> {
    if (!url) {
      this.logger.debug('No webhook URL configured, skipping notification');
      return;
    }

    for (let attempt = 1; attempt <= 3; attempt++) {
      try {
        await firstValueFrom(
          this.httpService.post(url, payload, { timeout: 5000 }),
        );
        this.logger.log(`Webhook delivered to ${url} (attempt ${attempt})`);
        return;
      } catch (error) {
        this.logger.warn(
          `Webhook attempt ${attempt}/3 failed for ${url}: ${error.message}`,
        );
        if (attempt < 3) {
          await this.sleep(attempt * 1000);
        }
      }
    }
    this.logger.error(`Webhook exhausted all 3 retries for ${url}`);
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
