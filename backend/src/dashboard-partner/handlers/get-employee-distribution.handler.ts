import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { EmployeeDistributionDto } from '../dto/response/employee-distribution.dto';

/** Maps internal EmployeeRole enum values to display labels */
const ROLE_LABELS: Record<string, string> = {
  DOCTOR: 'Doctor',
  THERAPIST: 'Spa Therapist',
  RECEPTIONIST: 'Receptionist',
  MANAGER: 'Manager',
};

@Injectable()
export class GetEmployeeDistributionHandler {
  private readonly logger = new Logger(GetEmployeeDistributionHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(partnerId: string): Promise<EmployeeDistributionDto[]> {
    this.logger.log(
      `Getting employee distribution for partner: ${partnerId}`,
    );

    const rows = await this.dataSource.query(
      `SELECT
        role,
        status,
        COUNT(*) AS count
      FROM employees
      WHERE partner_id = $1
        AND deleted_at IS NULL
      GROUP BY role, status
      ORDER BY count DESC`,
      [partnerId],
    );

    const result: EmployeeDistributionDto[] = [];

    // Active employees grouped by role
    let onLeaveTotal = 0;

    for (const row of rows) {
      if (row.status === 'INACTIVE') {
        // Excluded from donut chart
        continue;
      }

      if (row.status === 'ON_LEAVE') {
        onLeaveTotal += parseInt(row.count) || 0;
        continue;
      }

      // ACTIVE employees — group by role
      const dto = new EmployeeDistributionDto();
      dto.role = ROLE_LABELS[row.role] ?? row.role;
      dto.count = parseInt(row.count) || 0;
      dto.status = 'active';
      result.push(dto);
    }

    // Collapse all on-leave employees into a single segment
    if (onLeaveTotal > 0) {
      const onLeaveDto = new EmployeeDistributionDto();
      onLeaveDto.role = 'On Leave';
      onLeaveDto.count = onLeaveTotal;
      onLeaveDto.status = 'on_leave';
      result.push(onLeaveDto);
    }

    return result;
  }
}
