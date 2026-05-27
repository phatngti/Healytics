import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class PartnerTransactionTimelineEventDto {
  @ApiProperty({ type: String, example: 'Payment captured' })
  @Expose()
  title: string;

  @ApiProperty({
    type: String,
    example: 'Customer successfully paid through MoMo.',
  })
  @Expose()
  description: string;

  @ApiProperty({ type: String, example: '2026-04-08T02:16:00.000Z' })
  @Expose()
  occurredAt: string;
}
