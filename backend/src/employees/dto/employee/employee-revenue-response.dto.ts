import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { EmployeeRevenuePeriod } from './employee-revenue-query.dto';

/**
 * Revenue summary response matching the frontend RevenueSummaryEntity.
 */
export class EmployeeRevenueSummaryResponseDto {
  @ApiProperty({ type: Number, description: 'Total revenue from completed appointments' })
  @Expose()
  totalRevenue: number;

  @ApiProperty({ type: Number, description: 'Total commission deducted' })
  @Expose()
  totalCommission: number;

  @ApiProperty({ type: Number, description: 'Net earnings after commission' })
  @Expose()
  netEarnings: number;

  @ApiProperty({ type: Number, description: 'Number of completed appointments' })
  @Expose()
  completedAppointments: number;

  @ApiProperty({ type: Number, description: 'Number of canceled appointments' })
  @Expose()
  canceledAppointments: number;

  @ApiProperty({
    enum: EmployeeRevenuePeriod,
    enumName: 'EmployeeRevenuePeriod',
    description: 'Period used for aggregation',
  })
  @Expose()
  period: EmployeeRevenuePeriod;

  @ApiProperty({ type: Date, description: 'Start of the aggregation period' })
  @Expose()
  periodStart: Date;

  @ApiProperty({ type: Date, description: 'End of the aggregation period' })
  @Expose()
  periodEnd: Date;
}

/**
 * Single data point in the revenue trend chart.
 * Matches the frontend RevenueDataPoint.
 */
export class EmployeeRevenueTrendPointDto {
  @ApiProperty({ type: Date })
  @Expose()
  date: Date;

  @ApiProperty({ type: Number })
  @Expose()
  amount: number;

  @ApiProperty({ type: String })
  @Expose()
  label: string;
}

/**
 * Revenue breakdown by service category.
 * Matches the frontend RevenueBreakdownItem.
 */
export class EmployeeRevenueBreakdownItemDto {
  @ApiProperty({ type: String })
  @Expose()
  serviceName: string;

  @ApiProperty({ type: Number })
  @Expose()
  count: number;

  @ApiProperty({ type: Number })
  @Expose()
  totalAmount: number;
}
