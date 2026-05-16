import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsOptional, IsString, ValidateNested } from 'class-validator';
import { SeedPayloadDto } from './seed-payload.dto';

export class BackdoorPrepareDto {
  @ApiPropertyOptional({
    type: String,
    example: 'login-flow',
    description: 'Scenario name',
  })
  @IsOptional()
  @IsString()
  scenario?: string;

  @ApiPropertyOptional({ type: SeedPayloadDto })
  @IsOptional()
  @ValidateNested()
  @Type(() => SeedPayloadDto)
  payload?: SeedPayloadDto;
}
