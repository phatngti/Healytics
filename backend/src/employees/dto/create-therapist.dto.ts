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
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { TherapistLevel } from '@/employees/enum/therapist-level.enum';
import { StrengthLevel } from '@/employees/enum/strength-level.enum';

export class TherapistProfileDto {
  @ApiPropertyOptional({ enum: TherapistLevel, example: TherapistLevel.JUNIOR, description: 'Therapist level' })
  @IsEnum(TherapistLevel)
  @IsOptional()
  level?: TherapistLevel;

  @ApiPropertyOptional({ example: 'SPA', description: 'Type of therapist (SPA, MASSAGE)' })
  @IsString()
  @IsOptional()
  type?: string;

  @ApiPropertyOptional({ enum: StrengthLevel, example: StrengthLevel.MEDIUM, description: 'Therapist strength level for massage' })
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

  @ApiPropertyOptional({ type: [String], example: ['Thai Massage', 'Shiatsu'], description: 'Therapist skills' })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  skills?: string[];
}

export class CreateTherapistDto {
  @ApiPropertyOptional({ example: 'auth0|123456', description: 'Authentication ID from external provider' })
  @IsString()
  @IsOptional()
  authId?: string;

  @ApiProperty({ example: 'THP001', description: 'Unique employee code' })
  @IsString()
  @IsNotEmpty()
  employeeCode: string;

  @ApiProperty({ example: 'Jane Smith', description: 'Full name of the therapist' })
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @ApiPropertyOptional({ example: 'Jane', description: 'Display name' })
  @IsString()
  @IsOptional()
  displayName?: string;

  @ApiProperty({ example: 'jane.smith@example.com', description: 'Email address' })
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

  @ApiPropertyOptional({ example: '1995-05-15', description: 'Date of birth' })
  @IsDateString()
  @IsOptional()
  dob?: string;

  @ApiPropertyOptional({ enum: Gender, example: Gender.FEMALE, description: 'Gender' })
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

  @ApiPropertyOptional({ example: 'uuid-partner-id', description: 'Partner ID the employee belongs to' })
  @IsUUID()
  @IsOptional()
  partnerId?: string;

  @ApiProperty({ type: TherapistProfileDto, description: 'Therapist profile information' })
  @IsNotEmpty()
  @ValidateNested()
  @Type(() => TherapistProfileDto)
  profile: TherapistProfileDto;
}
