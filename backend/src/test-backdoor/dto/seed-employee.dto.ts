import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';

export class SeedEmployeeDto {
  @ApiPropertyOptional({ type: String, description: 'Unique lookup key' })
  @IsOptional()
  @IsString()
  key?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Key of a previously seeded partner',
  })
  @IsOptional()
  @IsString()
  partnerKey?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Brand name to look up the partner',
  })
  @IsOptional()
  @IsString()
  partnerBrandName?: string;

  @ApiPropertyOptional({ type: String, example: 'emp@test.healytics.vn' })
  @IsOptional()
  @IsString()
  email?: string;

  @ApiPropertyOptional({ type: String, example: 'EMP-001' })
  @IsOptional()
  @IsString()
  employeeCode?: string;

  @ApiPropertyOptional({ type: String, example: 'Nguyen' })
  @IsOptional()
  @IsString()
  firstName?: string;

  @ApiPropertyOptional({ type: String, example: 'Van B' })
  @IsOptional()
  @IsString()
  lastName?: string;

  @ApiProperty({ type: String, example: 'Dr. Nguyen Van B' })
  @IsString()
  @IsNotEmpty()
  displayName: string;

  @ApiPropertyOptional({ type: String, example: '0912345678' })
  @IsOptional()
  @IsString()
  phone?: string;

  @ApiPropertyOptional({ enum: EmployeeRole })
  @IsOptional()
  @IsEnum(EmployeeRole)
  role?: EmployeeRole;

  @ApiPropertyOptional({ enum: EmployeeStatus })
  @IsOptional()
  @IsEnum(EmployeeStatus)
  status?: EmployeeStatus;
}
