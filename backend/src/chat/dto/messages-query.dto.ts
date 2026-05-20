import { IsOptional, IsUUID, IsInt, Min, Max } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

/**
 * Cursor-based pagination query for chat message history.
 *
 * - `beforeId`: fetch messages older than this message ID (cursor)
 * - `limit`: max messages per page (default 20, max 50)
 */
export class MessagesQueryDto {
  @ApiPropertyOptional({
    description: 'Fetch messages older than this message ID (cursor)',
  })
  @IsOptional()
  @IsUUID()
  beforeId?: string;

  @ApiPropertyOptional({
    description: 'Number of messages to return (max 50)',
    default: 50,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 50;
}
