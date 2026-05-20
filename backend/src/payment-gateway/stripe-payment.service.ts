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
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingPaymentService } from './booking-payment.service';
import { Account } from '@/common/entities/account.entity';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { UserPaymentCustomer } from '@/common/entities/user-payment-customer.entity';
import { UserPaymentMethod } from '@/common/entities/user-payment-method.entity';
import { PaymentMethod } from './enums/payment-method.enum';
import { PaymentStatus } from './enums/payment-status.enum';
import { TransactionAction } from './enums/transaction-action.enum';
import {
  CreateStripeSetupIntentResponseDto,
  SavedPaymentCardDto,
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
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,
    @InjectRepository(PaymentTransactionLog)
    private readonly txLogRepo: Repository<PaymentTransactionLog>,
    @InjectRepository(UserPaymentCustomer)
    private readonly customerRepo: Repository<UserPaymentCustomer>,
    @InjectRepository(UserPaymentMethod)
    private readonly cardRepo: Repository<UserPaymentMethod>,
  ) {
    const secretKey =
      this.configService.getOrThrow<string>('STRIPE_SECRET_KEY');
    this.webhookSecret = this.configService.getOrThrow<string>(
      'STRIPE_WEBHOOK_SECRET',
    );
    this.currency = this.configService.get<string>('STRIPE_CURRENCY', 'vnd');

    this.stripe = new Stripe(secretKey, {
      apiVersion: '2026-04-22.dahlia',
    });
  }

  async listCards(userId: string): Promise<SavedPaymentCardDto[]> {
    const cards = await this.cardRepo.find({
      where: { userId, provider: PaymentMethod.STRIPE },
      order: { isDefault: 'DESC', createdAt: 'DESC' },
    });

    return cards.map((card) => this.toCardDto(card));
  }

  async createSetupIntent(
    userId: string,
  ): Promise<CreateStripeSetupIntentResponseDto> {
    const customer = await this.ensureStripeCustomer(userId);
    const setupIntent = await this.stripe.setupIntents.create({
      customer: customer.gatewayCustomerId,
      payment_method_types: ['card'],
      usage: 'on_session',
      metadata: { userId },
    });

    return CreateStripeSetupIntentResponseDto.create({
      setupIntentId: setupIntent.id,
      clientSecret: setupIntent.client_secret!,
    });
  }

  async confirmSetupIntent(
    setupIntentId: string,
    userId: string,
    setDefault: boolean,
  ): Promise<SavedPaymentCardDto> {
    const customer = await this.ensureStripeCustomer(userId);
    const setupIntent = await this.stripe.setupIntents.retrieve(setupIntentId);

    if (
      this.resolveCustomerId(setupIntent.customer) !==
      customer.gatewayCustomerId
    ) {
      throw new BadRequestException('SetupIntent does not belong to this user');
    }

    if (setupIntent.status !== 'succeeded') {
      throw new BadRequestException(
        `SetupIntent is not ready: ${setupIntent.status}`,
      );
    }

    const paymentMethodId = this.resolvePaymentMethodId(
      setupIntent.payment_method,
    );
    if (!paymentMethodId) {
      throw new BadRequestException('SetupIntent has no payment method');
    }

    const stripePaymentMethod =
      await this.stripe.paymentMethods.retrieve(paymentMethodId);

    if (!stripePaymentMethod.card) {
      throw new BadRequestException('Only card payment methods are supported');
    }

    let card = await this.cardRepo.findOne({
      where: { gatewayPaymentMethodId: paymentMethodId },
      withDeleted: true,
    });

    if (card && card.userId !== userId) {
      throw new BadRequestException('Payment method is already registered');
    }

    const existingCardCount = await this.cardRepo.count({
      where: { userId, provider: PaymentMethod.STRIPE },
    });
    const shouldSetDefault = setDefault || existingCardCount === 0;
    const cardMetadata = this.buildCardMetadata(
      stripePaymentMethod.card,
      stripePaymentMethod,
    );

    if (card) {
      card.customerId = customer.id;
      card.provider = PaymentMethod.STRIPE;
      card.gatewayPaymentMethodId = paymentMethodId;
      card.deletedAt = null;
      Object.assign(card, cardMetadata);
    } else {
      card = this.cardRepo.create({
        userId,
        customerId: customer.id,
        provider: PaymentMethod.STRIPE,
        gatewayPaymentMethodId: paymentMethodId,
        ...cardMetadata,
      });
    }

    if (shouldSetDefault) {
      await this.clearDefaultCards(userId);
      card.isDefault = true;
    } else {
      card.isDefault = card.isDefault ?? false;
    }

    const saved = await this.cardRepo.save(card);
    return this.toCardDto(saved);
  }

  async setDefaultCard(
    userId: string,
    cardId: string,
  ): Promise<SavedPaymentCardDto> {
    const card = await this.cardRepo.findOne({
      where: { id: cardId, userId, provider: PaymentMethod.STRIPE },
    });

    if (!card) {
      throw new NotFoundException(`Saved card not found: ${cardId}`);
    }

    await this.clearDefaultCards(userId);
    card.isDefault = true;
    return this.toCardDto(await this.cardRepo.save(card));
  }

  async deleteCard(
    userId: string,
    cardId: string,
  ): Promise<SavedPaymentCardDto[]> {
    const card = await this.cardRepo.findOne({
      where: { id: cardId, userId, provider: PaymentMethod.STRIPE },
    });

    if (!card) {
      throw new NotFoundException(`Saved card not found: ${cardId}`);
    }

    try {
      await this.stripe.paymentMethods.detach(card.gatewayPaymentMethodId);
    } catch (error) {
      this.logger.warn(
        `Failed to detach Stripe payment method ${card.gatewayPaymentMethodId}: ${
          error instanceof Error ? error.message : 'Unknown error'
        }`,
      );
    }

    const wasDefault = card.isDefault;
    await this.cardRepo.softDelete({ id: card.id, userId });

    if (wasDefault) {
      const nextDefault = await this.cardRepo.findOne({
        where: { userId, provider: PaymentMethod.STRIPE },
        order: { createdAt: 'DESC' },
      });
      if (nextDefault) {
        nextDefault.isDefault = true;
        await this.cardRepo.save(nextDefault);
      }
    }

    return this.listCards(userId);
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
    cardId?: string,
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

    const paymentIntentParams: StripeClient.PaymentIntentCreateParams = {
      amount,
      currency: this.currency,
      metadata: {
        bookingId: booking.id,
        paymentId: savedPayment.id,
        userId,
      },
    };

    if (cardId) {
      const { card, customer } = await this.resolveSavedCard(userId, cardId);
      paymentIntentParams.customer = customer.gatewayCustomerId;
      paymentIntentParams.payment_method = card.gatewayPaymentMethodId;
      paymentIntentParams.payment_method_types = ['card'];
    } else {
      paymentIntentParams.automatic_payment_methods = { enabled: true };
    }

    // 2. Create Stripe PaymentIntent
    const paymentIntent =
      await this.stripe.paymentIntents.create(paymentIntentParams);

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
          cardId,
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

  private async ensureStripeCustomer(
    userId: string,
  ): Promise<UserPaymentCustomer> {
    const existing = await this.customerRepo.findOne({
      where: { userId, provider: PaymentMethod.STRIPE },
    });
    if (existing) return existing;

    const account = await this.accountRepo.findOne({ where: { id: userId } });
    if (!account) {
      throw new NotFoundException(`Account not found: ${userId}`);
    }

    const customer = await this.stripe.customers.create({
      email: account.email,
      metadata: { userId },
    });

    return this.customerRepo.save(
      this.customerRepo.create({
        userId,
        provider: PaymentMethod.STRIPE,
        gatewayCustomerId: customer.id,
      }),
    );
  }

  private async clearDefaultCards(userId: string): Promise<void> {
    await this.cardRepo.update(
      { userId, provider: PaymentMethod.STRIPE },
      { isDefault: false },
    );
  }

  private async resolveSavedCard(
    userId: string,
    cardId: string,
  ): Promise<{ card: UserPaymentMethod; customer: UserPaymentCustomer }> {
    const card = await this.cardRepo.findOne({
      where: { id: cardId, userId, provider: PaymentMethod.STRIPE },
    });
    if (!card) {
      throw new NotFoundException(`Saved card not found: ${cardId}`);
    }

    const customer = await this.customerRepo.findOne({
      where: { id: card.customerId, userId, provider: PaymentMethod.STRIPE },
    });
    if (!customer) {
      throw new NotFoundException('Payment customer not found for saved card');
    }

    return { card, customer };
  }

  private resolvePaymentMethodId(
    paymentMethod: string | StripeClient.PaymentMethod | null,
  ): string | null {
    if (!paymentMethod) return null;
    return typeof paymentMethod === 'string' ? paymentMethod : paymentMethod.id;
  }

  private resolveCustomerId(
    customer:
      | string
      | StripeClient.Customer
      | StripeClient.DeletedCustomer
      | null,
  ): string | null {
    if (!customer) return null;
    return typeof customer === 'string' ? customer : customer.id;
  }

  private buildCardMetadata(
    card: StripeClient.PaymentMethod.Card,
    paymentMethod: StripeClient.PaymentMethod,
  ): Pick<
    UserPaymentMethod,
    'brand' | 'last4' | 'expMonth' | 'expYear' | 'funding' | 'country'
  > {
    return {
      brand: card.brand,
      last4: card.last4,
      expMonth: card.exp_month,
      expYear: card.exp_year,
      funding: card.funding ?? null,
      country:
        card.country ?? paymentMethod.billing_details?.address?.country ?? null,
    };
  }

  private toCardDto(card: UserPaymentMethod): SavedPaymentCardDto {
    return SavedPaymentCardDto.create({
      id: card.id,
      brand: card.brand,
      last4: card.last4,
      expMonth: card.expMonth,
      expYear: card.expYear,
      funding: card.funding,
      country: card.country,
      isDefault: card.isDefault,
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
        BookingStatusReasonCode.PAYMENT_REFUND_STRIPE_CANCELLED,
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
        BookingStatusReasonCode.PAYMENT_CONFIRMED_STRIPE,
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

    this.logger.warn(`Webhook failed: ${paymentIntent.id} - ${failureMessage}`);
  }
}
