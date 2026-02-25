import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Possible SSE event types in the chat stream.
 * - `start`: Stream has begun
 * - `token`: A single word/token of the response
 * - `end`: Stream completed, `content` contains the full message
 * - `error`: An error occurred during generation
 */
export type ChatEventType = 'start' | 'token' | 'end' | 'error';

export class ChatMessageResponseDto {
  @ApiProperty({
    description: 'The type of SSE event',
    enum: ['start', 'token', 'end', 'error'],
    example: 'token',
  })
  @Expose()
  type: ChatEventType;

  @ApiProperty({
    description: 'The content payload — a single token for "token" events, full message for "end"',
    example: 'Regular',
  })
  @Expose()
  content: string;

  @ApiProperty({
    description: 'The conversation identifier',
    example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @Expose()
  conversationId: string;

  @ApiProperty({
    description: 'ISO 8601 timestamp of the event',
    example: '2026-02-20T12:30:00.000Z',
  })
  @Expose()
  timestamp: string;
}

export class SendMessageResponseDto {
  @ApiProperty({
    description: 'The conversation ID to use for the SSE stream',
    example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @Expose()
  conversationId: string;

  @ApiProperty({
    description: 'SSE stream URL to connect to',
    example: '/v1/chatbot/stream/a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  })
  @Expose()
  streamUrl: string;
}
