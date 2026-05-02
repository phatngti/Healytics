import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

export class RefundCaseActionDto {
  @ApiPropertyOptional({ type: String, description: 'Audit note', example: 'Approved from partner transaction manager.' })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}
