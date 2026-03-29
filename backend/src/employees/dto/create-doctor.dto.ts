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
import { WorkHistoryEntryDto } from './work-history-entry.dto';
import { VerificationDocumentEntryDto } from './verification-document-entry.dto';
import { MedicalCredentialResponseDto } from './employee-response.dto';

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

  @ApiProperty({ example: 'Tran Thi B', description: 'Emergency contact name' })
  @IsString()
  @IsNotEmpty()
  emergencyContactName: string;

  @ApiProperty({ example: '0912345678', description: 'Emergency contact phone' })
  @IsString()
  @IsNotEmpty()
  emergencyContactPhone: string;

  @ApiProperty({ example: 'DOC-001', description: 'Unique employee identifier code' })
  @IsString()
  @IsNotEmpty()
  employeeId: string;

  @ApiPropertyOptional({ example: 'Full-Time', description: 'Employment type' })
  @IsString()
  @IsOptional()
  employmentType?: string;

  @ApiProperty({ example: '2026-03-08', description: 'Start date' })
  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @ApiProperty({
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
  @IsNotEmpty()
  schedule: WorkScheduleEntryDto[];

  @ApiPropertyOptional({
    type: [WorkHistoryEntryDto],
    description: 'Work history entries',
    example: [
      { facility: 'Glow Saigon Spa Retreat', position: 'Head of Dermatology', period: '2022–Present', isCurrent: true },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkHistoryEntryDto)
  @IsOptional()
  workHistory?: WorkHistoryEntryDto[];

  @ApiPropertyOptional({ example: 'https://i.pravatar.cc/150?u=doctor.a@healytics.com', description: 'Avatar URL' })
  @IsString()
  @IsOptional()
  avatar?: string;

  @ApiPropertyOptional({
    type: [VerificationDocumentEntryDto],
    description: 'Verification documents (ID card, licenses, etc.)',
    example: [
      { fieldKey: 'id_card', documents: [{ name: 'ID Card', url: 'https://storage.example.com/id-card.jpg', updatedTime: '2026-03-21T14:00:00.000Z' }] },
      { fieldKey: 'other_documents', documents: [
        { name: 'Health Certificate', url: 'https://storage.example.com/health-cert.pdf', updatedTime: '2026-03-21T14:00:00.000Z' },
      ]},
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VerificationDocumentEntryDto)
  @IsOptional()
  verificationDocuments?: VerificationDocumentEntryDto[];

  @ApiPropertyOptional({ enum: EmployeeStatus, example: EmployeeStatus.ACTIVE, description: 'Employee status' })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;

  @ApiProperty({ description: 'Bio / description' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({ example: 'Dermatologist', description: 'Job title' })
  @IsString()
  @IsOptional()
  jobTitle?: string;

  // ── Doctor-specific fields ─────────────────────────────────

  @ApiPropertyOptional({
    description: 'Medical credentials (titles + licenses)',
    example: [{ title: 'MD', license: 'LIC-2024-001' }],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => MedicalCredentialResponseDto)
  @IsOptional()
  medicalCredentials?: Array<MedicalCredentialResponseDto>;

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
