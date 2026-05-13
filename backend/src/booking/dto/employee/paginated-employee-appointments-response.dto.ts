import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { EmployeeAppointmentResponseDto } from './employee-appointment-response.dto';
import { PaginationMetaResponseDto } from './pagination-meta-response.dto';

/**
 * Paginated response for employee appointments list endpoint.
 * Wraps data array + pagination metadata.
 */
export class PaginatedEmployeeAppointmentsResponseDto {
  @ApiProperty({ type: [EmployeeAppointmentResponseDto], description: 'List of appointments' })
  @Type(() => EmployeeAppointmentResponseDto)
  @Expose()
  data: EmployeeAppointmentResponseDto[];

  @ApiProperty({ type: () => PaginationMetaResponseDto, description: 'Pagination metadata' })
  @Type(() => PaginationMetaResponseDto)
  @Expose()
  meta: PaginationMetaResponseDto;
}
