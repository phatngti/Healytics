import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';

export class MarkSettlementDto {
  @ApiProperty({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
    example: PartnerSettlementStatus.SETTLED,
    description: 'Target settlement status',
  })
  @IsEnum(PartnerSettlementStatus)
  settlementStatus: PartnerSettlementStatus;

  @ApiPropertyOptional({
    type: String,
    description: 'Audit note',
    example: 'Finance manager confirmed manual settlement.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}
