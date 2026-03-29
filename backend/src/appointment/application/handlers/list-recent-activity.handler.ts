import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RecentActivityResponseDto } from '../../dto/recent-activity-response.dto';
import { RecentActivityQueryDto } from '../../dto/recent-activity-query.dto';

export interface RecentActivityResult {
  data: RecentActivityResponseDto[];
  meta: { total: number; limit: number; offset: number };
}

@Injectable()
export class ListRecentActivityHandler {
  private readonly logger = new Logger(ListRecentActivityHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    userId: string,
    query: RecentActivityQueryDto,
  ): Promise<RecentActivityResult> {
    this.logger.log(`Listing recent activity for user: ${userId}`);

    const limit = query.limit ?? 5;
    const offset = query.offset ?? 0;

    const repo = this.dataSource.getRepository(Booking);

    // ── Count total matching bookings ───────────────────────────
    const total = await repo
      .createQueryBuilder('booking')
      .where('booking.user_id = :userId', { userId })
      .andWhere('booking.status IN (:...statuses)', {
        statuses: [
          BookingStatus.CONFIRMED,
          BookingStatus.PENDING_PAYMENT,
          BookingStatus.COMPLETED,
          BookingStatus.CANCELLED,
          BookingStatus.NO_SHOW,
        ],
      })
      .getCount();

    // ── Fetch paginated bookings ───────────────────────────────
    // Sort order: upcoming (CONFIRMED/PENDING_PAYMENT) nearest-first,
    // then past (COMPLETED/CANCELLED/NO_SHOW) most-recent-first.
    // Computed sort columns as addSelect aliases to avoid TypeORM's
    // orderBy dot-parsing issue (it can't handle CASE expressions
    // containing 'booking.xxx' because it splits on dots).
    const bookings = await repo
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .leftJoinAndSelect('product.category', 'category')
      .addSelect(
        `CASE WHEN booking.status IN (:upStat1, :upStat2) THEN 0 ELSE 1 END`,
        'sort_priority',
      )
      .addSelect(
        `CASE WHEN booking.status IN (:upStat1, :upStat2) ` +
          `THEN EXTRACT(EPOCH FROM booking.start_time) ` +
          `ELSE -EXTRACT(EPOCH FROM booking.start_time) END`,
        'sort_time',
      )
      .where('booking.user_id = :userId', { userId })
      .andWhere('booking.status IN (:...statuses)', {
        statuses: [
          BookingStatus.CONFIRMED,
          BookingStatus.PENDING_PAYMENT,
          BookingStatus.COMPLETED,
          BookingStatus.CANCELLED,
          BookingStatus.NO_SHOW,
        ],
      })
      .setParameters({
        upStat1: BookingStatus.CONFIRMED,
        upStat2: BookingStatus.PENDING_PAYMENT,
      })
      .orderBy('sort_priority', 'ASC')
      .addOrderBy('sort_time', 'ASC')
      .skip(offset)
      .take(limit)
      .getMany();

    this.logger.log(`Found ${bookings.length} recent activities (total: ${total})`);

    return {
      data: RecentActivityResponseDto.fromEntities(bookings),
      meta: { total, limit, offset },
    };
  }
}
