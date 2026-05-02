import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class EmployeeScheduleLoadDto {
  @ApiProperty({
    type: String,
    example: 'Mon',
    description: 'Weekday abbreviation',
  })
  @Expose()
  label: string;

  @ApiProperty({
    type: Number,
    example: 8,
    description: 'Total available hours from schedule for this weekday',
  })
  @Expose()
  availableHours: number;

  @ApiProperty({
    type: Number,
    example: 6.5,
    description: 'Total booked hours for this weekday',
  })
  @Expose()
  bookedHours: number;
}
