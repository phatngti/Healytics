import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

/**
 * Request DTO for canceling an employee appointment.
 * Reason is required for audit trail.
 */
export class CancelEmployeeAppointmentDto {
  @ApiPropertyOptional({
    type: String,
    example: 'Patient requested cancellation',
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  reason?: string;
}
