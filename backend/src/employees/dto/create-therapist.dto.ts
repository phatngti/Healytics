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
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';
import { WorkHistoryEntryDto } from './work-history-entry.dto';
import { VerificationDocumentEntryDto } from './verification-document-entry.dto';

// ═══════════════════════════════════════════════════════════════
// Shared base fields for all therapist types
// ═══════════════════════════════════════════════════════════════

/**
 * Flat DTO for creating a spa therapist employee.
 * Maps directly to Employee + TherapistProfile (type='SPA').
 */
export class CreateSpaTherapistDto {
  // ── Common employee fields ─────────────────────────────────
  @ApiProperty({ example: 'Le', description: 'First name' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Thi C', description: 'Last name' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({
    example: 'spa.therapist.c@healytics.com',
    description: 'Email address',
  })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiPropertyOptional({ example: '0923456789', description: 'Phone number' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: '1992-09-20', description: 'Date of birth' })
  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @ApiPropertyOptional({
    enum: Gender,
    example: Gender.FEMALE,
    description: 'Gender',
  })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiProperty({ example: 'Pham Van D', description: 'Emergency contact name' })
  @IsString()
  @IsNotEmpty()
  emergencyContactName: string;

  @ApiProperty({
    example: '0934567890',
    description: 'Emergency contact phone',
  })
  @IsString()
  @IsNotEmpty()
  emergencyContactPhone: string;

  @ApiProperty({
    example: 'SPA-001',
    description: 'Unique employee identifier code',
  })
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
      {
        facility: 'Glow Saigon Spa Retreat',
        position: 'Senior Spa Therapist',
        period: '2021–Present',
        isCurrent: true,
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkHistoryEntryDto)
  @IsOptional()
  workHistory?: WorkHistoryEntryDto[];

  @ApiPropertyOptional({
    example: 'https://i.pravatar.cc/150?u=spa@healytics.com',
    description: 'Avatar URL',
  })
  @IsString()
  @IsOptional()
  avatar?: string;

  @ApiPropertyOptional({
    type: [VerificationDocumentEntryDto],
    description: 'Verification documents (ID card, licenses, etc.)',
    example: [
      {
        fieldKey: 'id_card',
        documents: [
          {
            name: 'ID Card',
            url: 'https://storage.example.com/id-card.jpg',
            updatedTime: '2026-03-21T14:00:00.000Z',
          },
        ],
      },
      {
        fieldKey: 'other_documents',
        documents: [
          {
            name: 'Health Certificate',
            url: 'https://storage.example.com/health-cert.pdf',
            updatedTime: '2026-03-21T14:00:00.000Z',
          },
        ],
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VerificationDocumentEntryDto)
  @IsOptional()
  verificationDocuments?: VerificationDocumentEntryDto[];

  @ApiPropertyOptional({
    enum: EmployeeStatus,
    example: EmployeeStatus.ACTIVE,
    description: 'Employee status',
  })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;

  @ApiProperty({ description: 'Bio / description' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({
    example: 'Senior Spa Therapist',
    description: 'Job title',
  })
  @IsString()
  @IsOptional()
  jobTitle?: string;

  // ── Spa Therapist-specific fields ──────────────────────────

  @ApiPropertyOptional({
    enum: TherapistLevel,
    example: TherapistLevel.SENIOR,
    description: 'Therapist level',
  })
  @IsEnum(TherapistLevel)
  @IsOptional()
  therapistLevel?: TherapistLevel;

  @ApiPropertyOptional({
    example: 15.0,
    description: 'Commission rate percentage',
  })
  @IsNumber()
  @IsOptional()
  commissionRate?: number;

  @ApiPropertyOptional({
    example: '2026-01-15',
    description: 'Last health check date',
  })
  @IsDateString()
  @IsOptional()
  healthCheckDate?: string;

  @ApiPropertyOptional({
    type: [String],
    example: ['Facial Treatment', 'Body Scrub'],
    description: 'Skills',
  })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];

  @ApiPropertyOptional({
    type: [String],
    example: ['LED Light Therapy', 'Microdermabrasion'],
    description: 'Device proficiency',
  })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  deviceProficiency?: string[];

  // ── Internal (injected by controller) ──────────────────────

  @ApiPropertyOptional({ description: 'Partner ID (auto-injected)' })
  @IsString()
  @IsOptional()
  partnerId?: string;
}

/**
 * Flat DTO for creating a massage therapist employee.
 * Maps directly to Employee + TherapistProfile (type='MASSAGE').
 */
export class CreateMassageTherapistDto {
  // ── Common employee fields ─────────────────────────────────
  @ApiProperty({ example: 'Hoang', description: 'First name' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ example: 'Van E', description: 'Last name' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({
    example: 'massage.therapist.e@healytics.com',
    description: 'Email address',
  })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiPropertyOptional({ example: '0945678901', description: 'Phone number' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: '1990-03-10', description: 'Date of birth' })
  @IsDateString()
  @IsOptional()
  dateOfBirth?: string;

  @ApiPropertyOptional({
    enum: Gender,
    example: Gender.MALE,
    description: 'Gender',
  })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiProperty({
    example: 'Nguyen Thi F',
    description: 'Emergency contact name',
  })
  @IsString()
  @IsNotEmpty()
  emergencyContactName: string;

  @ApiProperty({
    example: '0956789012',
    description: 'Emergency contact phone',
  })
  @IsString()
  @IsNotEmpty()
  emergencyContactPhone: string;

  @ApiProperty({
    example: 'MSG-001',
    description: 'Unique employee identifier code',
  })
  @IsString()
  @IsNotEmpty()
  employeeId: string;

  @ApiPropertyOptional({ example: 'Part-Time', description: 'Employment type' })
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
      {
        facility: 'Healing Hands Massage Center',
        position: 'Lead Massage Therapist',
        period: '2020–Present',
        isCurrent: true,
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkHistoryEntryDto)
  @IsOptional()
  workHistory?: WorkHistoryEntryDto[];

  @ApiPropertyOptional({
    example: 'https://i.pravatar.cc/150?u=massage@healytics.com',
    description: 'Avatar URL',
  })
  @IsString()
  @IsOptional()
  avatar?: string;

  @ApiPropertyOptional({
    type: [VerificationDocumentEntryDto],
    description: 'Verification documents (ID card, licenses, etc.)',
    example: [
      {
        fieldKey: 'id_card',
        documents: [
          {
            name: 'ID Card',
            url: 'https://storage.example.com/id-card.jpg',
            updatedTime: '2026-03-21T14:00:00.000Z',
          },
        ],
      },
      {
        fieldKey: 'other_documents',
        documents: [
          {
            name: 'Health Certificate',
            url: 'https://storage.example.com/health-cert.pdf',
            updatedTime: '2026-03-21T14:00:00.000Z',
          },
        ],
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VerificationDocumentEntryDto)
  @IsOptional()
  verificationDocuments?: VerificationDocumentEntryDto[];

  @ApiPropertyOptional({
    enum: EmployeeStatus,
    example: EmployeeStatus.ACTIVE,
    description: 'Employee status',
  })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;

  @ApiProperty({ description: 'Bio / description' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({
    example: 'Master Massage Therapist',
    description: 'Job title',
  })
  @IsString()
  @IsOptional()
  jobTitle?: string;

  // ── Massage Therapist-specific fields ──────────────────────

  @ApiPropertyOptional({
    enum: TherapistLevel,
    example: TherapistLevel.MASTER,
    description: 'Therapist level',
  })
  @IsEnum(TherapistLevel)
  @IsOptional()
  therapistLevel?: TherapistLevel;

  @ApiPropertyOptional({
    enum: StrengthLevel,
    example: StrengthLevel.STRONG,
    description: 'Strength level',
  })
  @IsEnum(StrengthLevel)
  @IsOptional()
  strengthLevel?: StrengthLevel;

  @ApiPropertyOptional({
    example: 20.0,
    description: 'Commission rate percentage',
  })
  @IsNumber()
  @IsOptional()
  commissionRate?: number;

  @ApiPropertyOptional({
    example: '2026-02-01',
    description: 'Last health check date',
  })
  @IsDateString()
  @IsOptional()
  healthCheckDate?: string;

  @ApiPropertyOptional({
    type: [String],
    example: ['Deep Tissue', 'Swedish Massage'],
    description: 'Skills',
  })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];

  // ── Internal (injected by controller) ──────────────────────

  @ApiPropertyOptional({ description: 'Partner ID (auto-injected)' })
  @IsString()
  @IsOptional()
  partnerId?: string;
}
