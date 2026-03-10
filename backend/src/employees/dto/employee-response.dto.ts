import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '../enum/employee-role.enum';
import { EmployeeStatus } from '../enum/employee-status.enum';
import { Gender } from '../enum/gender.enum';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';

/**
 * Doctor profile response DTO.
 * Matches DoctorProfile entity structure.
 */
class DoctorProfileResponseDto {
  @Expose()
  @ApiPropertyOptional({ description: 'Employee ID (primary key)' })
  employeeId?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Doctor title' })
  title?: string;

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'Medical titles' })
  medicalTitles?: string[];

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'Medical license numbers' })
  medicalLicenses?: string[];

  @Expose()
  @ApiPropertyOptional({ description: 'Years of experience' })
  experienceYears?: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Consultation fee' })
  consultationFee?: number;

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'List of specializations' })
  specializations?: string[];

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'Education history' })
  education?: string[];

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'Certifications' })
  certifications?: string[];
}

/**
 * Therapist profile response DTO.
 * Matches TherapistProfile entity structure.
 */
class TherapistProfileResponseDto {
  @Expose()
  @ApiPropertyOptional({ description: 'Employee ID (primary key)' })
  employeeId?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Therapist level (junior, senior, etc.)' })
  level?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Therapist type' })
  type?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Strength level' })
  strengthLevel?: string;

  @Expose()
  @ApiPropertyOptional({ description: 'Commission rate (percentage)' })
  commissionRate?: number;

  @Expose()
  @ApiPropertyOptional({ description: 'Health check date' })
  healthCheckDate?: Date;

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'List of skills' })
  skills?: string[];

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'Device proficiency list' })
  deviceProficiency?: string[];

  @Expose()
  @ApiPropertyOptional({ description: 'License URL' })
  licenseUrl?: string;
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
  @ApiPropertyOptional({ description: 'First name' })
  firstName: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Last name' })
  lastName: string | null;

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
  @ApiPropertyOptional({ description: 'Emergency contact name' })
  emergencyContactName: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'Emergency contact phone' })
  emergencyContactPhone: string | null;

  @Expose()
  @ApiPropertyOptional({ description: 'ID card URL' })
  idCardUrl: string | null;

  @Expose()
  @ApiPropertyOptional({ type: [WorkScheduleEntryDto], description: 'Work schedule' })
  @Type(() => WorkScheduleEntryDto)
  schedule: WorkScheduleEntryDto[] | null;

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
  @ApiPropertyOptional({ description: 'Partner ID the employee belongs to' })
  partnerId: string | null;

  @Expose()
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => DoctorProfileResponseDto)
  @ApiPropertyOptional({ type: DoctorProfileResponseDto, description: 'Doctor profile' })
  doctorProfile: DoctorProfileResponseDto | null;

  @Expose()
  @Type(() => TherapistProfileResponseDto)
  @ApiPropertyOptional({ type: TherapistProfileResponseDto, description: 'Therapist profile' })
  therapistProfile: TherapistProfileResponseDto | null;
}
