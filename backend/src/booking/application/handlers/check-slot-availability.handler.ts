import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Not, In } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RedisService } from '@/redis/redis.service';
import { formatSlotKey } from '../../utils/slot-key.util';

@Injectable()
export class CheckSlotAvailabilityHandler {
  private readonly logger = new Logger(CheckSlotAvailabilityHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    private readonly redisService: RedisService,
  ) {}

  /**
   * Check if a slot is available for booking.
   * Checks both the DB (existing non-cancelled bookings) and Redis (checkout locks).
   */
  async execute(staffId: string, startTime: Date): Promise<boolean> {
    // 1. Check DB for existing non-cancelled booking
    try {
      const existing = await this.bookingRepo.findOne({
        where: {
          staffId,
          startTime,
          status: Not(In([BookingStatus.CANCELLED, BookingStatus.COMPLETED])),
        },
      });

      if (existing) {
        this.logger.debug(
          `Slot unavailable (DB): staff=${staffId}, time=${startTime.toISOString()}, booking=${existing.id}`,
        );
        return false;
      }
    } catch (error) {
      this.logger.error(
        `DB error checking slot availability — staffId=${staffId}, startTime=${startTime.toISOString()}`,
        error.stack,
      );
      throw error;
    }

    // 2. Check Redis for active checkout lock
    const dateStr = formatSlotKey(startTime);
    const key = `lock:checkout:${staffId}_${dateStr}`;

    try {
      const ttl = await this.redisService.getLockTTL(key);

      if (ttl > 0) {
        this.logger.debug(
          `Slot unavailable (Redis checkout lock): ${key}, TTL=${ttl}s`,
        );
        return false;
      }
    } catch (error) {
      this.logger.error(
        `Redis error checking lock TTL — key=${key}, staffId=${staffId}, startTime=${startTime.toISOString()}`,
        error.stack,
      );
      throw error;
    }

    this.logger.debug(
      `Slot available: staff=${staffId}, time=${startTime.toISOString()}`,
    );
    return true;
  }
}
