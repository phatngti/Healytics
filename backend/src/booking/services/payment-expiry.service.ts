import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RedisService } from '@/redis/redis.service';

/**
 * CRON-based scheduler that auto-cancels bookings whose payment
 * window has expired (paymentExpiresAt < NOW() and status = PENDING_PAYMENT).
 *
 * Runs every minute. Also releases the Redis checkout slot lock
 * so the time slot becomes available for other bookings.
 */
@Injectable()
export class PaymentExpiryService {
  private readonly logger = new Logger(PaymentExpiryService.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(BookingStatusLog)
    private readonly bookingStatusLogRepo: Repository<BookingStatusLog>,
    private readonly redisService: RedisService,
  ) {}

  /**
   * Runs every minute. Finds all bookings with expired payment windows
   * and transitions them to CANCELLED.
   */
  @Cron(CronExpression.EVERY_MINUTE)
  async cancelExpiredPayments(): Promise<void> {
    const expired = await this.bookingRepo.find({
      where: {
        status: BookingStatus.PENDING_PAYMENT,
        paymentExpiresAt: LessThan(new Date()),
      },
    });

    if (expired.length === 0) return;

    this.logger.log(
      `Found ${expired.length} expired pending-payment booking(s)`,
    );

    for (const booking of expired) {
      try {
        const fromStatus = booking.status;
        booking.status = BookingStatus.CANCELLED;
        await this.bookingRepo.save(booking);

        // Log status transition for audit trail
        await this.bookingStatusLogRepo.save(
          this.bookingStatusLogRepo.create({
            bookingId: booking.id,
            fromStatus,
            toStatus: BookingStatus.CANCELLED,
            changedBy: 'system:payment-expiry',
            reason: 'Payment expired after 10-minute window',
          }),
        );

        // Release the slot lock in Redis so the time slot is available again.
        // We use `del` instead of `releaseLock` because the cron doesn't
        // hold the original lock token — the lock was acquired by the
        // checkout process. The lock's own 10-minute TTL should handle
        // most cases, but force-deleting ensures immediate availability.
        const dateStr = this.formatSlotKey(booking.startTime);
        const lockKey = `lock:checkout:${booking.staffId}_${dateStr}`;
        try {
          await this.redisService.del(lockKey);
        } catch {
          // Best-effort lock release — lock may have already expired via TTL
        }

        this.logger.log(
          `Auto-cancelled expired booking ${booking.id} (user: ${booking.userId})`,
        );
      } catch (error) {
        this.logger.error(
          `Failed to cancel expired booking ${booking.id}: ${(error as Error).message}`,
        );
      }
    }
  }

  /**
   * Formats a Date to the same slot key format used by
   * ProcessCheckoutHandler for Redis lock keys.
   */
  private formatSlotKey(date: Date): string {
    const yyyy = date.getUTCFullYear();
    const mm = String(date.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(date.getUTCDate()).padStart(2, '0');
    const hh = String(date.getUTCHours()).padStart(2, '0');
    const min = String(date.getUTCMinutes()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}_${hh}${min}`;
  }
}
