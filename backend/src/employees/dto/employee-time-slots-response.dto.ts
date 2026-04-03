import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

// ─── Nested DTOs ─────────────────────────────────────────────

export class TimeSlotDto {
  @Expose()
  @ApiProperty({
    example: '09:00 AM',
    description: 'Human-readable label in 12h format',
  })
  label: string;

  @Expose()
  @ApiProperty({
    example: '09:00',
    description: 'Slot start time in HH:mm (24h) format',
  })
  time: string;

  @Expose()
  @ApiProperty({
    enum: ['free', 'busy'],
    example: 'free',
    description: 'Whether the slot is free or busy',
  })
  isBusy: boolean;
}

export class DayScheduleDto {
  @Expose()
  @ApiProperty({
    example: '2026-03-26',
    description: 'Date in YYYY-MM-DD format',
  })
  date: string;

  @Expose()
  @ApiProperty({ example: 'Wednesday', description: 'Day of the week' })
  dayOfWeek: string;

  @Expose()
  @ApiProperty({
    example: true,
    description: 'Whether the employee works on this day',
  })
  isWorkingDay: boolean;

  @Expose()
  @ApiProperty({
    type: [TimeSlotDto],
    description: 'Time slots for this day (empty if not working)',
  })
  slots: TimeSlotDto[];
}

// ─── Main DTO ────────────────────────────────────────────────

export class EmployeeTimeSlotsResponseDto {
  @Expose()
  @ApiProperty({ format: 'uuid', description: 'Employee ID' })
  employeeId: string;

  @Expose()
  @ApiProperty({
    example: 'Dr. Anna Nguyen',
    description: 'Employee full name',
  })
  employeeName: string;

  @Expose()
  @ApiProperty({ example: 30, description: 'Slot duration in minutes' })
  slotDurationMinutes: number;

  @Expose()
  @ApiProperty({
    type: [DayScheduleDto],
    description: 'Day-by-day schedule with time slots',
  })
  schedule: DayScheduleDto[];

  @Expose()
  @ApiProperty({
    example: '2026-03-26',
    description: 'Start of the schedule range',
  })
  rangeStart: string;

  @Expose()
  @ApiProperty({
    example: '2026-04-25',
    description: 'End of the schedule range',
  })
  rangeEnd: string;
}
