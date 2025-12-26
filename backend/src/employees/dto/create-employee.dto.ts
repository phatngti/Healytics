import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsDateString,
  IsNotEmpty,
  ValidateNested,
  IsNumber,
  IsArray,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';

export class CreateDoctorProfileDto {
  @ApiPropertyOptional({ example: 'Dr.', description: 'Title of the doctor' })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiProperty({ example: 'MED123456', description: 'Medical license number' })
  @IsString()
  @IsNotEmpty()
  medicalLicense: string;

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
}

export class CreateEmployeeDto {
  @ApiPropertyOptional({ example: 'auth0|123456', description: 'Authentication ID from external provider' })
  @IsString()
  @IsOptional()
  authId?: string;

  @ApiProperty({ example: 'EMP001', description: 'Unique employee code' })
  @IsString()
  @IsNotEmpty()
  employeeCode: string;

  @ApiProperty({ example: 'John Doe', description: 'Full name of the employee' })
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @ApiPropertyOptional({ example: 'Johnny', description: 'Display name' })
  @IsString()
  @IsOptional()
  displayName?: string;

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

  @ApiPropertyOptional({ example: 'uuid-branch-id', description: 'Branch ID the employee belongs to' })
  @IsString()
  @IsOptional()
  branchId?: string;

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
