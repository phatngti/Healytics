import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThan } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RedisService } from '@/redis/redis.service';
import { NotificationService } from '@/notification/notification.service';
import { NotificationType } from '@/notification/enums/notification-type.enum';

/**
 * CRON-based scheduler that checks for upcoming appointments
 * and sends reminder notifications 30 minutes before.
 *
 * Deduplication: Uses a Redis key `reminder:sent:{bookingId}` with 1-hour TTL
 * to prevent duplicate reminders on subsequent CRON runs.
 */
@Injectable()
export class AppointmentReminderService {
  private readonly logger = new Logger(AppointmentReminderService.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    private readonly redisService: RedisService,
    private readonly notificationService: NotificationService,
  ) {}

  /**
   * Runs every 5 minutes. Scans for confirmed bookings starting
   * within the next 30 minutes and sends reminder notifications.
   */
  @Cron(CronExpression.EVERY_5_MINUTES)
  async checkUpcomingAppointments(): Promise<void> {
    const now = new Date();
    const thirtyMinutesLater = new Date(now.getTime() + 30 * 60 * 1000);

    this.logger.debug(
      `Scanning for upcoming appointments: now=${now.toISOString()} window=${thirtyMinutesLater.toISOString()}`,
    );

    const upcomingBookings = await this.bookingRepo
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .where('booking.status = :status', { status: BookingStatus.CONFIRMED })
      .andWhere('booking.startTime > :now', { now })
      .andWhere('booking.startTime <= :window', {
        window: thirtyMinutesLater,
      })
      .andWhere('booking.deletedAt IS NULL')
      .getMany();

    this.logger.log(
      `Found ${upcomingBookings.length} upcoming booking(s) within 30-minute window`,
    );

    for (const booking of upcomingBookings) {
      const redisKey = `reminder:sent:${booking.id}`;

      // Check if reminder was already sent (deduplication)
      const alreadySent = await this.redisService.get(redisKey);
      if (alreadySent) {
        this.logger.debug(
          `Reminder already sent for booking ${booking.id} — skipping`,
        );
        continue;
      }

      try {
        const serviceName = booking.product?.name ?? 'your appointment';
        const startTime = booking.startTime.toLocaleTimeString('en-US', {
          hour: '2-digit',
          minute: '2-digit',
        });

        await this.notificationService.createAndPushNotification({
          recipientId: booking.userId,
          type: NotificationType.APPOINTMENT_REMINDER,
          title: 'Appointment Reminder',
          body: `Your appointment for ${serviceName} starts at ${startTime}. Please arrive on time.`,
          data: {
            bookingId: booking.id,
            action: 'view_appointment',
          },
        });

        // Mark as sent with 1-hour TTL to prevent duplicates
        await this.redisService.set(redisKey, '1', 3600);

        this.logger.log(
          `Reminder sent for booking ${booking.id} (user: ${booking.userId})`,
        );
      } catch (error) {
        this.logger.error(
          `Failed to send reminder for booking ${booking.id}: ${(error as Error).message}`,
        );
      }
    }
  }
}
