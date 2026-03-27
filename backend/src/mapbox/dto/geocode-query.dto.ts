import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class GeocodeQueryDto {
  @ApiProperty({
    description: 'Address to geocode',
    example: '227 Nguyen Van Cu, District 5, Ho Chi Minh City',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(500)
  address: string;
}
