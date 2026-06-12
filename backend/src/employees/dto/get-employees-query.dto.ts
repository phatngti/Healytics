import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsOptional, IsUUID, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { EmployeeRole } from '../enum/employee-role.enum';

export enum EmployeeListSort {
  DEFAULT = 'default',
  RATING_DESC = 'rating_desc',
  EXPERIENCE_DESC = 'experience_desc',
  REVIEWS_DESC = 'reviews_desc',
}

export class GetEmployeesQueryDto {
  @ApiPropertyOptional({ enum: EmployeeRole })
  @IsOptional()
  @IsEnum(EmployeeRole)
  role?: EmployeeRole;

  @ApiPropertyOptional({ enum: EmployeeListSort, default: 'default' })
  @IsOptional()
  @IsEnum(EmployeeListSort)
  sort?: EmployeeListSort = EmployeeListSort.DEFAULT;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  clinicId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  provinceId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  districtId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ type: Number, minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  minExperienceYears?: number;
}
