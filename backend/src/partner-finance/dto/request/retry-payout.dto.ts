import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength } from 'class-validator';

export class RetryPayoutDto {
  @ApiPropertyOptional({ type: String, description: 'Audit note', example: 'Retry requested from partner transaction manager.' })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  note?: string;
}
