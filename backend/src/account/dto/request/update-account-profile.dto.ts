import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Matches } from 'class-validator';

export class UpdateAccountProfileDto {
  @ApiPropertyOptional({ example: 'Jane', nullable: true })
  @IsOptional()
  @IsString()
  firstName?: string | null;

  @ApiPropertyOptional({ example: 'Doe', nullable: true })
  @IsOptional()
  @IsString()
  lastName?: string | null;

  @ApiPropertyOptional({ example: '0901234567', nullable: true })
  @IsOptional()
  @Matches(/^(?:\+84|84|0)(?:3|5|7|8|9)[0-9]{8}$/, {
    message:
      'Phone number must be a valid Vietnamese phone number (e.g., +84901234567, 84901234567, or 0901234567)',
  })
  @IsString()
  phone?: string | null;
}
