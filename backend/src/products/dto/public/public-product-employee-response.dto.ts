import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Employee } from '@/common/entities/employee.entity';

// ─── Nested DTOs ─────────────────────────────────────────────

class PublicEmployeeTimeSlotDto {
  @ApiProperty({ example: '7:00 AM' })
  label: string;

  @ApiProperty({ example: true })
  isAvailable: boolean;
}

class PublicProductEmployeeDayScheduleDto {
  @ApiProperty({ example: '2026-02-25T00:00:00.000Z' })
  date: string;

  @ApiProperty({ example: true })
  isAvailable: boolean;

  @ApiProperty({ type: [PublicEmployeeTimeSlotDto] })
  timeSlots: PublicEmployeeTimeSlotDto[];
}

// ─── Main DTO ────────────────────────────────────────────────

export class PublicProductEmployeeResponseDto {
  @ApiProperty() id: string;
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
  @ApiProperty({ type: [PublicProductEmployeeDayScheduleDto] }) daySchedules: PublicProductEmployeeDayScheduleDto[];

  static fromEntity(employee: Employee): PublicProductEmployeeResponseDto {
    const dto = new PublicProductEmployeeResponseDto();
    const doc = employee.doctorProfile;

    dto.id = employee.id;
    dto.name = employee.fullName;
    dto.role = employee.jobTitle ?? employee.role ?? '';
    dto.imageUrl = employee.avatarUrl ?? null;
    dto.isSelected = false;
    dto.quote = employee.description ?? null;
    dto.degrees = doc?.education?.join(', ') ?? null;
    dto.languages = 'Vietnamese, English'; // Placeholder until entity supports it
    dto.experience = doc?.experienceYears ? `${doc.experienceYears} years` : null;
    dto.specializations = doc?.specializations ?? [];
    dto.bio = employee.description ?? null;
    dto.daySchedules = generateMockSchedules();

    return dto;
  }

  static fromEntities(employees: Employee[]): PublicProductEmployeeResponseDto[] {
    return employees.map((emp) => PublicProductEmployeeResponseDto.fromEntity(emp));
  }
}

// ─── Helpers ─────────────────────────────────────────────────

function generateMockSchedules(): PublicProductEmployeeDayScheduleDto[] {
  const baseDate = new Date();
  // Start from next Monday
  const dayOfWeek = baseDate.getDay();
  const daysUntilMonday = dayOfWeek === 0 ? 1 : 8 - dayOfWeek;
  baseDate.setDate(baseDate.getDate() + daysUntilMonday);

  return Array.from({ length: 7 }, (_, i) => {
    const date = new Date(baseDate);
    date.setDate(date.getDate() + i);

    const morningSlots = ['7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'];
    const afternoonSlots = ['1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM'];
    const allSlots = [...morningSlots, ...afternoonSlots];

    const timeSlots = allSlots.map((label) => ({
      label,
      isAvailable: Math.random() > 0.3, // ~70% availability
    }));

    const isAvailable = timeSlots.some((s) => s.isAvailable);

    return {
      date: date.toISOString().split('T')[0] + 'T00:00:00.000Z',
      isAvailable,
      timeSlots,
    };
  });
}
