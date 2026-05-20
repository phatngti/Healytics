import {
  Body,
  Delete,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
} from '@nestjs/common';
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
  ConfirmStripeSetupIntentDto,
  CreateStripePaymentDto,
  CreateStripeSetupIntentResponseDto,
  MoMoPaymentResponseDto,
  MoMoRefundResponseDto,
  SavedPaymentCardDto,
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

  @Get('cards')
  @ApiOperation({ summary: 'List saved payment cards' })
  @ApiOkResponse({ type: SavedPaymentCardDto, isArray: true })
  async listCards(
    @CurrentUser('id') userId: string,
  ): Promise<SavedPaymentCardDto[]> {
    return this.stripeService.listCards(userId);
  }

  @Post('stripe/setup-intents')
  @ApiOperation({ summary: 'Create Stripe SetupIntent for adding a card' })
  @ApiCreatedResponse({ type: CreateStripeSetupIntentResponseDto })
  async createStripeSetupIntent(
    @CurrentUser('id') userId: string,
  ): Promise<CreateStripeSetupIntentResponseDto> {
    return this.stripeService.createSetupIntent(userId);
  }

  @Post('stripe/setup-intents/:setupIntentId/confirm')
  @ApiOperation({ summary: 'Confirm and persist a saved Stripe card' })
  @ApiOkResponse({ type: SavedPaymentCardDto })
  @ApiBadRequestResponse({ description: 'SetupIntent is not valid/succeeded' })
  async confirmStripeSetupIntent(
    @Param('setupIntentId') setupIntentId: string,
    @CurrentUser('id') userId: string,
    @Body() dto: ConfirmStripeSetupIntentDto,
  ): Promise<SavedPaymentCardDto> {
    return this.stripeService.confirmSetupIntent(
      setupIntentId,
      userId,
      dto.setDefault === true,
    );
  }

  @Patch('cards/:cardId/default')
  @ApiOperation({ summary: 'Set a saved card as the default card' })
  @ApiOkResponse({ type: SavedPaymentCardDto })
  @ApiNotFoundResponse({ description: 'Saved card not found' })
  async setDefaultCard(
    @Param('cardId', ParseUUIDPipe) cardId: string,
    @CurrentUser('id') userId: string,
  ): Promise<SavedPaymentCardDto> {
    return this.stripeService.setDefaultCard(userId, cardId);
  }

  @Delete('cards/:cardId')
  @ApiOperation({ summary: 'Delete a saved payment card' })
  @ApiOkResponse({ type: SavedPaymentCardDto, isArray: true })
  @ApiNotFoundResponse({ description: 'Saved card not found' })
  async deleteCard(
    @Param('cardId', ParseUUIDPipe) cardId: string,
    @CurrentUser('id') userId: string,
  ): Promise<SavedPaymentCardDto[]> {
    return this.stripeService.deleteCard(userId, cardId);
  }

  /**
   * Create a Stripe PaymentIntent for a booking.
   *
   * Returns `clientSecret` — Flutter uses Stripe SDK to
   * confirm payment on-device with the saved debit/credit card.
   *
   * ```dart
   * final resp = await api.post('/payments/stripe/$bookingId');
   * await Stripe.instance.confirmPayment(
   *   paymentIntentClientSecret: resp.clientSecret,
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
    @Body() dto: CreateStripePaymentDto,
  ): Promise<StripePaymentResponseDto> {
    return this.stripeService.createPayment(bookingId, userId, dto.cardId);
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
