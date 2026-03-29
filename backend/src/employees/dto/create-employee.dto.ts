import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsDateString,
  IsNotEmpty,
  IsUUID,
  ValidateNested,
  IsNumber,
  IsArray,
} from 'class-validator';
import { VerificationDocumentEntryDto } from './verification-document-entry.dto';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';
import { WorkHistoryEntryDto } from './work-history-entry.dto';
import { MedicalCredentialResponseDto } from './employee-response.dto';

export class CreateDoctorProfileDto {
  @ApiPropertyOptional({ example: 'Dr.', description: 'Title of the doctor' })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiPropertyOptional({
    type: [MedicalCredentialResponseDto],
    description: 'Medical credentials (titles + licenses)',
    example: [{ title: 'MD', license: 'LIC-2024-001' }],
  })
  @IsArray()
  @IsOptional()
  @Type(() => MedicalCredentialResponseDto)
  medicalCredentials?: Array<MedicalCredentialResponseDto>;

  @ApiPropertyOptional({ example: 5, description: 'Years of experience' })
  @IsNumber()
  @IsOptional()
  experienceYears?: number;

  @ApiPropertyOptional({ example: 100.0, description: 'Consultation fee' })
  @IsNumber()
  @IsOptional()
  consultationFee?: number;

  @ApiPropertyOptional({ type: [String], example: ['Cardiology'], description: 'Specializations' })
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
}

export class CreateTherapistProfileDto {
  @ApiPropertyOptional({ enum: TherapistLevel, example: TherapistLevel.JUNIOR, description: 'Therapist level' })
  @IsEnum(TherapistLevel)
  @IsOptional()
  level?: TherapistLevel;

  @ApiPropertyOptional({ example: 'Physical Therapist', description: 'Type of therapist' })
  @IsString()
  @IsOptional()
  type?: string;

  @ApiPropertyOptional({ enum: StrengthLevel, example: StrengthLevel.STRONG, description: 'Therapist strength level' })
  @IsEnum(StrengthLevel)
  @IsOptional()
  strengthLevel?: StrengthLevel;

  @ApiPropertyOptional({ example: 10.5, description: 'Commission rate percentage' })
  @IsNumber()
  @IsOptional()
  commissionRate?: number;

  @ApiPropertyOptional({ example: '2023-01-01', description: 'Last health check date' })
  @IsDateString()
  @IsOptional()
  healthCheckDate?: string;

  @ApiPropertyOptional({ type: [String], example: ['Massage', 'Acupuncture'], description: 'Therapist skills' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];

  @ApiPropertyOptional({ type: [String], description: 'Device proficiency list' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  deviceProficiency?: string[];

}

export class CreateEmployeeDto {


  @ApiProperty({ example: 'EMP001', description: 'Unique employee code' })
  @IsString()
  @IsNotEmpty()
  employeeCode: string;

  @ApiPropertyOptional({ example: 'Nguyen', description: 'First name' })
  @IsString()
  @IsOptional()
  firstName?: string;

  @ApiPropertyOptional({ example: 'Van A', description: 'Last name' })
  @IsString()
  @IsOptional()
  lastName?: string;

  @ApiProperty({ example: 'John Doe', description: 'Full name of the employee' })
  @IsString()
  @IsNotEmpty()
  fullName: string;



  @ApiProperty({ example: 'john.doe@example.com', description: 'Email address' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiPropertyOptional({ example: '+1234567890', description: 'Phone number' })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg', description: 'Avatar URL' })
  @IsString()
  @IsOptional()
  avatarUrl?: string;

  @ApiPropertyOptional({ example: '1990-01-01', description: 'Date of birth' })
  @IsDateString()
  @IsOptional()
  dob?: string;

  @ApiPropertyOptional({ enum: Gender, example: Gender.MALE, description: 'Gender' })
  @IsEnum(Gender)
  @IsOptional()
  gender?: Gender;

  @ApiProperty({ enum: EmployeeRole, example: EmployeeRole.DOCTOR, description: 'Role of the employee' })
  @IsEnum(EmployeeRole)
  @IsNotEmpty()
  role: EmployeeRole;

  @ApiPropertyOptional({ enum: EmployeeStatus, example: EmployeeStatus.ACTIVE, description: 'Status of the employee' })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;



  @ApiPropertyOptional({ example: 'uuid-partner-id', description: 'Partner ID the employee belongs to' })
  @IsUUID()
  @IsOptional()
  partnerId?: string;

  @ApiPropertyOptional({ description: 'Job title' })
  @IsString()
  @IsOptional()
  jobTitle?: string;

  @ApiProperty({ description: 'Start date' })
  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @ApiPropertyOptional({ description: 'Employment type' })
  @IsString()
  @IsOptional()
  employmentType?: string;

  @ApiProperty({ description: 'Emergency contact name' })
  @IsString()
  @IsNotEmpty()
  emergencyContactName: string;

  @ApiProperty({ description: 'Emergency contact phone' })
  @IsString()
  @IsNotEmpty()
  emergencyContactPhone: string;

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

  @ApiProperty({ description: 'Bio / description' })
  @IsString()
  @IsNotEmpty()
  description: string;



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

  @ApiPropertyOptional({ type: CreateDoctorProfileDto, description: 'Doctor profile data if role is DOCTOR' })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreateDoctorProfileDto)
  doctorProfile?: CreateDoctorProfileDto;

  @ApiPropertyOptional({ type: CreateTherapistProfileDto, description: 'Therapist profile data if role is THERAPIST' })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreateTherapistProfileDto)
  therapistProfile?: CreateTherapistProfileDto;
}
