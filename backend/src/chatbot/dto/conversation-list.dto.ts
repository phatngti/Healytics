import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { IsInt, IsOptional, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

// ─── Query ──────────────────────────────────────────────────────────────────────

export class ConversationListQueryDto {
  @ApiPropertyOptional({
    description: 'Page number (1-indexed)',
    default: 1,
    example: 1,
    minimum: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page: number = 1;

  @ApiPropertyOptional({
    description: 'Number of items per page',
    default: 10,
    example: 10,
    minimum: 1,
    maximum: 100,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit: number = 10;
}

// ─── Item ────────────────────────────────────────────────────────────────────────

export class ConversationListItemDto {
  @ApiProperty({ description: 'Conversation identifier', example: 'conv_001' })
  @Expose()
  id: string;

  @ApiProperty({ description: 'Auto-generated conversation title', example: 'Headache treatment options' })
  @Expose()
  title: string;

  @ApiProperty({ description: 'Last message text in the conversation', example: 'Try resting and staying hydrated.' })
  @Expose()
  lastMessage: string;

  @ApiProperty({ description: 'ISO 8601 timestamp of the last message', example: '2026-03-01T14:30:00.000Z' })
  @Expose()
  timestamp: string;
}

// ─── Response ────────────────────────────────────────────────────────────────────

export class ConversationListMetaDto {
  @ApiProperty({ description: 'Current page number', example: 1 })
  @Expose()
  page: number;

  @ApiProperty({ description: 'Items per page', example: 10 })
  @Expose()
  limit: number;

  @ApiProperty({ description: 'Total number of conversations', example: 42 })
  @Expose()
  total: number;

  @ApiProperty({ description: 'Total number of pages', example: 5 })
  @Expose()
  totalPages: number;
}

export class ConversationListResponseDto {
  @ApiProperty({ type: [ConversationListItemDto] })
  @Expose()
  conversations: ConversationListItemDto[];

  @ApiProperty({ type: ConversationListMetaDto })
  @Expose()
  meta: ConversationListMetaDto;
}
