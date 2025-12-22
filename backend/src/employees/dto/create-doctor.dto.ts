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
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';

export class DoctorProfileDto {
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

export class CreateDoctorDto {
  @ApiPropertyOptional({ example: 'auth0|123456', description: 'Authentication ID from external provider' })
  @IsString()
  @IsOptional()
  authId?: string;

  @ApiProperty({ example: 'DOC001', description: 'Unique employee code' })
  @IsString()
  @IsNotEmpty()
  employeeCode: string;

  @ApiProperty({ example: 'Dr. John Doe', description: 'Full name of the doctor' })
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @ApiPropertyOptional({ example: 'Dr. John', description: 'Display name' })
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

  @ApiPropertyOptional({ enum: EmployeeStatus, example: EmployeeStatus.ACTIVE, description: 'Status of the employee' })
  @IsEnum(EmployeeStatus)
  @IsOptional()
  status?: EmployeeStatus;

  @ApiPropertyOptional({ example: 'uuid-branch-id', description: 'Branch ID the employee belongs to' })
  @IsString()
  @IsOptional()
  branchId?: string;

  @ApiProperty({ type: DoctorProfileDto, description: 'Doctor profile information' })
  @IsNotEmpty()
  @ValidateNested()
  @Type(() => DoctorProfileDto)
  profile: DoctorProfileDto;
}
