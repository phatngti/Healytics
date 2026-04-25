import { Post, Body, Param, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { MoMoPaymentService } from './momo-payment.service';
import { StripePaymentService } from './stripe-payment.service';
import {
  CreateMoMoPaymentDto,
  CreateMoMoRefundDto,
  CreateStripePaymentDto,
  MoMoPaymentResponseDto,
  MoMoRefundResponseDto,
  StripePaymentResponseDto,
  StripeRefundResponseDto,
} from './dto';

/**
 * User-facing payment endpoints.
 *
 * All endpoints require USER authentication.
 * Route prefix: /v1/user/payments
 */
@UserApi('payments')
export class UserPaymentController {
  constructor(
    private readonly momoService: MoMoPaymentService,
    private readonly stripeService: StripePaymentService,
  ) {}

  // ── MoMo Endpoints ──────────────────────────────────────────

  /**
   * Create a MoMo payment link for a booking.
   *
   * Returns the MoMo payment URL/deeplink/QR code.
   * Client should redirect user to payUrl or open deeplink.
   */
  @Post('momo/:bookingId')
  @ApiOperation({ summary: 'Create MoMo payment for booking' })
  @ApiCreatedResponse({ type: MoMoPaymentResponseDto })
  @ApiBadRequestResponse({
    description: 'Booking not in PENDING_PAYMENT status or invalid amount',
  })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async createMoMoPayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMoMoPaymentDto,
  ): Promise<MoMoPaymentResponseDto> {
    return this.momoService.createPayment(bookingId, userId, dto.requestType);
  }

  /**
   * Request a MoMo refund for a booking.
   *
   * Requires the MoMo transId from the original payment.
   * Result is synchronous — no polling needed.
   */
  @Post('momo/:bookingId/refund')
  @ApiOperation({ summary: 'Request MoMo refund for booking' })
  @ApiOkResponse({ type: MoMoRefundResponseDto })
  @ApiBadRequestResponse({ description: 'Invalid transId' })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async refundMoMoPayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMoMoRefundDto,
  ): Promise<MoMoRefundResponseDto> {
    return this.momoService.refundPayment(bookingId, userId, dto.transId);
  }

  // ── Stripe Endpoints ────────────────────────────────────────

  /**
   * Create a Stripe PaymentIntent for a booking.
   *
   * Returns `clientSecret` — Flutter uses Stripe SDK to
   * confirm payment on-device with debit/credit card.
   *
   * ```dart
   * final resp = await api.post('/payments/stripe/$bookingId');
   * await Stripe.instance.confirmPayment(
   *   paymentIntentClientSecret: resp.clientSecret,
   *   data: PaymentMethodParams.card(...),
   * );
   * ```
   */
  @Post('stripe/:bookingId')
  @ApiOperation({ summary: 'Create Stripe payment for booking (card)' })
  @ApiCreatedResponse({ type: StripePaymentResponseDto })
  @ApiBadRequestResponse({
    description: 'Booking not in PENDING_PAYMENT status or invalid amount',
  })
  @ApiNotFoundResponse({ description: 'Booking not found' })
  async createStripePayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
    @Body() _dto: CreateStripePaymentDto,
  ): Promise<StripePaymentResponseDto> {
    return this.stripeService.createPayment(bookingId, userId);
  }

  /**
   * Request a Stripe refund for a booking.
   *
   * Refunds the full amount of the original payment.
   * No extra parameters needed — backend finds the
   * PaymentIntent ID from the existing Payment record.
   */
  @Post('stripe/:bookingId/refund')
  @ApiOperation({ summary: 'Request Stripe refund for booking' })
  @ApiOkResponse({ type: StripeRefundResponseDto })
  @ApiNotFoundResponse({
    description: 'Booking not found or no paid Stripe payment',
  })
  async refundStripePayment(
    @Param('bookingId', ParseUUIDPipe) bookingId: string,
    @CurrentUser('id') userId: string,
  ): Promise<StripeRefundResponseDto> {
    return this.stripeService.refundPayment(bookingId, userId);
  }
}

