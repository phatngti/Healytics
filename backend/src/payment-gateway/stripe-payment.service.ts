import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Stripe from 'stripe';
import type { Stripe as StripeClient } from 'stripe/cjs/stripe.core.js';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingPaymentService } from './booking-payment.service';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { PaymentMethod } from './enums/payment-method.enum';
import { PaymentStatus } from './enums/payment-status.enum';
import { TransactionAction } from './enums/transaction-action.enum';
import {
  StripePaymentResponseDto,
  StripeRefundResponseDto,
} from './dto';

@Injectable()
export class StripePaymentService {
  private readonly logger = new Logger(StripePaymentService.name);
  private readonly stripe: StripeClient;
  private readonly webhookSecret: string;
  private readonly currency: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly bookingPaymentService: BookingPaymentService,
    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,
    @InjectRepository(PaymentTransactionLog)
    private readonly txLogRepo: Repository<PaymentTransactionLog>,
  ) {
    const secretKey = this.configService.getOrThrow<string>('STRIPE_SECRET_KEY');
    this.webhookSecret = this.configService.getOrThrow<string>(
      'STRIPE_WEBHOOK_SECRET',
    );
    this.currency = this.configService.get<string>('STRIPE_CURRENCY', 'vnd');

    this.stripe = new Stripe(secretKey, {
      apiVersion: '2026-03-25.dahlia',
    });
  }

  /**
   * Create a Stripe PaymentIntent for a booking.
   *
   * Flow:
   * 1. Resolve booking & amount
   * 2. Create Payment record (status=UNPAID)
   * 3. Create Stripe PaymentIntent
   * 4. Log CREATE_PAYMENT in PaymentTransactionLog
   * 5. Update Payment with gatewayOrderId
   * 6. Return clientSecret to client
   */
  async createPayment(
    bookingId: string,
    userId: string,
  ): Promise<StripePaymentResponseDto> {
    const booking = await this.bookingPaymentService.findByIdAndUser(
      bookingId,
      userId,
    );

    if (booking.status !== BookingStatus.PENDING_PAYMENT) {
      throw new BadRequestException(
        `Booking ${booking.id} is not in PENDING_PAYMENT status`,
      );
    }

    const amount =
      await this.bookingPaymentService.resolveBookingAmount(booking);
    if (!Number.isFinite(amount) || amount <= 0) {
      throw new BadRequestException(`Booking ${booking.id} has invalid amount`);
    }

    // 1. Create Payment record
    const payment = this.paymentRepo.create({
      bookingId: booking.id,
      userId,
      paymentMethod: PaymentMethod.STRIPE,
      paymentStatus: PaymentStatus.UNPAID,
      amount,
    });
    const savedPayment = await this.paymentRepo.save(payment);

    // 2. Create Stripe PaymentIntent
    const paymentIntent = await this.stripe.paymentIntents.create({
      amount,
      currency: this.currency,
      automatic_payment_methods: { enabled: true },
      metadata: {
        bookingId: booking.id,
        paymentId: savedPayment.id,
        userId,
      },
    });

    // 3. Log transaction
    await this.txLogRepo.save(
      this.txLogRepo.create({
        paymentId: savedPayment.id,
        action: TransactionAction.CREATE_PAYMENT,
        gateway: PaymentMethod.STRIPE,
        resultCode: 0,
        message: `PaymentIntent created: ${paymentIntent.id}`,
        requestPayload: {
          amount,
          currency: this.currency,
          bookingId: booking.id,
        },
        responsePayload: {
          paymentIntentId: paymentIntent.id,
          status: paymentIntent.status,
          clientSecret: '[REDACTED]',
        },
        actor: userId,
      }),
    );

    // 4. Update Payment with gateway details
    savedPayment.gatewayOrderId = paymentIntent.id;
    savedPayment.gatewayResultCode = 0;
    savedPayment.gatewayMessage = `PaymentIntent: ${paymentIntent.status}`;
    await this.paymentRepo.save(savedPayment);

    this.logger.log(
      `Stripe PaymentIntent created: ${paymentIntent.id} for booking ${booking.id}`,
    );

    return StripePaymentResponseDto.create({
      paymentIntentId: paymentIntent.id,
      clientSecret: paymentIntent.client_secret!,
      amount,
      currency: this.currency,
      status: paymentIntent.status,
    });
  }

  /**
   * Request a Stripe refund for a booking.
   *
   * Flow:
   * 1. Find existing Payment record (PAID status)
   * 2. Call Stripe Refund API
   * 3. Log REFUND_REQUESTED / REFUND_CONFIRMED
   * 4. Update Payment status to REFUND, set refundedAt
   * 5. Update booking status to CANCELLED
   */
  async refundPayment(
    bookingId: string,
    userId: string,
  ): Promise<StripeRefundResponseDto> {
    const booking = await this.bookingPaymentService.findByIdAndUser(
      bookingId,
      userId,
    );

    // Find existing paid payment
    const existingPayment = await this.paymentRepo.findOne({
      where: {
        bookingId: booking.id,
        paymentMethod: PaymentMethod.STRIPE,
        paymentStatus: PaymentStatus.PAID,
      },
    });

    if (!existingPayment || !existingPayment.gatewayTransId) {
      throw new NotFoundException(
        `No paid Stripe payment found for booking ${bookingId}`,
      );
    }

    // Create Stripe refund
    const refund = await this.stripe.refunds.create({
      payment_intent: existingPayment.gatewayTransId,
    });

    const isSuccess = refund.status === 'succeeded';

    // Log refund transaction
    await this.txLogRepo.save(
      this.txLogRepo.create({
        paymentId: existingPayment.id,
        action: isSuccess
          ? TransactionAction.REFUND_CONFIRMED
          : TransactionAction.REFUND_REQUESTED,
        gateway: PaymentMethod.STRIPE,
        resultCode: isSuccess ? 0 : 1,
        message: `Refund ${refund.status}: ${refund.id}`,
        requestPayload: {
          paymentIntentId: existingPayment.gatewayTransId,
        },
        responsePayload: {
          refundId: refund.id,
          status: refund.status,
          amount: refund.amount,
        },
        actor: userId,
      }),
    );

    // Update payment status if refund succeeded
    if (isSuccess) {
      existingPayment.paymentStatus = PaymentStatus.REFUND;
      existingPayment.refundedAt = new Date();
      await this.paymentRepo.save(existingPayment);

      // Update booking status
      await this.bookingPaymentService.updateBookingStatus(
        bookingId,
        BookingStatus.CANCELLED,
        userId,
        'Refund successful via Stripe',
      );
    }

    this.logger.log(
      `Stripe refund ${refund.status}: ${refund.id} for booking ${bookingId}`,
    );

    return StripeRefundResponseDto.create({
      refundId: refund.id,
      amount: refund.amount,
      currency: refund.currency,
      status: refund.status ?? 'pending',
      paymentIntentId: existingPayment.gatewayTransId,
    });
  }

  /**
   * Handle Stripe webhook event.
   *
   * Flow:
   * 1. Verify webhook signature
   * 2. Process event based on type
   * 3. Update Payment + Booking status
   *
   * Supported events:
   * - `payment_intent.succeeded` → PAID + CONFIRMED
   * - `payment_intent.payment_failed` → log failure
   */
  async handleWebhookEvent(
    rawBody: Buffer,
    signature: string,
  ): Promise<boolean> {
    let event: StripeClient.Event;

    try {
      event = this.stripe.webhooks.constructEvent(
        rawBody,
        signature,
        this.webhookSecret,
      );
    } catch (error) {
      this.logger.warn(
        `Webhook signature verification failed: ${
          error instanceof Error ? error.message : 'Unknown error'
        }`,
      );
      return false;
    }

    this.logger.log(`Stripe webhook received: ${event.type} (${event.id})`);

    switch (event.type) {
      case 'payment_intent.succeeded':
        await this.handlePaymentIntentSucceeded(
          event.data.object as StripeClient.PaymentIntent,
        );
        break;

      case 'payment_intent.payment_failed':
        await this.handlePaymentIntentFailed(
          event.data.object as StripeClient.PaymentIntent,
        );
        break;

      default:
        this.logger.debug(`Unhandled webhook event type: ${event.type}`);
    }

    return true;
  }

  /**
   * Handle payment_intent.succeeded webhook event.
   *
   * Updates Payment status to PAID and Booking status to CONFIRMED.
   */
  private async handlePaymentIntentSucceeded(
    paymentIntent: StripeClient.PaymentIntent,
  ): Promise<void> {
    const payment = await this.paymentRepo.findOne({
      where: { gatewayOrderId: paymentIntent.id },
    });

    if (!payment) {
      this.logger.warn(
        `No payment found for PaymentIntent: ${paymentIntent.id}`,
      );
      return;
    }

    // Log webhook verified
    await this.txLogRepo.save(
      this.txLogRepo.create({
        paymentId: payment.id,
        action: TransactionAction.WEBHOOK_VERIFIED,
        gateway: PaymentMethod.STRIPE,
        resultCode: 0,
        message: `payment_intent.succeeded: ${paymentIntent.id}`,
        responsePayload: {
          paymentIntentId: paymentIntent.id,
          status: paymentIntent.status,
          amount: paymentIntent.amount,
        },
        actor: 'system',
      }),
    );

    // Update Payment record
    payment.paymentStatus = PaymentStatus.PAID;
    payment.paidAt = new Date();
    payment.gatewayTransId = paymentIntent.id;
    payment.gatewayResultCode = 0;
    payment.gatewayMessage = 'Payment succeeded';
    await this.paymentRepo.save(payment);

    // Update booking status
    const bookingId = paymentIntent.metadata?.bookingId;
    if (bookingId) {
      await this.bookingPaymentService.updateBookingStatus(
        bookingId,
        BookingStatus.CONFIRMED,
        'system',
        `Stripe payment confirmed: ${paymentIntent.id}`,
      );

      this.logger.log(
        `Webhook success: ${paymentIntent.id} -> booking ${bookingId}`,
      );
    }
  }

  /**
   * Handle payment_intent.payment_failed webhook event.
   *
   * Logs the failure but does NOT change booking status
   * (user can retry payment).
   */
  private async handlePaymentIntentFailed(
    paymentIntent: StripeClient.PaymentIntent,
  ): Promise<void> {
    const payment = await this.paymentRepo.findOne({
      where: { gatewayOrderId: paymentIntent.id },
    });

    if (!payment) {
      this.logger.warn(
        `No payment found for failed PaymentIntent: ${paymentIntent.id}`,
      );
      return;
    }

    const failureMessage =
      paymentIntent.last_payment_error?.message ?? 'Payment failed';

    // Log webhook event
    await this.txLogRepo.save(
      this.txLogRepo.create({
        paymentId: payment.id,
        action: TransactionAction.WEBHOOK_VERIFIED,
        gateway: PaymentMethod.STRIPE,
        resultCode: 1,
        message: `payment_intent.payment_failed: ${failureMessage}`,
        responsePayload: {
          paymentIntentId: paymentIntent.id,
          status: paymentIntent.status,
          errorCode: paymentIntent.last_payment_error?.code,
          errorMessage: failureMessage,
        },
        actor: 'system',
      }),
    );

    // Update payment with error details
    payment.gatewayResultCode = 1;
    payment.gatewayMessage = failureMessage;
    await this.paymentRepo.save(payment);

    this.logger.warn(
      `Webhook failed: ${paymentIntent.id} - ${failureMessage}`,
    );
  }
}
