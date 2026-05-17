import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { PartnerSettlementStatus } from '@/partner-finance/enums/partner-settlement-status.enum';
import {
  AdminFinanceExportType,
  AdminFinanceNoteEntityType,
} from './admin-finance.enums';

export class AdminFinanceSettlementActionDto {
  @ApiProperty({
    enum: PartnerSettlementStatus,
    enumName: 'PartnerSettlementStatus',
  })
  @IsEnum(PartnerSettlementStatus)
  settlementStatus: PartnerSettlementStatus;

  @ApiProperty({ type: String, maxLength: 1000 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(1000)
  note: string;
}

export class AdminFinanceReviewFlagActionDto {
  @ApiProperty({ type: Boolean })
  @IsBoolean()
  flagged: boolean;

  @ApiPropertyOptional({ type: String, maxLength: 1000 })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}

export class AdminFinanceNoteActionDto {
  @ApiPropertyOptional({ type: String, maxLength: 1000 })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}

export class AdminFinanceRequiredNoteActionDto {
  @ApiProperty({ type: String, maxLength: 1000 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(1000)
  note: string;
}

export class AdminFinanceCreateNoteDto {
  @ApiProperty({
    enum: AdminFinanceNoteEntityType,
    enumName: 'AdminFinanceNoteEntityType',
  })
  @IsEnum(AdminFinanceNoteEntityType)
  entityType: AdminFinanceNoteEntityType;

  @ApiProperty({ type: String })
  @IsString()
  @IsNotEmpty()
  entityId: string;

  @ApiProperty({ type: String, maxLength: 2000 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(2000)
  content: string;
}

export class AdminFinanceCreateExportDto {
  @ApiProperty({
    enum: AdminFinanceExportType,
    enumName: 'AdminFinanceExportType',
  })
  @IsEnum(AdminFinanceExportType)
  type: AdminFinanceExportType;
}
