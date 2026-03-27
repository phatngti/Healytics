import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class LogoutResponseDto {
  @ApiProperty({ example: 'Logged out successfully' })
  @Expose()
  message: string;
}
