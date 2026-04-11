import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpcomingAppointmentDto } from '../dto/response/upcoming-appointment.dto';

@Injectable()
export class ListUpcomingAppointmentsHandler {
  private readonly logger = new Logger(ListUpcomingAppointmentsHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    limit: number,
  ): Promise<UpcomingAppointmentDto[]> {
    this.logger.log(
      `Listing upcoming appointments for partner: ${partnerId}, limit: ${limit}`,
    );

    const rows = await this.dataSource.query(
      `SELECT
        b.id,
        b.status,
        b.start_time,
        p.name          AS service_name,
        e.full_name     AS employee_name,
        up.first_name,
        up.last_name
      FROM bookings b
      JOIN employees e ON b.staff_id = e.id
      LEFT JOIN products p ON b.product_id = p.id
      LEFT JOIN user_profile up ON b.user_id = up.account_id
      WHERE e.partner_id = $1
        AND b.status IN ('CONFIRMED', 'PENDING_PAYMENT')
        AND b.start_time >= NOW()
        AND b.deleted_at IS NULL
      ORDER BY b.start_time ASC
      LIMIT $2`,
      [partnerId, limit],
    );

    return rows.map((row: any) => {
      const dto = new UpcomingAppointmentDto();
      dto.id = row.id;
      dto.patientName = this.buildName(row.first_name, row.last_name);
      dto.serviceName = row.service_name ?? 'Unknown Service';
      dto.employeeName = row.employee_name;
      dto.scheduledAt = new Date(row.start_time).toISOString();
      dto.status = row.status === 'CONFIRMED' ? 'confirmed' : 'pending';
      return dto;
    });
  }

  private buildName(
    firstName?: string | null,
    lastName?: string | null,
  ): string {
    return [firstName, lastName].filter(Boolean).join(' ').trim() || 'Unknown';
  }
}
