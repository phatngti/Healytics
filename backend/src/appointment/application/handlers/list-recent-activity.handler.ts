import { Injectable, Logger } from '@nestjs/common';
import { DataSource, SelectQueryBuilder } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { RecentActivityResponseDto } from '../../dto/recent-activity-response.dto';
import {
  RecentActivityQueryDto,
  RecentActivitySort,
} from '../../dto/recent-activity-query.dto';

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
    const statuses = this.resolveStatuses(query.status);

    const repo = this.dataSource.getRepository(Booking);

    // ── Count total matching bookings ───────────────────────────
    const countQb = repo
      .createQueryBuilder('booking')
      .leftJoin('booking.product', 'product')
      .where('booking.user_id = :userId', { userId })
      .andWhere('booking.status IN (:...statuses)', { statuses });
    this.applyFilters(countQb, query);
    const total = await countQb.getCount();

    // ── Fetch paginated bookings ───────────────────────────────
    // Sort order: upcoming (CONFIRMED/PENDING_PAYMENT) nearest-first,
    // then past (COMPLETED/CANCELLED/NO_SHOW) most-recent-first.
    // Computed sort columns as addSelect aliases to avoid TypeORM's
    // orderBy dot-parsing issue (it can't handle CASE expressions
    // containing 'booking.xxx' because it splits on dots).
    const bookingsQb = repo
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('product.partner', 'partner')
      .leftJoinAndSelect('partner.province', 'province')
      .leftJoinAndSelect('partner.district', 'district')
      .leftJoinAndSelect('booking.staff', 'staff')
      .leftJoinAndSelect('staff.partner', 'staffPartner')
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
      .andWhere('booking.status IN (:...statuses)', { statuses })
      .setParameters({
        upStat1: BookingStatus.CONFIRMED,
        upStat2: BookingStatus.PENDING_PAYMENT,
      })
      .skip(offset)
      .take(limit);

    this.applyFilters(bookingsQb, query);
    this.applySort(bookingsQb, query);

    const bookings = await bookingsQb.getMany();

    this.logger.log(
      `Found ${bookings.length} recent activities (total: ${total})`,
    );

    return {
      data: RecentActivityResponseDto.fromEntities(bookings),
      meta: { total, limit, offset },
    };
  }

  private resolveStatuses(raw?: string): BookingStatus[] {
    if (!raw) {
      return [
        BookingStatus.CONFIRMED,
        BookingStatus.PENDING_PAYMENT,
        BookingStatus.COMPLETED,
        BookingStatus.CANCELLED,
        BookingStatus.NO_SHOW,
      ];
    }
    const normalized = raw.toUpperCase();
    if (normalized === 'SCHEDULED' || normalized === 'UPCOMING') {
      return [BookingStatus.CONFIRMED];
    }
    if (normalized === 'CANCELED' || normalized === 'CANCELLED') {
      return [BookingStatus.CANCELLED, BookingStatus.NO_SHOW];
    }
    if (normalized === 'PROCESSING') {
      return [BookingStatus.IN_PROGRESS];
    }
    if (normalized in BookingStatus) {
      return [BookingStatus[normalized as keyof typeof BookingStatus]];
    }
    return [
      BookingStatus.CONFIRMED,
      BookingStatus.PENDING_PAYMENT,
      BookingStatus.COMPLETED,
      BookingStatus.CANCELLED,
      BookingStatus.NO_SHOW,
    ];
  }

  private applyFilters(
    qb: SelectQueryBuilder<Booking>,
    query: RecentActivityQueryDto,
  ) {
    if (query.categoryId) {
      qb.andWhere(
        `product.category_id IN (
          SELECT category_filter.id
          FROM categories category_filter
          WHERE category_filter.deleted_at IS NULL
            AND category_filter.is_active = true
            AND (
              category_filter.id = :categoryId
              OR category_filter.parent_id = :categoryId
            )
        )`,
        { categoryId: query.categoryId },
      );
    }
    if (query.clinicId) {
      qb.andWhere('product.partner_id = :clinicId', {
        clinicId: query.clinicId,
      });
    }
    if (query.fromDate) {
      qb.andWhere('booking.start_time >= :fromDate', {
        fromDate: new Date(query.fromDate),
      });
    }
    if (query.toDate) {
      qb.andWhere('booking.start_time <= :toDate', {
        toDate: new Date(query.toDate),
      });
    }
  }

  private applySort(
    qb: SelectQueryBuilder<Booking>,
    query: RecentActivityQueryDto,
  ) {
    if (query.sort === RecentActivitySort.DATE_ASC) {
      qb.orderBy('booking.startTime', 'ASC');
      return;
    }
    if (query.sort === RecentActivitySort.DATE_DESC) {
      qb.orderBy('booking.startTime', 'DESC');
      return;
    }
    qb.orderBy('sort_priority', 'ASC').addOrderBy('sort_time', 'ASC');
  }
}
