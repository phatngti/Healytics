import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '../enum/employee-role.enum';
import { EmployeeStatus } from '../enum/employee-status.enum';
import { Gender } from '../enum/gender.enum';

/**
 * Doctor profile response DTO.
 */
class DoctorProfileDto {
  @Expose()
  @ApiPropertyOptional()
  licenseNumber?: string;

  @Expose()
  @ApiPropertyOptional()
  specialization?: string;

  @Expose()
  @ApiPropertyOptional()
  yearsOfExperience?: number;
}

/**
 * Therapist profile response DTO.
 */
class TherapistProfileDto {
  @Expose()
  @ApiPropertyOptional()
  certifications?: string[];

  @Expose()
  @ApiPropertyOptional()
  specialties?: string[];
}

/**
 * Employee response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class EmployeeResponseDto {
  @Expose()
  @ApiProperty({ description: 'Unique employee identifier' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'Employee code' })
  employeeCode: string;

  @Expose()
  @ApiProperty({ description: 'Full name' })
  fullName: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Display name' })
  displayName: string | null;

  @Expose()
  @ApiProperty({ description: 'Email address' })
  email: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Phone number' })
  phone: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Avatar URL' })
  avatarUrl: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Job title' })
  jobTitle: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Start date' })
  startDate: Date | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Employment type' })
  employmentType: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Description/bio' })
  description: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Date of birth' })
  dob: Date | null;

  @Expose()
  @ApiPropertyOptional({ enum: Gender, description: 'Gender' })
  gender: Gender | null;

  @Expose()
  @ApiProperty({ enum: EmployeeRole, description: 'Employee role' })
  role: EmployeeRole;

  @Expose()
  @ApiProperty({ enum: EmployeeStatus, description: 'Employee status' })
  status: EmployeeStatus;

  @Expose()
  @ApiProperty({ description: 'Rating (0-5)' })
  rating: number;

  @Expose()
  @ApiProperty({ description: 'Number of reviews' })
  reviewCount: number;

  @Expose()
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => DoctorProfileDto)
  @ApiPropertyOptional({ type: DoctorProfileDto, description: 'Doctor profile' })
  doctorProfile: DoctorProfileDto | null;

  @Expose()
  @Type(() => TherapistProfileDto)
  @ApiPropertyOptional({ type: TherapistProfileDto, description: 'Therapist profile' })
  therapistProfile: TherapistProfileDto | null;
}
