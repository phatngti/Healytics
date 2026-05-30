import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '../enum/employee-role.enum';
import { EmployeeStatus } from '../enum/employee-status.enum';
import { Gender } from '../enum/gender.enum';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';
import { WorkHistoryEntryDto } from './work-history-entry.dto';
import { VerificationDocumentEntryDto } from './verification-document-entry.dto';

/**
 * Doctor profile response DTO.
 * Matches DoctorProfile entity structure.
 */

export class MedicalCredentialResponseDto {
  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Title',
  })
  title?: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'License',
  })
  license?: string;
}

export class DoctorProfileResponseDto {
  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Employee ID (primary key)',
  })
  employeeId?: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Doctor title',
  })
  title?: string;

  @Expose()
  @ApiPropertyOptional({
    type: [MedicalCredentialResponseDto],
    description: 'Medical credentials (titles + licenses)',
  })
  @Type(() => MedicalCredentialResponseDto)
  medicalCredentials?: Array<MedicalCredentialResponseDto>;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Years of experience',
  })
  experienceYears?: number;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Consultation fee',
  })
  consultationFee?: number;

  @Expose()
  @ApiPropertyOptional({
    type: [String],
    description: 'List of specializations',
  })
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
export class TherapistProfileResponseDto {
  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Employee ID (primary key)',
  })
  employeeId?: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Therapist level (junior, senior, etc.)',
  })
  level?: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Therapist type',
  })
  type?: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Strength level',
  })
  strengthLevel?: string;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Commission rate (percentage)',
  })
  commissionRate?: number;

  @Expose()
  @ApiPropertyOptional({
    type: Date,
    nullable: true,
    description: 'Health check date',
  })
  healthCheckDate?: Date;

  @Expose()
  @ApiPropertyOptional({ type: [String], description: 'List of skills' })
  skills?: string[];

  @Expose()
  @ApiPropertyOptional({
    type: [String],
    description: 'Device proficiency list',
  })
  deviceProficiency?: string[];
}

/**
 * Employee response DTO for API responses.
 * Never expose raw entity data directly.
 */
export class EmployeeResponseDto {
  @Expose()
  @ApiProperty({ type: String, description: 'Unique employee identifier' })
  id: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Employee code' })
  employeeCode: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'First name',
  })
  firstName: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Last name',
  })
  lastName: string | null;

  @Expose()
  @ApiProperty({ type: String, description: 'Full name' })
  fullName: string;

  @Expose()
  @ApiProperty({ type: String, description: 'Email address' })
  email: string;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Phone number',
  })
  phone: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Avatar URL',
  })
  avatarUrl: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Job title',
  })
  jobTitle: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: Date,
    nullable: true,
    description: 'Start date',
  })
  startDate: Date | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Employment type',
  })
  employmentType: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Description/bio',
  })
  description: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Emergency contact name',
  })
  emergencyContactName: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Emergency contact phone',
  })
  emergencyContactPhone: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: [VerificationDocumentEntryDto],
    description: 'Verification documents',
  })
  @Type(() => VerificationDocumentEntryDto)
  verificationDocuments: VerificationDocumentEntryDto[];

  @Expose()
  @ApiPropertyOptional({
    type: [WorkScheduleEntryDto],
    description: 'Work schedule',
  })
  @Type(() => WorkScheduleEntryDto)
  schedule: WorkScheduleEntryDto[];

  @Expose()
  @ApiPropertyOptional({
    type: [WorkHistoryEntryDto],
    description: 'Work history',
  })
  @Type(() => WorkHistoryEntryDto)
  workHistory: WorkHistoryEntryDto[];

  @Expose()
  @ApiPropertyOptional({
    type: Date,
    nullable: true,
    description: 'Date of birth',
  })
  dob: Date | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    enum: Gender,
    enumName: 'Gender',
    nullable: true,
    description: 'Gender',
  })
  gender: Gender | null;

  @Expose()
  @ApiProperty({
    type: String,
    enum: EmployeeRole,
    enumName: 'EmployeeRole',
    description: 'Employee role',
  })
  role: EmployeeRole;

  @Expose()
  @ApiProperty({
    type: String,
    enum: EmployeeStatus,
    enumName: 'EmployeeStatus',
    description: 'Employee status',
  })
  status: EmployeeStatus;

  @Expose()
  @ApiProperty({ type: Number, description: 'Rating (0-5)' })
  rating: number;

  @Expose()
  @ApiProperty({ type: Number, description: 'Number of reviews' })
  reviewCount: number;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Partner ID the employee belongs to',
  })
  partnerId: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Public clinic ID the employee belongs to',
  })
  clinicId?: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Public clinic name the employee belongs to',
  })
  clinicName?: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Clinic location label',
  })
  location?: string | null;

  @Expose()
  @ApiPropertyOptional({
    type: Number,
    nullable: true,
    description: 'Normalized years of professional experience',
  })
  experienceYears?: number | null;

  @Expose()
  @ApiProperty({ type: Date, description: 'Creation timestamp' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ type: Date, description: 'Last update timestamp' })
  updatedAt: Date;

  @Expose()
  @Type(() => DoctorProfileResponseDto)
  @ApiPropertyOptional({
    type: () => DoctorProfileResponseDto,
    nullable: true,
    description: 'Doctor profile',
  })
  doctorProfile: DoctorProfileResponseDto | null;

  @Expose()
  @Type(() => TherapistProfileResponseDto)
  @ApiPropertyOptional({
    type: () => TherapistProfileResponseDto,
    nullable: true,
    description: 'Therapist profile',
  })
  therapistProfile: TherapistProfileResponseDto | null;
}
