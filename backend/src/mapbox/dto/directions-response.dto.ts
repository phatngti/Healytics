import { ApiProperty } from '@nestjs/swagger';

export class DirectionsCoordinateDto {
  @ApiProperty({ example: 10.762622 })
  latitude: number;

  @ApiProperty({ example: 106.660172 })
  longitude: number;
}

export class DirectionsResponseDto {
  @ApiProperty({ type: [DirectionsCoordinateDto] })
  route: DirectionsCoordinateDto[];

  @ApiProperty({ example: '12.3 km' })
  distanceText: string;

  @ApiProperty({ example: 12300 })
  distanceValue: number;

  @ApiProperty({ example: '25 mins' })
  durationText: string;

  @ApiProperty({ example: 1500 })
  durationValue: number;
}
