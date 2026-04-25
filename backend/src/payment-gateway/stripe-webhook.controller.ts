import {
  Body,
  HttpCode,
  HttpStatus,
  Logger,
  Post,
  Headers,
  RawBody,
  BadRequestException,
} from '@nestjs/common';
import { ApiOperation, ApiNoContentResponse } from '@nestjs/swagger';
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { Public } from '@/common/decorators/auth/public.decorator';
import { StripePaymentService } from './stripe-payment.service';

/**
 * Public Stripe webhook endpoint.
 *
 * - Public endpoint (không yêu cầu JWT).
 * - Luôn trả 204 No Content (ACK).
 * - Server-to-server, Flutter KHÔNG gọi.
 *
 * Stripe sẽ POST event data đến đây khi
 * giao dịch hoàn tất (thành công/thất bại).
 *
 * Cần raw body để xác thực webhook signature.
 */
@PublicApi('stripe')
export class StripeWebhookController {
  private readonly logger = new Logger(StripeWebhookController.name);

  constructor(private readonly stripeService: StripePaymentService) {}

  @Public()
  @Post('webhook')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Stripe webhook callback (server-to-server)' })
  @ApiNoContentResponse({ description: 'Webhook acknowledged' })
  async handleStripeWebhook(
    @RawBody() rawBody: Buffer,
    @Headers('stripe-signature') signature: string,
  ): Promise<void> {
    if (!signature) {
      this.logger.warn('Stripe webhook missing signature header');
      throw new BadRequestException('Missing stripe-signature header');
    }

    this.logger.log('Stripe webhook received');
    await this.stripeService.handleWebhookEvent(rawBody, signature);
    // Luôn trả 204 — KHÔNG throw exception
  }
}
