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
import { formatSlotKey } from '../../utils/slot-key.util';

const CHECKOUT_LOCK_TTL_SECONDS = 600; // 10 minutes

interface CheckoutMessage {
  ticketId: string;
  staffId: string;
  startTime: string;
  userId: string;
  productId?: string;
  webhookUrl?: string;
  /** Pre-acquired lock token from CreateCheckoutTicketHandler (may be null for old messages) */
  lockToken?: string;
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
    const msgContext = `ticket=${data.ticketId}, user=${data.userId}, staff=${data.staffId}, time=${data.startTime}`;
    this.logger.log(`Processing checkout: ${msgContext}`);
    const channel = context.getChannelRef();
    const originalMsg = context.getMessage();

    try {
      // 1. Update ticket → PROCESSING
      try {
        await this.ticketRepo.update(data.ticketId, {
          status: CheckoutTicketStatus.PROCESSING,
        });
      } catch (dbError) {
        this.logger.error(
          `DB error updating ticket to PROCESSING — ${msgContext}`,
          dbError.stack,
        );
        throw dbError;
      }

      // 2. Validate or acquire checkout lock
      const startDate = new Date(data.startTime);
      const dateStr = formatSlotKey(startDate);
      const lockKey = `lock:checkout:${data.staffId}_${dateStr}`;

      let effectiveLockToken: string | null = data.lockToken ?? null;

      if (effectiveLockToken) {
        // Pre-lock exists — validate it's still ours
        try {
          const isValid = await this.redisService.validateLock(
            lockKey,
            effectiveLockToken,
          );
          if (!isValid) {
            // Lock expired or was stolen — try to re-acquire
            this.logger.warn(
              `Pre-lock expired or invalid — key=${lockKey}, ${msgContext}, attempting re-acquire`,
            );
            effectiveLockToken = await this.redisService.acquireLock(
              lockKey,
              CHECKOUT_LOCK_TTL_SECONDS,
            );
          }
        } catch (redisError) {
          this.logger.error(
            `Redis lock validation failed — key=${lockKey}, ${msgContext}`,
            redisError.stack,
          );
          // Try to re-acquire as fallback
          try {
            effectiveLockToken = await this.redisService.acquireLock(
              lockKey,
              CHECKOUT_LOCK_TTL_SECONDS,
            );
          } catch (acquireError) {
            this.logger.error(
              `Redis lock re-acquire also failed — key=${lockKey}, ${msgContext}`,
              acquireError.stack,
            );
            throw acquireError;
          }
        }
      } else {
        // No pre-lock (backwards compat / Redis was down at creation time)
        this.logger.debug(
          `No pre-lock token — falling back to acquireLock: ${lockKey}`,
        );
        try {
          effectiveLockToken = await this.redisService.acquireLock(
            lockKey,
            CHECKOUT_LOCK_TTL_SECONDS,
          );
        } catch (redisError) {
          this.logger.error(
            `Redis lock acquisition failed — key=${lockKey}, ${msgContext}`,
            redisError.stack,
          );
          throw redisError;
        }
      }

      if (effectiveLockToken) {
        // ── SUCCESS PATH ───────────────────────────
        await this.handleSuccess(data, startDate, lockKey);
      } else {
        // ── FAILURE PATH ───────────────────────────
        await this.handleFailure(data, 'Slot already taken by another booking');
      }
    } catch (error) {
      this.logger.error(
        `Checkout processing error — ${msgContext}, payload=${JSON.stringify(data)}: ${error.message}`,
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
    const msgContext = `ticket=${data.ticketId}, user=${data.userId}, staff=${data.staffId}`;
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
        `Booking created: ${savedBooking.id} for ${msgContext}`,
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
      try {
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
      } catch (notifError) {
        this.logger.error(
          `RabbitMQ notification emit failed — ${msgContext}, bookingId=${savedBooking.id}, notificationType=${NotificationType.BOOKING_CONFIRMED}`,
          notifError.stack,
        );
        // Don't throw — booking is already committed
      }
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Transaction failed — ${msgContext}, payload=${JSON.stringify(data)}: ${error.message}`,
        error.stack,
      );
      // Release the lock since we failed
      try {
        await this.redisService.releaseLock(lockKey, '');
      } catch (redisError) {
        this.logger.error(
          `Redis lock release failed — key=${lockKey}, ${msgContext}`,
          redisError.stack,
        );
      }
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  private async handleFailure(
    data: CheckoutMessage,
    errorMessage: string,
  ): Promise<void> {
    const msgContext = `ticket=${data.ticketId}, user=${data.userId}, staff=${data.staffId}`;

    try {
      await this.ticketRepo.update(data.ticketId, {
        status: CheckoutTicketStatus.FAILED,
        errorMessage,
      });
    } catch (dbError) {
      this.logger.error(
        `DB error updating ticket to FAILED — ${msgContext}, originalError="${errorMessage}"`,
        dbError.stack,
      );
    }

    this.logger.warn(
      `Checkout failed: ${msgContext}: ${errorMessage}`,
    );

    const webhookPayload: WebhookPayload = {
      ticket_id: data.ticketId,
      status: 'FAILED',
      data: null,
      error: errorMessage,
    };
    await this.webhookService.notify(data.webhookUrl ?? null, webhookPayload);
  }
}
