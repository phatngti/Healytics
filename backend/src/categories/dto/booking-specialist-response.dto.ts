import { Expose } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Employee } from '@/common/entities/employee.entity';

/**
 * Lightweight specialist response DTO for the booking flow.
 * Returns only the fields needed by the BookAppointmentScreen.
 */
export class BookingSpecialistResponseDto {
  @Expose()
  @ApiProperty({ description: 'Unique specialist/employee ID' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'product_employee_eligibility surrogate PK' })
  eligibilityId: string;

  @Expose()
  @ApiProperty({ description: 'Full display name', example: 'Dr. Anna Nguyen' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'Short specialty label', example: 'Spa Therapist' })
  specialty: string;

  @Expose()
  @ApiPropertyOptional({ description: 'URL to avatar image', nullable: true })
  avatarUrl: string | null;

  static fromEntity(entity: Employee, eligibilityId: string): BookingSpecialistResponseDto {
    const dto = new BookingSpecialistResponseDto();
    dto.id = entity.id;
    dto.eligibilityId = eligibilityId;
    dto.name = entity.fullName;
    dto.specialty = entity.jobTitle ?? entity.role ?? 'Specialist';
    dto.avatarUrl = entity.avatarUrl ?? null;
    return dto;
  }
}
