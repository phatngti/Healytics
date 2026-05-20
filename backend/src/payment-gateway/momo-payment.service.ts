import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { v4 as uuidv4 } from 'uuid';
import {
  MoMoIPNDto,
  MoMoPaymentRequestDto,
  MoMoPaymentResponseDto,
  MoMoRefundRequestDto,
  MoMoRefundResponseDto,
} from './dto';
import {
  createPaymentRawSignature,
  createRefundRawSignature,
  signHmacSha256,
  verifyIPNSignature,
} from './utils/momo.security';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { BookingStatusReasonCode } from '@/booking/enums/booking-status-reason-code.enum';
import { BookingPaymentService } from './booking-payment.service';
import { NotificationEventService } from '@/notification/services/notification-event.service';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { Product } from '@/common/entities/product.entity';
import { PaymentMethod } from './enums/payment-method.enum';
import { PaymentStatus } from './enums/payment-status.enum';
import { TransactionAction } from './enums/transaction-action.enum';

@Injectable()
export class MoMoPaymentService {
  private readonly logger = new Logger(MoMoPaymentService.name);

  private readonly partnerCode: string;
  private readonly accessKey: string;
  private readonly secretKey: string;
  private readonly endpoint: string;
  private readonly ipnUrl: string;
  private readonly momoRedirectUrl: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly bookingPaymentService: BookingPaymentService,
    private readonly notificationEventService: NotificationEventService,
    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,
    @InjectRepository(PaymentTransactionLog)
    private readonly txLogRepo: Repository<PaymentTransactionLog>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
  ) {
    this.partnerCode = this.configService.getOrThrow('MOMO_PARTNER_CODE');
    this.accessKey = this.configService.getOrThrow('MOMO_ACCESS_KEY');
    this.secretKey = this.configService.getOrThrow('MOMO_SECRET_KEY');
    this.endpoint = this.configService.getOrThrow('MOMO_ENDPOINT');
    this.ipnUrl = this.configService.getOrThrow('MOMO_IPN_URL');
    this.momoRedirectUrl = this.configService.getOrThrow('MOMO_REDIRECT_URL');
  }

  private buildRedirectUrl(bookingId: string): string {
    const redirectUrl = new URL(this.momoRedirectUrl);
    redirectUrl.searchParams.set('bookingId', bookingId);
    return redirectUrl.toString();
  }

  private normalizeCallbackPayload(payload: MoMoIPNDto): MoMoIPNDto {
    return {
      ...payload,
      amount: this.toNullableNumber(payload.amount) ?? Number.NaN,
      responseTime: this.toNullableNumber(payload.responseTime) ?? Number.NaN,
      resultCode: this.toNullableNumber(payload.resultCode) ?? Number.NaN,
      transId: this.toNullableNumber(payload.transId) ?? Number.NaN,
    };
  }

  private toNullableNumber(value: unknown): number | null {
    if (value === null || value === undefined || value === '') return null;
    const numberValue =
      typeof value === 'number' ? value : Number(String(value).trim());
    return Number.isFinite(numberValue) ? numberValue : null;
  }

  private toNullableInt(value: unknown): number | null {
    const numberValue = this.toNullableNumber(value);
    return numberValue === null ? null : Math.trunc(numberValue);
  }

  private hasRequiredCallbackFields(payload: MoMoIPNDto): boolean {
    const requiredStrings = [
      payload.partnerCode,
      payload.orderId,
      payload.requestId,
      payload.orderInfo,
      payload.orderType,
      payload.message,
      payload.payType,
      payload.extraData,
      payload.signature,
    ];

    return (
      requiredStrings.every((value) => typeof value === 'string') &&
      Number.isFinite(payload.amount) &&
      Number.isFinite(payload.responseTime) &&
      Number.isFinite(payload.resultCode) &&
      Number.isFinite(payload.transId)
    );
  }

  /**
   * Create a MoMo payment link for a booking.
   *
   * Flow:
   * 1. Resolve booking & amount
   * 2. Create Payment record (status=UNPAID)
   * 3. Call MoMo /create API
   * 4. Log CREATE_PAYMENT in PaymentTransactionLog
   * 5. Update Payment with payUrl, gatewayOrderId
   */
  async createPayment(
    bookingId: string,
    userId: string,
    requestType = 'captureWallet',
  ): Promise<MoMoPaymentResponseDto> {
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
      paymentMethod: PaymentMethod.MOMO,
      paymentStatus: PaymentStatus.UNPAID,
      amount,
    });
    const savedPayment = await this.paymentRepo.save(payment);

    // 2. Build MoMo request
    const suffix = uuidv4().slice(0, 5);
    const momoOrderId = `BK-${booking.id.slice(0, 8)}_${suffix}`;
    const momoRequestId = `${momoOrderId}_${uuidv4().slice(0, 5)}`;

    const request: MoMoPaymentRequestDto = {
      partnerCode: this.partnerCode,
      requestId: momoRequestId,
      amount,
      orderId: momoOrderId,
      orderInfo: `Thanh toan booking ${booking.id}`,
      redirectUrl: this.buildRedirectUrl(bookingId),
      ipnUrl: this.ipnUrl,
      extraData: bookingId,
      requestType,
      lang: 'vi',
    };

    const rawData = createPaymentRawSignature(this.accessKey, request);
    request.signature = signHmacSha256(rawData, this.secretKey);

    // 3. Call MoMo API
    const response = await this.callMoMoApi<MoMoPaymentResponseDto>(
      '/create',
      request,
    );

    // 4. Log transaction
    await this.txLogRepo.save(
      this.txLogRepo.create({
        paymentId: savedPayment.id,
        action: TransactionAction.CREATE_PAYMENT,
        gateway: PaymentMethod.MOMO,
        resultCode: response.resultCode,
        message: response.message,
        requestPayload: request as unknown as Record<string, unknown>,
        responsePayload: response as unknown as Record<string, unknown>,
        actor: userId,
      }),
    );

    // 5. Update Payment with gateway details
    if (response.resultCode === 0 && response.payUrl) {
      savedPayment.gatewayOrderId = momoOrderId;
      savedPayment.paymentUrl = response.payUrl;
      savedPayment.paymentDeeplink = response.deeplink ?? null;
      savedPayment.gatewayResultCode = response.resultCode;
      savedPayment.gatewayMessage = response.message;
      await this.paymentRepo.save(savedPayment);

      // Also update booking payment URL + deeplink
      await this.bookingPaymentService.updatePaymentLinks(
        booking.id,
        response.payUrl,
        response.deeplink ?? null,
      );
    }

    return response;
  }

  /**
   * Request a MoMo refund for a booking.
   *
   * Flow:
   * 1. Find existing Payment record
   * 2. Call MoMo /refund API
   * 3. Log REFUND_REQUESTED / REFUND_CONFIRMED
   * 4. Update Payment status to REFUND, set refundedAt
   */
  async refundPayment(
    bookingId: string,
    userId: string,
    transId: number,
  ): Promise<MoMoRefundResponseDto> {
    if (!Number.isFinite(transId) || transId <= 0) {
      throw new BadRequestException('transId is required for refund');
    }

    const booking = await this.bookingPaymentService.findByIdAndUser(
      bookingId,
      userId,
    );
    const amount =
      await this.bookingPaymentService.resolveBookingAmount(booking);

    // Find existing payment record
    const existingPayment = await this.paymentRepo.findOne({
      where: { bookingId: booking.id, paymentStatus: PaymentStatus.PAID },
    });

    const request: MoMoRefundRequestDto = {
      partnerCode: this.partnerCode,
      requestId: `REFUND_${Date.now()}`,
      amount,
      orderId: `REFUND-${booking.id.slice(0, 8)}`,
      transId,
      description: `Hoan tien booking ${booking.id}`,
      lang: 'vi',
    };

    const rawData = createRefundRawSignature(this.accessKey, request);
    request.signature = signHmacSha256(rawData, this.secretKey);

    const response = await this.callMoMoApi<MoMoRefundResponseDto>(
      '/refund',
      request,
    );

    // Log refund transaction
    if (existingPayment) {
      const action =
        response.resultCode === 0
          ? TransactionAction.REFUND_CONFIRMED
          : TransactionAction.REFUND_REQUESTED;

      await this.txLogRepo.save(
        this.txLogRepo.create({
          paymentId: existingPayment.id,
          action,
          gateway: PaymentMethod.MOMO,
          resultCode: response.resultCode,
          message: response.message,
          requestPayload: request as unknown as Record<string, unknown>,
          responsePayload: response as unknown as Record<string, unknown>,
          actor: userId,
        }),
      );

      // Update payment status if refund succeeded
      if (response.resultCode === 0) {
        existingPayment.paymentStatus = PaymentStatus.REFUND;
        existingPayment.refundedAt = new Date();
        await this.paymentRepo.save(existingPayment);
      }
    }

    // Update booking status if refund succeeded
    if (response.resultCode === 0) {
      await this.bookingPaymentService.updateBookingStatus(
        bookingId,
        BookingStatus.CANCELLED,
        userId,
        'Refund successful via MoMo',
        BookingStatusReasonCode.PAYMENT_REFUND_MOMO_CANCELLED,
      );
    }

    return response;
  }

  /**
   * Confirm the signed MoMo return payload received by the mobile app.
   *
   * This is a user-authenticated fallback for cases where Android receives the
   * redirect before MoMo's server-to-server IPN has reached this backend.
   */
  async confirmReturn(
    bookingId: string,
    userId: string,
    payload: MoMoIPNDto,
  ): Promise<void> {
    await this.bookingPaymentService.findByIdAndUser(bookingId, userId);

    const callback = this.normalizeCallbackPayload({
      ...payload,
      extraData: payload.extraData || bookingId,
    });

    if (callback.extraData !== bookingId) {
      throw new BadRequestException('MoMo return booking mismatch');
    }

    if (callback.resultCode !== 0) {
      throw new BadRequestException(
        callback.message || 'MoMo payment was not successful',
      );
    }

    const accepted = await this.handleIPN(callback);
    if (!accepted) {
      throw new BadRequestException('Invalid MoMo return signature');
    }
  }

  /**
   * Handle MoMo IPN callback.
   *
   * Flow:
   * 1. Verify signature → log IPN_VERIFIED or IPN_REJECTED
   * 2. Find Payment by gatewayOrderId
   * 3. Update Payment status to PAID, set paidAt, gatewayTransId
   * 4. Update booking status via BookingPaymentService
   */
  async handleIPN(ipn: MoMoIPNDto): Promise<boolean> {
    const callback = this.normalizeCallbackPayload(ipn);

    if (!this.hasRequiredCallbackFields(callback)) {
      this.logger.warn(
        `IPN malformed payload: orderId=${String(callback.orderId)}`,
      );
      return false;
    }

    const isValid = verifyIPNSignature(
      this.accessKey,
      this.secretKey,
      callback,
    );

    // Try to find the payment by gateway order ID
    const payment = await this.paymentRepo.findOne({
      where: { gatewayOrderId: callback.orderId },
    });

    if (!isValid) {
      this.logger.warn(`IPN invalid signature: ${callback.orderId}`);

      // Log rejection if payment exists
      if (payment) {
        await this.txLogRepo.save(
          this.txLogRepo.create({
            paymentId: payment.id,
            action: TransactionAction.IPN_REJECTED,
            gateway: PaymentMethod.MOMO,
            resultCode: this.toNullableInt(callback.resultCode),
            message: `Invalid signature: ${callback.message}`,
            requestPayload: callback as unknown as Record<string, unknown>,
            actor: 'system',
          }),
        );
      }

      return false;
    }

    const bookingId = callback.extraData;

    try {
      // Log IPN verified
      if (payment) {
        await this.txLogRepo.save(
          this.txLogRepo.create({
            paymentId: payment.id,
            action: TransactionAction.IPN_VERIFIED,
            gateway: PaymentMethod.MOMO,
            resultCode: this.toNullableInt(callback.resultCode),
            message: callback.message,
            requestPayload: callback as unknown as Record<string, unknown>,
            actor: 'system',
          }),
        );
      }

      if (callback.resultCode === 0) {
        const bookingBeforeUpdate =
          await this.bookingPaymentService.findById(bookingId);
        const shouldNotify =
          bookingBeforeUpdate.status !== BookingStatus.CONFIRMED;

        // Update Payment record
        if (payment) {
          payment.paymentStatus = PaymentStatus.PAID;
          payment.paidAt = new Date();
          payment.gatewayTransId = String(callback.transId);
          payment.gatewayResultCode = callback.resultCode;
          payment.gatewayMessage = callback.message;
          await this.paymentRepo.save(payment);
        }

        // Update booking status
        await this.bookingPaymentService.updateBookingStatus(
          bookingId,
          BookingStatus.CONFIRMED,
          'system',
          `MoMo payment confirmed: transId=${callback.transId}`,
          BookingStatusReasonCode.PAYMENT_CONFIRMED_MOMO,
        );

        // Send booking confirmation notification after payment success
        if (shouldNotify) {
          try {
            const booking =
              await this.bookingPaymentService.findById(bookingId);
            let serviceName: string | null = null;
            if (booking.productId) {
              const product = await this.productRepo.findOne({
                where: { id: booking.productId },
              });
              serviceName = product?.name ?? null;
            }

            const startDate = booking.startTime;
            const dateStr = startDate
              ? startDate.toLocaleDateString('en-US', {
                  month: 'long',
                  day: 'numeric',
                  year: 'numeric',
                })
              : 'your scheduled date';

            this.notificationEventService.emit({
              type: NotificationType.BOOKING_CONFIRMED,
              recipientId: booking.userId,
              title: 'Payment Successful! 🎉',
              body: serviceName
                ? `Your payment for "${serviceName}" on ${dateStr} has been confirmed. Your booking is now confirmed!`
                : `Your payment on ${dateStr} has been confirmed. Your booking is now confirmed!`,
              data: {
                bookingId: booking.id,
                action: 'view_booking',
              },
            });
          } catch (notifError) {
            this.logger.error(
              `Notification emit failed after MoMo IPN — bookingId=${bookingId}`,
              notifError instanceof Error ? notifError.stack : undefined,
            );
            // Don't throw — payment is already confirmed
          }
        }

        this.logger.log(
          `IPN success: ${callback.orderId} -> booking ${bookingId}`,
        );
      } else {
        this.logger.warn(
          `IPN failed: ${callback.orderId} resultCode=${callback.resultCode}`,
        );
      }
    } catch (error) {
      this.logger.error(
        `IPN processing error for booking ${bookingId}`,
        error instanceof Error ? error.stack : undefined,
      );
    }

    return true;
  }

  private async callMoMoApi<T>(path: string, body: object): Promise<T> {
    const url = `${this.endpoint}${path}`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    const data = (await response.json()) as T;
    return data;
  }
}
