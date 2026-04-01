import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class GeocodeResultDto {
  @ApiProperty({ example: 10.762622 })
  lat: number;

  @ApiProperty({ example: 106.660172 })
  lng: number;

  @ApiProperty({
    example: '227 Nguyen Van Cu, District 5, Ho Chi Minh City, Vietnam',
  })
  formattedAddress: string;

  @ApiPropertyOptional({ example: 'address.1234567890' })
  placeId?: string;
}

export class GeocodeResponseDto {
  @ApiProperty({ type: [GeocodeResultDto] })
  results: GeocodeResultDto[];
}
