import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class DirectionsQueryDto {
  @ApiProperty({
    description: 'Origin coordinate in lat,lng format',
    example: '10.762622,106.660172',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(64)
  origin: string;

  @ApiProperty({
    description: 'Destination coordinate in lat,lng format',
    example: '10.823099,106.629662',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(64)
  destination: string;
}
