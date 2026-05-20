import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { AppointmentResponseDto } from '../../dto/appointment-response.dto';
import {
  ListAppointmentsQueryDto,
  AppointmentSortOrder,
} from '../../dto/list-appointments-query.dto';
import { AppointmentStatus } from '../../enums/appointment-status.enum';

@Injectable()
export class ListAppointmentsHandler {
  private readonly logger = new Logger(ListAppointmentsHandler.name);

  /**
   * Maps a frontend AppointmentStatus back to the DB-level BookingStatus values.
   */
  private mapToBookingStatuses(status: AppointmentStatus): BookingStatus[] {
    switch (status) {
      case AppointmentStatus.PENDING_PAYMENT:
        return [BookingStatus.PENDING_PAYMENT];
      case AppointmentStatus.UPCOMING:
        return [BookingStatus.CONFIRMED];
      case AppointmentStatus.PROCESSING:
        return [BookingStatus.IN_PROGRESS];
      case AppointmentStatus.COMPLETED:
        return [BookingStatus.COMPLETED];
      case AppointmentStatus.CANCELED:
        return [BookingStatus.CANCELLED, BookingStatus.NO_SHOW];
    }
  }

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    userId: string,
    query?: ListAppointmentsQueryDto,
  ): Promise<AppointmentResponseDto[]> {
    this.logger.log(`Listing appointments for user: ${userId}`);

    const hasCoordinates = query?.latitude != null && query?.longitude != null;

    const qb = this.dataSource
      .getRepository(Booking)
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.product', 'product')
      .leftJoinAndSelect('product.partner', 'productPartner')
      .leftJoinAndSelect('product.category', 'category')
      .leftJoinAndSelect('product.media', 'media')
      .leftJoinAndSelect('product.productDefinition', 'productDefinition')
      .leftJoinAndSelect('booking.staff', 'staff')
      .leftJoinAndSelect('staff.partner', 'partner')
      .leftJoinAndSelect('partner.ward', 'ward')
      .leftJoinAndSelect('partner.district', 'district')
      .leftJoinAndSelect('partner.province', 'province')
      .where('booking.user_id = :userId', { userId });

    // ── Filter by status ────────────────────────────────────────
    if (query?.status) {
      const bookingStatuses = this.mapToBookingStatuses(query.status);
      qb.andWhere('booking.status IN (:...bookingStatuses)', {
        bookingStatuses,
      });

      if (
        query.status === AppointmentStatus.PENDING_PAYMENT ||
        query.status === AppointmentStatus.UPCOMING
      ) {
        const now = new Date();
        qb.andWhere('booking.start_time >= :now', { now });

        if (query.status === AppointmentStatus.PENDING_PAYMENT) {
          qb.andWhere(
            '(booking.payment_expires_at IS NULL OR booking.payment_expires_at >= :now)',
            { now },
          );
        }
      }
    }

    // ── Filter by category ──────────────────────────────────────
    if (query?.categoryId) {
      qb.andWhere('product.category_id = :categoryId', {
        categoryId: query.categoryId,
      });
    }

    // ── Sort by time ────────────────────────────────────────────
    const sortDirection =
      query?.sortBy === AppointmentSortOrder.OLDEST ? 'ASC' : 'DESC';
    qb.orderBy('booking.start_time', sortDirection);

    if (hasCoordinates) {
      qb.addSelect(
        `ST_Distance(partner.location, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326))`,
        'distance_meters',
      ).setParameters({
        lat: query.latitude,
        lng: query.longitude,
      });
    }

    const rawAndEntities = await qb.getRawAndEntities();
    const { entities, raw } = rawAndEntities;

    this.logger.log(`Found ${entities.length} appointments`);

    return entities.map((booking, index) => {
      // Build address from partner location hierarchy
      const partner = booking.staff?.partner;
      const addressParts = [
        partner?.streetAddress,
        partner?.ward?.fullName,
        partner?.district?.fullName,
        partner?.province?.fullName,
      ].filter(Boolean);
      const clinicAddress = addressParts.join(', ');

      const distanceMeters = hasCoordinates
        ? parseFloat(raw[index]?.distance_meters) || -1
        : -1;

      return AppointmentResponseDto.fromEntity(booking, {
        clinicAddress,
        distanceMeters,
      });
    });
  }
}
