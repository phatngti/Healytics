import {
  IsUUID,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/**
 * DTO for creating a new P2P conversation.
 */
export class CreateConversationDto {
  @ApiProperty({ description: 'Account ID of the health partner' })
  @IsUUID()
  @IsNotEmpty()
  healthPartnerId: string;

  @ApiPropertyOptional({
    description: 'Optional booking context for the conversation',
  })
  @IsOptional()
  @IsUUID()
  bookingId?: string;

  @ApiPropertyOptional({
    description: 'Optional first message to start the conversation',
  })
  @IsOptional()
  @IsString()
  @MaxLength(5000)
  initialMessage?: string;
}
