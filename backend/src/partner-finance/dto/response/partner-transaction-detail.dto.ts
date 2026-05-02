import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { PartnerTransactionRecordDto } from './partner-transaction-record.dto';
import { PartnerPayoutRecordDto } from './partner-payout-record.dto';
import { PartnerRefundCaseRecordDto } from './partner-refund-case-record.dto';

/**
 * Composite response for the transaction detail screen.
 * Returns everything the frontend needs in one call.
 */
export class PartnerTransactionDetailDto {
  @ApiProperty({ type: () => PartnerTransactionRecordDto })
  @Type(() => PartnerTransactionRecordDto)
  @Expose()
  record: PartnerTransactionRecordDto;

  @ApiPropertyOptional({ type: () => PartnerPayoutRecordDto, nullable: true })
  @Type(() => PartnerPayoutRecordDto)
  @Expose()
  payoutRecord!: PartnerPayoutRecordDto | null;

  @ApiProperty({ type: [PartnerRefundCaseRecordDto] })
  @Type(() => PartnerRefundCaseRecordDto)
  @Expose()
  relatedRefundCases: PartnerRefundCaseRecordDto[];

  @ApiProperty({ type: String, example: 'Dermatology consultation package' })
  @Expose()
  sourceSummaryTitle: string;

  @ApiProperty({ type: String, example: 'Confirmed service booking' })
  @Expose()
  sourceSummarySubtitle: string;
}
