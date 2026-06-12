import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { StaffScheduleEntryDto } from '../dto/response/staff-schedule-entry.dto';

/** Maps internal EmployeeRole enum values to display labels */
const ROLE_LABELS: Record<string, string> = {
  DOCTOR: 'Doctor',
  THERAPIST: 'Spa Therapist',
  RECEPTIONIST: 'Receptionist',
  MANAGER: 'Manager',
};

@Injectable()
export class GetStaffScheduleHandler {
  private readonly logger = new Logger(GetStaffScheduleHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    date: string,
  ): Promise<StaffScheduleEntryDto[]> {
    this.logger.log(
      `Getting staff schedule for partner: ${partnerId}, date: ${date}`,
    );

    // Parse date and create day window
    const parsedDate = new Date(date);
    const dayStart = new Date(parsedDate);
    dayStart.setHours(0, 0, 0, 0);
    const dayEnd = new Date(parsedDate);
    dayEnd.setHours(23, 59, 59, 999);

    const rows = await this.dataSource.query(
      `SELECT
        e.id          AS employee_id,
        e.full_name   AS employee_name,
        e.role,
        b.start_time,
        b.end_time,
        p.name        AS service_name,
        CONCAT(up.first_name, ' ', up.last_name) AS patient_name
      FROM bookings b
      JOIN employees e ON b.staff_id = e.id
      LEFT JOIN products p ON b.product_id = p.id
      LEFT JOIN user_profile up ON b.user_id = up.account_id
      WHERE e.partner_id = $1
        AND b.start_time >= $2
        AND b.start_time <= $3
        AND b.status IN ('CONFIRMED', 'COMPLETED')
        AND b.deleted_at IS NULL
      ORDER BY e.full_name ASC, b.start_time ASC`,
      [partnerId, dayStart, dayEnd],
    );

    return rows.map((row: any) => {
      const dto = new StaffScheduleEntryDto();
      dto.employeeId = row.employee_id;
      dto.employeeName = row.employee_name;
      dto.role = ROLE_LABELS[row.role] ?? row.role;
      dto.startTime = new Date(row.start_time).toISOString();
      dto.endTime = row.end_time
        ? new Date(row.end_time).toISOString()
        : dto.startTime;
      dto.serviceName = row.service_name ?? 'Unknown Service';
      dto.patientName = (row.patient_name ?? '').trim() || undefined;
      return dto;
    });
  }
}
