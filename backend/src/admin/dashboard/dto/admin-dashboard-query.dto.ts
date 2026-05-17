import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, Max, Min } from 'class-validator';

export enum AdminDashboardPeriod {
  SEVEN_DAYS = '7d',
  THIRTY_DAYS = '30d',
  NINETY_DAYS = '90d',
}

export class AdminDashboardPeriodQueryDto {
  @ApiPropertyOptional({
    enum: AdminDashboardPeriod,
    default: AdminDashboardPeriod.THIRTY_DAYS,
  })
  @IsOptional()
  @IsEnum(AdminDashboardPeriod)
  period?: AdminDashboardPeriod = AdminDashboardPeriod.THIRTY_DAYS;
}

export class AdminDashboardLimitQueryDto {
  @ApiPropertyOptional({ type: Number, default: 5, minimum: 1, maximum: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(20)
  limit?: number = 5;
}

export class AdminDashboardRankingQueryDto extends AdminDashboardPeriodQueryDto {
  @ApiPropertyOptional({ type: Number, default: 5, minimum: 1, maximum: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(20)
  limit?: number = 5;
}
