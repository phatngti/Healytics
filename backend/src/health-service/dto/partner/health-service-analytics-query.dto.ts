import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { DashboardTimePeriod } from '@/dashboard-partner/dto/query/dashboard-period-query.dto';

export class HealthServiceAnalyticsQueryDto {
  @ApiPropertyOptional({
    enum: DashboardTimePeriod,
    default: DashboardTimePeriod.THIS_MONTH,
    description: 'Time period for analytics aggregation',
  })
  @IsOptional()
  @IsEnum(DashboardTimePeriod)
  period?: DashboardTimePeriod = DashboardTimePeriod.THIS_MONTH;
}
