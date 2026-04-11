import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class StaffScheduleEntryDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @Expose()
  employeeId: string;

  @ApiProperty({ example: 'Dr. Trần Minh' })
  @Expose()
  employeeName: string;

  @ApiProperty({ example: 'Doctor' })
  @Expose()
  role: string;

  @ApiProperty({ example: '2026-04-09T08:00:00.000Z' })
  @Expose()
  startTime: string;

  @ApiProperty({ example: '2026-04-09T09:00:00.000Z' })
  @Expose()
  endTime: string;

  @ApiProperty({ example: 'General Consultation' })
  @Expose()
  serviceName: string;

  @ApiPropertyOptional({ example: 'Nguyễn Văn An' })
  @Expose()
  patientName?: string;
}
