import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsDateString,
  IsNotEmpty,
  IsUUID,
  ValidateNested,
  ValidateIf,
  IsArray,
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
 * All properties are optional. For DB-nullable fields the client may send
 * `null` to explicitly clear the value. For non-nullable DB columns
 * (employeeCode, fullName, email, role, status) the client may omit the
 * field or send a valid value — `null` will be stripped by the handler.
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

  @ApiPropertyOptional({ enum: EmployeeRole, enumName: 'EmployeeRole' })
  @IsOptional()
  @IsEnum(EmployeeRole)
  role?: EmployeeRole;

  @ApiPropertyOptional({ enum: EmployeeStatus, enumName: 'EmployeeStatus' })
  @IsOptional()
  @IsEnum(EmployeeStatus)
  status?: EmployeeStatus;

  // ── Nullable DB columns — accept null to clear ──────────────────────

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.firstName !== null)
  @IsString()
  firstName?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.lastName !== null)
  @IsString()
  lastName?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.phone !== null)
  @IsString()
  phone?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.avatarUrl !== null)
  @IsString()
  avatarUrl?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.dob !== null)
  @IsDateString()
  dob?: string | null;

  @ApiPropertyOptional({ enum: Gender, nullable: true })
  @ValidateIf((o) => o.gender !== null)
  @IsEnum(Gender)
  gender?: Gender | null;

  @ApiPropertyOptional({ type: String, format: 'uuid', nullable: true })
  @ValidateIf((o) => o.partnerId !== null)
  @IsUUID()
  partnerId?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.jobTitle !== null)
  @IsString()
  jobTitle?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.startDate !== null)
  @IsDateString()
  startDate?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.employmentType !== null)
  @IsString()
  employmentType?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.emergencyContactName !== null)
  @IsString()
  emergencyContactName?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.emergencyContactPhone !== null)
  @IsString()
  emergencyContactPhone?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @ValidateIf((o) => o.description !== null)
  @IsString()
  description?: string | null;

  // ── Nullable relation arrays — accept null or [] to clear ───────────

  @ApiPropertyOptional({ type: [VerificationDocumentEntryDto], nullable: true })
  @ValidateIf((o) => o.verificationDocuments !== null)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => VerificationDocumentEntryDto)
  verificationDocuments?: VerificationDocumentEntryDto[] | null;

  @ApiPropertyOptional({ type: [WorkScheduleEntryDto], nullable: true })
  @ValidateIf((o) => o.schedule !== null)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkScheduleEntryDto)
  schedule?: WorkScheduleEntryDto[] | null;

  @ApiPropertyOptional({ type: [WorkHistoryEntryDto], nullable: true })
  @ValidateIf((o) => o.workHistory !== null)
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => WorkHistoryEntryDto)
  workHistory?: WorkHistoryEntryDto[] | null;

  // ── Nested profiles — accept null to clear ──────────────────────────

  @ApiPropertyOptional({ type: CreateDoctorProfileDto, nullable: true })
  @ValidateIf((o) => o.doctorProfile !== null)
  @ValidateNested()
  @Type(() => CreateDoctorProfileDto)
  doctorProfile?: CreateDoctorProfileDto | null;

  @ApiPropertyOptional({ type: CreateTherapistProfileDto, nullable: true })
  @ValidateIf((o) => o.therapistProfile !== null)
  @ValidateNested()
  @Type(() => CreateTherapistProfileDto)
  therapistProfile?: CreateTherapistProfileDto | null;
}
