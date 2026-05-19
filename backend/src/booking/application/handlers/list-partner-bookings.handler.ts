import {
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BookingAccessService } from '@/booking/services/booking-access.service';
import { PartnerBookingResponseDto } from '@/booking/dto/partner/partner-booking-response.dto';

@Injectable()
export class ListPartnerBookingsHandler {
  private readonly logger = new Logger(ListPartnerBookingsHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly bookingAccessService: BookingAccessService,
  ) {}

  async list(accountId: string): Promise<PartnerBookingResponseDto[]> {
    const partnerId =
      await this.bookingAccessService.resolvePartnerIdForAccount(accountId);
    if (!partnerId) {
      throw new ForbiddenException('Forbidden: partner profile not found');
    }

    this.logger.log(`Listing partner bookings: partner=${partnerId}`);
    const rows = await this.queryRows(partnerId);
    return rows.map(PartnerBookingResponseDto.fromRow);
  }

  async get(
    accountId: string,
    bookingId: string,
  ): Promise<PartnerBookingResponseDto> {
    const partnerId =
      await this.bookingAccessService.resolvePartnerIdForAccount(accountId);
    if (!partnerId) {
      throw new ForbiddenException('Forbidden: partner profile not found');
    }

    const rows = await this.queryRows(partnerId, bookingId);
    const row = rows[0];
    if (!row) {
      throw new NotFoundException(`Booking with ID ${bookingId} not found`);
    }
    return PartnerBookingResponseDto.fromRow(row);
  }

  private queryRows(partnerId: string, bookingId?: string) {
    const params = bookingId ? [partnerId, bookingId] : [partnerId];
    return this.dataSource.query(
      `
      SELECT
        b.id,
        b.status,
        b.user_id AS "customerId",
        NULLIF(TRIM(CONCAT(COALESCE(up.first_name, ''), ' ', COALESCE(up.last_name, ''))), '') AS "customerFullName",
        account.email AS "customerEmail",
        up.date_of_birth AS "customerDateOfBirth",
        up.avatar_url AS "customerAvatarUrl",
        e.id AS "specialistId",
        e.full_name AS "specialistFullName",
        COALESCE(e.job_title, e.role::text) AS "specialistRoleLabel",
        e.avatar_url AS "specialistAvatarUrl",
        p.id AS "serviceId",
        p.name AS "serviceName",
        c.name AS "categoryName",
        COALESCE(p.sale_price, p.base_price, 0) AS price,
        COALESCE(p.currency, 'VND') AS "currencyCode",
        b.start_time AS "slotStart",
        COALESCE(
          b.end_time,
          b.start_time + (COALESCE(pd.duration_minutes, 60)::int * INTERVAL '1 minute')
        ) AS "slotEnd"
      FROM bookings b
      INNER JOIN account ON account.id = b.user_id
      LEFT JOIN user_profile up ON up.account_id = account.id
      INNER JOIN employees e ON e.id = b.staff_id
      LEFT JOIN products p ON p.id = b.product_id
      LEFT JOIN categories c ON c.id = p.category_id
      LEFT JOIN product_definitions pd ON pd.product_id = p.id
      WHERE b.deleted_at IS NULL
        AND COALESCE(e.partner_id, p.partner_id) = $1
        ${bookingId ? 'AND b.id = $2' : ''}
      ORDER BY b.start_time ASC
      `,
      params,
    );
  }
}
