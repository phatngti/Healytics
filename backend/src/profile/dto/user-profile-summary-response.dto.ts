import { ApiProperty } from '@nestjs/swagger';

export class UserProfileSummaryResponseDto {
  @ApiProperty({ type: Number, example: 12 })
  ordersCount: number;

  @ApiProperty({ type: Number, example: 48 })
  wishlistCount: number;

  @ApiProperty({ type: Number, example: 0 })
  points: number;

  @ApiProperty({ type: String, example: '0' })
  pointsLabel: string;
}
