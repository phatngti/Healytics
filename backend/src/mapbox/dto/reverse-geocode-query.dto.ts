import { ApiProperty } from '@nestjs/swagger';
import { IsLatitude, IsLongitude } from 'class-validator';
import { Type } from 'class-transformer';

export class ReverseGeocodeQueryDto {
  @ApiProperty({ description: 'Latitude', example: 10.762622 })
  @Type(() => Number)
  @IsLatitude()
  lat: number;

  @ApiProperty({ description: 'Longitude', example: 106.660172 })
  @Type(() => Number)
  @IsLongitude()
  lng: number;
}
