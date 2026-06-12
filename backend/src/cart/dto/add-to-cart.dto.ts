import { ApiProperty } from '@nestjs/swagger';
import {
  IsBoolean,
  IsDateString,
  IsOptional,
  IsUUID,
  ValidateIf,
} from 'class-validator';

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
    required: false,
  })
  @ValidateIf((dto: AddToCartDto) => !dto.autoAssignStaff)
  @IsUUID()
  employeeId?: string;

  @ApiProperty({
    description: 'Desired time slot in ISO 8601 datetime format',
    example: '2026-04-10T09:00:00.000Z',
  })
  @IsDateString()
  timeSlot: string;

  @ApiProperty({
    type: Boolean,
    description:
      'If true, backend selects the best eligible available specialist for this service and time slot.',
    required: false,
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  autoAssignStaff?: boolean;
}
