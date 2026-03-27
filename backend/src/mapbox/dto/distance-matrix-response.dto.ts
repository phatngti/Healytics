import { ApiProperty } from '@nestjs/swagger';

export class DistanceMatrixElementDto {
  @ApiProperty({ example: '12.3 km' })
  distanceText: string;

  @ApiProperty({ example: 12300 })
  distanceValue: number;

  @ApiProperty({ example: '25 mins' })
  durationText: string;

  @ApiProperty({ example: 1500 })
  durationValue: number;

  @ApiProperty({ example: 'OK' })
  status: string;
}

export class DistanceMatrixRowDto {
  @ApiProperty({ type: [DistanceMatrixElementDto] })
  elements: DistanceMatrixElementDto[];
}

export class DistanceMatrixResponseDto {
  @ApiProperty({ type: [String], example: ['Ho Chi Minh City, Vietnam'] })
  originAddresses: string[];

  @ApiProperty({ type: [String], example: ['District 7, Ho Chi Minh City, Vietnam'] })
  destinationAddresses: string[];

  @ApiProperty({ type: [DistanceMatrixRowDto] })
  rows: DistanceMatrixRowDto[];
}
