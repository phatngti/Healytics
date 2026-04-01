import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Employee } from '@/common/entities/employee.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

export class PublicEmployeeTimeSlotDto {
  @ApiProperty({ example: '09:00 AM' })
  label: string;

  @ApiProperty({ example: true })
  isAvailable: boolean;
}

export class PublicHealthServiceEmployeeDayScheduleDto {
  @ApiProperty({ example: '2026-03-25' })
  date: string;

  @ApiProperty({ example: true })
  isAvailable: boolean;

  @ApiProperty({ type: [PublicEmployeeTimeSlotDto] })
  timeSlots: PublicEmployeeTimeSlotDto[];
}

// ─── Main DTO ────────────────────────────────────────────────

export class PublicHealthServiceEmployeeResponseDto {
  @ApiProperty({ description: 'Employee (specialist) ID' }) id: string;
  @ApiProperty({
    description:
      'product_employee_eligibility surrogate PK for this employee–service pair',
  })
  eligibilityId: string;
  @ApiProperty() name: string;
  @ApiProperty() role: string;
  @ApiPropertyOptional() imageUrl: string | null;
  @ApiProperty({ example: false }) isSelected: boolean;
  @ApiPropertyOptional() quote: string | null;
  @ApiPropertyOptional() degrees: string | null;
  @ApiPropertyOptional() languages: string | null;
  @ApiPropertyOptional({ example: '12 years' }) experience: string | null;
  @ApiPropertyOptional({ type: [String] }) specializations: string[];
  @ApiPropertyOptional() bio: string | null;
  @ApiProperty({ type: [PublicHealthServiceEmployeeDayScheduleDto] })
  daySchedules: PublicHealthServiceEmployeeDayScheduleDto[];

  static fromEntity(
    employee: Employee,
    options: {
      eligibilityId: string;
      isSelected: boolean;
      daySchedules: PublicHealthServiceEmployeeDayScheduleDto[];
    },
  ): PublicHealthServiceEmployeeResponseDto {
    const dto = new PublicHealthServiceEmployeeResponseDto();
    const doc = employee.doctorProfile;

    dto.id = employee.id;
    dto.eligibilityId = options.eligibilityId;
    dto.name = employee.fullName;
    dto.role = employee.jobTitle ?? employee.role ?? '';
    dto.imageUrl = employee.avatarUrl ?? null;
    dto.isSelected = options.isSelected;
    dto.quote = employee.description ?? null;
    dto.degrees = doc?.education?.join(', ') ?? null;
    dto.languages = 'Vietnamese, English'; // Placeholder until entity supports it
    dto.experience = doc?.experienceYears
      ? `${doc.experienceYears} years`
      : null;
    dto.specializations = doc?.specializations ?? [];
    dto.bio = employee.description ?? null;
    dto.daySchedules = options.daySchedules;

    return dto;
  }
}
