import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class DistanceMatrixQueryDto {
  @ApiProperty({
    description:
      'Origins — pipe-separated coordinates or addresses (e.g. "10.762,106.660|10.823,106.629")',
    example: '10.762622,106.660172',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(2000)
  origins: string;

  @ApiProperty({
    description:
      'Destinations — pipe-separated coordinates or addresses (e.g. "10.823,106.629|10.800,106.700")',
    example: '10.823099,106.629662',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(2000)
  destinations: string;
}
