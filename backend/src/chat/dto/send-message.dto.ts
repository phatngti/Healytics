import {
  IsString,
  IsNotEmpty,
  MaxLength,
  IsOptional,
  IsEnum,
  IsUUID,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MessageType } from '@/chat/enums/message-type.enum';

/**
 * DTO for sending a message via WebSocket or REST.
 */
export class SendMessageDto {
  @ApiProperty({ description: 'Conversation to send the message to' })
  @IsUUID()
  @IsNotEmpty()
  conversationId: string;

  @ApiProperty({ description: 'ID of the recipient (User ID or Partner ID)' })
  @IsUUID()
  @IsNotEmpty()
  receiverId: string;

  @ApiProperty({
    description: 'Message content',
    example: 'Hello, I have a question about my appointment.',
  })
  @IsString()
  @IsNotEmpty()
  @MaxLength(5000)
  content: string;

  @ApiPropertyOptional({
    description: 'Type of message',
    enum: MessageType,
    default: MessageType.TEXT,
  })
  @IsOptional()
  @IsEnum(MessageType)
  messageType?: MessageType;

  @ApiPropertyOptional({
    description: 'Client-generated ID for idempotent delivery',
    example: 'client-uuid-123',
  })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  clientMessageId?: string;
}
