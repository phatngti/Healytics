import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsDateString,
  IsNotEmpty,
  IsNumber,
  IsArray,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';

/**
 * Flat DTO for creating a doctor employee.
 * Maps directly to Employee + DoctorProfile entities.
 */
export class CreateDoctorDto {
  // ── Common employee fields ─────────────────────────────────
  @ApiProperty({ example: 'Nguyen', description: 'First name' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Van A', description: 'Last name' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({ example: 'doctor.a@healytics.com', description: 'Email address' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiPropertyOptional({ example: '0901234567', description: 'Phone number' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: '1985-06-15', description: 'Date of birth' })
  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @ApiPropertyOptional({ enum: Gender, example: Gender.MALE, description: 'Gender' })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiPropertyOptional({ example: 'Tran Thi B', description: 'Emergency contact name' })
  @IsString()
  @IsOptional()
  emergencyContactName?: string;

  @ApiPropertyOptional({ example: '0912345678', description: 'Emergency contact phone' })
  @IsString()
  @IsOptional()
  emergencyContactPhone?: string;

  @ApiProperty({ example: 'DOC-001', description: 'Unique employee identifier code' })
  @IsString()
  @IsNotEmpty()
  employeeId: string;

  @ApiPropertyOptional({ example: 'Full-Time', description: 'Employment type' })
  @IsString()
  @IsOptional()
  employmentType?: string;

  @ApiPropertyOptional({ example: '2026-03-08', description: 'Start date' })
  @IsDateString()
  @IsOptional()
  startDate?: string;

  @ApiPropertyOptional({
    type: [WorkScheduleEntryDto],
    description: 'Weekly work schedule',
    example: [
      { day: 'Monday', start: '09:00', end: '17:00', isWorking: true },
      { day: 'Sunday', start: '', end: '', isWorking: false },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkScheduleEntryDto)
  @IsOptional()
  schedule?: WorkScheduleEntryDto[];

  @ApiPropertyOptional({ example: 'https://i.pravatar.cc/150?u=doctor.a@healytics.com', description: 'Avatar URL' })
  @IsString()
  @IsOptional()
  avatar?: string;

  @ApiPropertyOptional({ description: 'ID card URL' })
  @IsString()
  @IsOptional()
  idCardUrl?: string;

  @ApiPropertyOptional({ enum: EmployeeStatus, example: EmployeeStatus.ACTIVE, description: 'Employee status' })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;

  @ApiPropertyOptional({ example: '', description: 'Branch ID or name' })
  @IsString()
  @IsOptional()
  branch?: string;

  @ApiPropertyOptional({ example: 'password123', description: 'Account password' })
  @IsString()
  @IsOptional()
  password?: string;

  @ApiPropertyOptional({ description: 'Bio / description' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({ example: 'Dermatologist', description: 'Job title' })
  @IsString()
  @IsOptional()
  jobTitle?: string;

  // ── Doctor-specific fields ─────────────────────────────────

  @ApiPropertyOptional({ type: [String], example: ['MD', 'PhD'], description: 'Medical titles' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  medicalTitles?: string[];

  @ApiPropertyOptional({ type: [String], example: ['LIC-2024-001'], description: 'Medical license numbers' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  medicalLicenses?: string[];

  @ApiPropertyOptional({ example: 10, description: 'Years of experience' })
  @IsNumber()
  @IsOptional()
  experienceYears?: number;

  @ApiPropertyOptional({ example: 500000.0, description: 'Consultation fee' })
  @IsNumber()
  @IsOptional()
  consultationFee?: number;

  @ApiPropertyOptional({ type: [String], example: ['Dermatology'], description: 'Specializations' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  specializations?: string[];

  @ApiPropertyOptional({ type: [String], description: 'Education history' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  education?: string[];

  @ApiPropertyOptional({ type: [String], description: 'Certifications' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  certifications?: string[];

  // ── Internal (injected by controller) ──────────────────────

  @ApiPropertyOptional({ description: 'Partner ID (auto-injected)' })
  @IsString()
  @IsOptional()
  partnerId?: string;
}
