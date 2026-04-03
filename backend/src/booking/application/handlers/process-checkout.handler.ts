import { Controller, Logger } from '@nestjs/common';
import { Ctx, EventPattern, Payload, RmqContext } from '@nestjs/microservices';
import { DataSource } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { CheckoutTicketStatus } from '@/booking/enums/checkout-ticket-status.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { NotificationType } from '@/notification/enums/notification-type.enum';
import { NotificationEventService } from '@/notification/services/notification-event.service';
import { RedisService } from '@/redis/redis.service';
import { WebhookService, WebhookPayload } from '../../services/webhook.service';

const CHECKOUT_LOCK_TTL_SECONDS = 600; // 10 minutes

interface CheckoutMessage {
  ticketId: string;
  staffId: string;
  startTime: string;
  userId: string;
  productId?: string;
  webhookUrl?: string;
}

@Controller()
export class ProcessCheckoutHandler {
  private readonly logger = new Logger(ProcessCheckoutHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    @InjectRepository(CheckoutTicket)
    private readonly ticketRepo: Repository<CheckoutTicket>,
    private readonly redisService: RedisService,
    private readonly webhookService: WebhookService,
    private readonly notificationEventService: NotificationEventService,
  ) {}

  @EventPattern('checkout.process')
  async handle(
    @Payload() data: CheckoutMessage,
    @Ctx() context: RmqContext,
  ): Promise<void> {
    this.logger.log(`Processing checkout: ticket=${data.ticketId}`);
    const channel = context.getChannelRef();
    const originalMsg = context.getMessage();

    try {
      // 1. Update ticket → PROCESSING
      await this.ticketRepo.update(data.ticketId, {
        status: CheckoutTicketStatus.PROCESSING,
      });

      // 2. Attempt checkout lock
      const startDate = new Date(data.startTime);
      const dateStr = this.formatSlotKey(startDate);
      const lockKey = `lock:checkout:${data.staffId}_${dateStr}`;

      const lockToken = await this.redisService.acquireLock(
        lockKey,
        CHECKOUT_LOCK_TTL_SECONDS,
      );

      if (lockToken) {
        // ── SUCCESS PATH ───────────────────────────
        await this.handleSuccess(data, startDate, lockKey);
      } else {
        // ── FAILURE PATH ───────────────────────────
        await this.handleFailure(data, 'Slot already taken by another booking');
      }
    } catch (error) {
      this.logger.error(
        `Checkout processing error: ticket=${data.ticketId}: ${error.message}`,
        error.stack,
      );
      await this.handleFailure(data, `Internal error: ${error.message}`);
    } finally {
      // Always ACK — don't requeue deterministic failures
      channel.ack(originalMsg);
    }
  }

  private async handleSuccess(
    data: CheckoutMessage,
    startDate: Date,
    lockKey: string,
  ): Promise<void> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    let savedBooking: Booking | null = null;
    let serviceName: string | null = null;

    try {
      // Calculate endTime from product definition
      let endTime: Date | null = null;
      if (data.productId) {
        const definition = await queryRunner.manager.findOne(
          ProductDefinition,
          { where: { productId: data.productId }, relations: ['product'] },
        );
        if (definition?.durationMinutes) {
          endTime = new Date(
            startDate.getTime() + definition.durationMinutes * 60 * 1000,
          );
        }
        if ((definition as any)?.product?.name) {
          serviceName = (definition as any).product.name as string;
        }
      }

      // Create booking
      const paymentExpiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 min
      const booking = queryRunner.manager.create(Booking, {
        userId: data.userId,
        staffId: data.staffId,
        productId: data.productId || null,
        startTime: startDate,
        endTime,
        status: BookingStatus.PENDING_PAYMENT,
        paymentUrl: null, // Will be set by payment service later
        paymentExpiresAt,
      });
      savedBooking = await queryRunner.manager.save(Booking, booking);

      // Create status log
      const log = queryRunner.manager.create(BookingStatusLog, {
        bookingId: savedBooking.id,
        fromStatus: null,
        toStatus: BookingStatus.PENDING_PAYMENT,
        changedBy: 'system',
        reason: 'Checkout completed successfully',
      });
      await queryRunner.manager.save(BookingStatusLog, log);

      // Update ticket → SUCCESS
      await queryRunner.manager.update(CheckoutTicket, data.ticketId, {
        status: CheckoutTicketStatus.SUCCESS,
        bookingId: savedBooking.id,
      });

      await queryRunner.commitTransaction();
      this.logger.log(
        `Booking created: ${savedBooking.id} for ticket=${data.ticketId}`,
      );

      // Notify webhook (fire-and-forget, outside transaction)
      const webhookPayload: WebhookPayload = {
        ticket_id: data.ticketId,
        status: 'SUCCESS',
        data: {
          booking_id: savedBooking.id,
          payment_url: savedBooking.paymentUrl ?? '',
          expires_at: paymentExpiresAt.toISOString(),
        },
        error: null,
      };
      await this.webhookService.notify(data.webhookUrl ?? null, webhookPayload);

      // Send booking confirmation notification (fire-and-forget, outside transaction)
      this.notificationEventService.emit({
        type: NotificationType.BOOKING_CONFIRMED,
        recipientId: data.userId,
        title: 'Booking Confirmed! 🎉',
        body: serviceName
          ? `Your booking for "${serviceName}" on ${startDate.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })} has been confirmed. Please complete your payment.`
          : `Your booking on ${startDate.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })} has been confirmed. Please complete your payment.`,
        data: {
          bookingId: savedBooking.id,
          action: 'view_booking',
        },
      });
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Transaction failed for ticket=${data.ticketId}: ${error.message}`,
        error.stack,
      );
      // Release the lock since we failed
      await this.redisService.releaseLock(lockKey, '');
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  private async handleFailure(
    data: CheckoutMessage,
    errorMessage: string,
  ): Promise<void> {
    await this.ticketRepo.update(data.ticketId, {
      status: CheckoutTicketStatus.FAILED,
      errorMessage,
    });

    this.logger.warn(
      `Checkout failed: ticket=${data.ticketId}: ${errorMessage}`,
    );

    const webhookPayload: WebhookPayload = {
      ticket_id: data.ticketId,
      status: 'FAILED',
      data: null,
      error: errorMessage,
    };
    await this.webhookService.notify(data.webhookUrl ?? null, webhookPayload);
  }

  private formatSlotKey(date: Date): string {
    const yyyy = date.getUTCFullYear();
    const mm = String(date.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(date.getUTCDate()).padStart(2, '0');
    const hh = String(date.getUTCHours()).padStart(2, '0');
    const min = String(date.getUTCMinutes()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}_${hh}${min}`;
  }
}
