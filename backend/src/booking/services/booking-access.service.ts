import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';
import { Role } from '@/account/enum/role.enum';

export interface BookingOwnershipSnapshot {
  bookingId: string;
  userId: string;
  specialistId: string;
  partnerId: string | null;
}

export interface EmployeeOwnershipSnapshot {
  id: string;
  partnerId: string | null;
}

interface CurrentJwtUser {
  id: string;
  role: Role;
}

@Injectable()
export class BookingAccessService {
  constructor(private readonly dataSource: DataSource) {}

  async assertCanAccessBooking(
    user: CurrentJwtUser,
    bookingId: string,
    manager: EntityManager = this.dataSource.manager,
  ): Promise<BookingOwnershipSnapshot> {
    const booking = await this.getBookingOwnership(bookingId, manager);

    if (user.role === Role.USER) {
      if (booking.userId !== user.id) this.throwForbidden();
      return booking;
    }

    if (user.role === Role.EMPLOYEE) {
      const employee = await this.resolveEmployeeForAccount(user.id, manager);
      if (!employee || booking.specialistId !== employee.id) {
        this.throwForbidden();
      }
      return booking;
    }

    if (user.role === Role.HEALTH_PARTNER) {
      const partnerId = await this.resolvePartnerIdForAccount(user.id, manager);
      if (!partnerId || booking.partnerId !== partnerId) {
        this.throwForbidden();
      }
      return booking;
    }

    this.throwForbidden();
  }

  async getBookingOwnership(
    bookingId: string,
    manager: EntityManager = this.dataSource.manager,
  ): Promise<BookingOwnershipSnapshot> {
    const rows = await manager.query(
      `
      SELECT
        b.id AS "bookingId",
        b.user_id AS "userId",
        b.staff_id AS "specialistId",
        COALESCE(e.partner_id, p.partner_id) AS "partnerId"
      FROM bookings b
      LEFT JOIN employees e ON e.id = b.staff_id
      LEFT JOIN products p ON p.id = b.product_id
      WHERE b.id = $1
        AND b.deleted_at IS NULL
      LIMIT 1
      `,
      [bookingId],
    );

    const row = rows[0];
    if (!row) {
      throw new NotFoundException(`Booking with ID ${bookingId} not found`);
    }
    return row;
  }

  async resolveEmployeeForAccount(
    accountId: string,
    manager: EntityManager = this.dataSource.manager,
  ): Promise<EmployeeOwnershipSnapshot | null> {
    const rows = await manager.query(
      `
      SELECT id, partner_id AS "partnerId"
      FROM employees
      WHERE account_id = $1
        AND deleted_at IS NULL
      LIMIT 1
      `,
      [accountId],
    );
    return rows[0] ?? null;
  }

  async resolvePartnerIdForAccount(
    accountId: string,
    manager: EntityManager = this.dataSource.manager,
  ): Promise<string | null> {
    const rows = await manager.query(
      `
      SELECT id
      FROM health_partner_profile
      WHERE account_id = $1
        AND deleted_at IS NULL
      LIMIT 1
      `,
      [accountId],
    );
    return rows[0]?.id ?? null;
  }

  private throwForbidden(): never {
    throw new ForbiddenException('Forbidden: booking ownership check failed');
  }
}
