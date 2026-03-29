import { Expose } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Employee } from '@/common/entities/employee.entity';

/**
 * Response DTO for featured specialists on the home page.
 */
export class FeaturedSpecialistResponseDto {
  @Expose()
  @ApiProperty({ description: 'UUID of the specialist', format: 'uuid' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Display name', example: 'Dr. Anna Nguyen' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'Short specialty label', example: 'Spa Therapist' })
  specialty: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Profile image URL (nullable)', nullable: true })
  avatarUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Average rating 0.0–5.0', example: 4.9 })
  rating: number;

  @Expose()
  @ApiProperty({ description: 'Total completed appointments', example: 124 })
  soldCount: number;

  @Expose()
  @ApiProperty({ description: 'Associated clinic name', example: 'Healytics Spa & Wellness' })
  clinicName: string;

  /**
   * Maps an Employee entity + aggregated sold count to the response DTO.
   */
  static fromEntity(
    employee: Employee,
    soldCount: number,
  ): FeaturedSpecialistResponseDto {
    const dto = new FeaturedSpecialistResponseDto();
    dto.id = employee.id;
    dto.name = employee.fullName;
    dto.specialty = employee.jobTitle ?? '';
    dto.avatarUrl = employee.avatarUrl ?? null;
    dto.rating = Number(employee.rating) || 0;
    dto.soldCount = soldCount;
    dto.clinicName = employee.partner?.brandName ?? '';
    return dto;
  }
}
