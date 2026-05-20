import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { CheckDuplicateSlotResponseDto } from '../../dto/check-duplicate-slot-response.dto';

@Injectable()
export class CheckDuplicateSlotHandler {
  private readonly logger = new Logger(CheckDuplicateSlotHandler.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
  ) {}

  /**
   * Check if the authenticated user already has a non-cancelled booking
   * at the given startTime. A user cannot be serviced by two different
   * services/specialists at the same time.
   */
  async execute(
    userId: string,
    startTime: string,
  ): Promise<CheckDuplicateSlotResponseDto> {
    const parsedTime = new Date(startTime);

    this.logger.log(
      `Checking duplicate slot: user=${userId}, time=${startTime}`,
    );

    try {
      const conflicting = await this.bookingRepo
        .createQueryBuilder('booking')
        .leftJoinAndSelect('booking.product', 'product')
        .leftJoinAndSelect('booking.staff', 'staff')
        .where('booking.userId = :userId', { userId })
        .andWhere('booking.startTime = :startTime', { startTime: parsedTime })
        .andWhere('booking.status NOT IN (:...excludedStatuses)', {
          excludedStatuses: [BookingStatus.CANCELLED],
        })
        .getOne();

      if (conflicting) {
        const serviceName = conflicting.product?.name ?? 'Unknown service';
        this.logger.warn(
          `Duplicate slot found: user=${userId}, booking=${conflicting.id}, service="${serviceName}"`,
        );
        return new CheckDuplicateSlotResponseDto(
          true,
          serviceName,
          conflicting.id,
        );
      }

      this.logger.debug(`No duplicate slot: user=${userId}, time=${startTime}`);
      return new CheckDuplicateSlotResponseDto(false);
    } catch (error) {
      this.logger.error(
        `DB error checking duplicate slot — userId=${userId}, startTime=${startTime}`,
        error.stack,
      );
      throw error;
    }
  }
}
