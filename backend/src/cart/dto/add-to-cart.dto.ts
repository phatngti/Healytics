import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsUUID } from 'class-validator';

export class AddToCartDto {
  @ApiProperty({
    description: 'UUID of the health service',
    example: '0f3a4726-2f17-4d39-9518-b5303b4a0a95',
  })
  @IsUUID()
  serviceId: string;

  @ApiProperty({
    description: 'UUID of the assigned employee (doctor or therapist)',
    example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @IsUUID()
  employeeId: string;

  @ApiProperty({
    description: 'Desired time slot in ISO 8601 datetime format',
    example: '2026-04-10T09:00:00.000Z',
  })
  @IsDateString()
  timeSlot: string;
}
