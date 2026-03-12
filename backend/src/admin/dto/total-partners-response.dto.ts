import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class TotalPartnersResponseDto {
  @ApiProperty({ example: 150, description: 'Total number of partners' })
  @Expose()
  total: number;
}
