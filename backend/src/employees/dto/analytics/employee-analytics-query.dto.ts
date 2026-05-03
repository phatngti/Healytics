import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';

export class EmployeeAnalyticsQueryDto {
  @ApiPropertyOptional({
    enum: DashboardTimePeriod,
    enumName: 'DashboardTimePeriod',
    default: DashboardTimePeriod.THIS_MONTH,
    description: 'Time period for employee analytics aggregation',
  })
  @IsOptional()
  @IsEnum(DashboardTimePeriod)
  period?: DashboardTimePeriod = DashboardTimePeriod.THIS_MONTH;
}
