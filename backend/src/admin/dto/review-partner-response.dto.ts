import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class ReviewPartnerResponseDto {
  @ApiProperty({
    example: 'Review submitted successfully',
    description: 'Success message',
  })
  @Expose()
  message: string;
}
