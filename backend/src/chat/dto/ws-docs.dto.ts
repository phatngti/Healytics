import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MessageType } from '@/chat/enums/message-type.enum';

// ─── Connection DTOs ───────────────────────────────────────────

export class WsConnectionInfoDto {
  @ApiProperty({
    description: 'Socket.IO namespace URL for WebSocket connection',
    example: 'ws://localhost:8080/user-chat',
  })
  url: string;

  @ApiProperty({
    description: 'Authentication method — pass JWT token in the Socket.IO auth object',
    example: '{ auth: { token: "eyJhbGciOiJIUzI1NiIs..." } }',
  })
  auth: string;

  @ApiProperty({
    description: 'Allowed roles for this gateway',
    example: ['user'],
  })
  allowedRoles: string[];
}

// ─── Client → Server Event Payloads ────────────────────────────

export class WsSendMessagePayloadDto {
  @ApiProperty({ description: 'Target conversation UUID', example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;

  @ApiProperty({ description: 'Message text content (max 5000 chars)', example: 'Hello, I have a question about my appointment.' })
  content: string;

  @ApiPropertyOptional({ description: 'Message type', enum: MessageType, default: MessageType.TEXT })
  messageType?: MessageType;

  @ApiPropertyOptional({ description: 'Client-generated UUID for idempotent delivery (prevents duplicates on retry)', example: 'client-uuid-abc-123' })
  clientMessageId?: string;
}

export class WsTypingPayloadDto {
  @ApiProperty({ description: 'Conversation UUID where user is typing', example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;
}

export class WsMarkReadPayloadDto {
  @ApiProperty({ description: 'Conversation UUID to mark as read', example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;
}

export class WsJoinConversationPayloadDto {
  @ApiProperty({ description: 'Conversation UUID to join (auto-joined on connect, use this for new conversations)', example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;
}

// ─── Server → Client Event Payloads ────────────────────────────

export class WsNewMessageEventDto {
  @ApiProperty({ example: '660e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;

  @ApiProperty({ example: '770e8400-e29b-41d4-a716-446655440000' })
  senderId: string;

  @ApiPropertyOptional({ example: 'Dr. Nguyen Van A' })
  senderName?: string;

  @ApiPropertyOptional({ example: 'https://s3.example.com/avatars/doctor.jpg' })
  senderAvatar?: string;

  @ApiProperty({ example: 'Hello, I have a question about my appointment.' })
  content: string;

  @ApiProperty({ enum: MessageType, example: MessageType.TEXT })
  messageType: MessageType;

  @ApiPropertyOptional({ example: 'client-uuid-abc-123' })
  clientMessageId?: string;

  @ApiProperty({ example: '2026-03-31T00:00:00.000Z' })
  createdAt: Date;
}

export class WsMessageSentAckDto {
  @ApiProperty({ description: 'Server-generated message UUID', example: '660e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiPropertyOptional({ description: 'Echoed client message ID for matching', example: 'client-uuid-abc-123' })
  clientMessageId?: string;
}

export class WsMessagesReadEventDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;

  @ApiProperty({ description: 'Account ID of the reader', example: '770e8400-e29b-41d4-a716-446655440000' })
  readerId: string;

  @ApiProperty({ example: '2026-03-31T00:00:00.000Z' })
  readAt: Date;
}

export class WsTypingEventDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;

  @ApiProperty({ example: '770e8400-e29b-41d4-a716-446655440000' })
  userId: string;

  @ApiProperty({ example: 'Dr. Nguyen Van A' })
  userName: string;
}

export class WsStopTypingEventDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  conversationId: string;

  @ApiProperty({ example: '770e8400-e29b-41d4-a716-446655440000' })
  userId: string;
}

export class WsErrorEventDto {
  @ApiProperty({ description: 'Error message', example: 'You are not a participant of this conversation' })
  message: string;
}
