import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsDateString,
  IsNotEmpty,
  IsUUID,
  ValidateNested,
  IsArray,
  MinLength,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { VerificationDocumentEntryDto } from './verification-document-entry.dto';
import { WorkScheduleEntryDto } from './work-schedule-entry.dto';
import { WorkHistoryEntryDto } from './work-history-entry.dto';
import {
  CreateDoctorProfileDto,
  CreateTherapistProfileDto,
} from './create-employee.dto';

/**
 * Update DTO for employees.
 *
 * All properties are optional. The controller applies `StripNullPropertiesPipe`
 * to remove any field whose value is `null` before validation runs, so only
 * fields with real values are validated and passed to the handler.
 *
 * To clear a nullable DB column, the frontend should simply omit the field
 * (or send `null`, which the pipe strips).
 */
export class UpdateEmployeeDto {
  // ── Non-nullable DB columns — optional but never null ───────────────

  @ApiPropertyOptional({ type: String, example: 'EMP001' })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  employeeCode?: string;

  @ApiPropertyOptional({ type: String, example: 'John Doe' })
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  fullName?: string;

  @ApiPropertyOptional({ type: String, example: 'john@example.com' })
  @IsOptional()
  @IsEmail()
  @IsNotEmpty()
  email?: string;

  @ApiPropertyOptional({
    type: String,
    minLength: 8,
    description: 'New employee account password',
  })
  @IsOptional()
  @IsString()
  @MinLength(8)
  password?: string;

  @ApiPropertyOptional({ enum: EmployeeRole, enumName: 'EmployeeRole' })
  @IsOptional()
  @IsEnum(EmployeeRole)
  role?: EmployeeRole;

  @ApiPropertyOptional({ enum: EmployeeStatus, enumName: 'EmployeeStatus' })
  @IsOptional()
  @IsEnum(EmployeeStatus)
  status?: EmployeeStatus;

  // ── Nullable DB columns ─────────────────────────────────────────────

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  avatarUrl?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsDateString()
  dob?: string;

  @ApiPropertyOptional({ enum: Gender, nullable: true })
  @IsOptional()
  @IsEnum(Gender)
  gender?: Gender;

  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @IsOptional()
  @IsUUID()
  partnerId?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  jobTitle?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  employmentType?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  emergencyContactName?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  emergencyContactPhone?: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsString()
  description?: string;

  // ── Nullable relation arrays ────────────────────────────────────────

  @ApiPropertyOptional({ type: [VerificationDocumentEntryDto], nullable: true })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VerificationDocumentEntryDto)
  verificationDocuments?: VerificationDocumentEntryDto[];

  @ApiPropertyOptional({ type: [WorkScheduleEntryDto], nullable: true })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkScheduleEntryDto)
  schedule?: WorkScheduleEntryDto[];

  @ApiPropertyOptional({ type: [WorkHistoryEntryDto], nullable: true })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkHistoryEntryDto)
  workHistory?: WorkHistoryEntryDto[];

  // ── Nested profiles ─────────────────────────────────────────────────

  @ApiPropertyOptional({ type: CreateDoctorProfileDto, nullable: true })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreateDoctorProfileDto)
  doctorProfile?: CreateDoctorProfileDto;

  @ApiPropertyOptional({ type: CreateTherapistProfileDto, nullable: true })
  @IsOptional()
  @ValidateNested()
  @Type(() => CreateTherapistProfileDto)
  therapistProfile?: CreateTherapistProfileDto;
}
