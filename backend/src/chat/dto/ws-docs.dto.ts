import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MessageType } from '@/chat/enums/message-type.enum';
import { WsModel } from '@/common/decorators/ws';

// ─── Connection DTOs ───────────────────────────────────────────

export class WsConnectionInfoDto {
  @ApiProperty({
    description: 'Socket.IO namespace URL for WebSocket connection',
    example: 'ws://localhost:8080/user-chat',
  })
  url: string;

  @ApiProperty({
    description:
      'Authentication method — pass JWT token in the Socket.IO auth object',
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

@WsModel({ description: 'Payload for sending a message via WebSocket' })
export class WsSendMessagePayloadDto {
  @ApiProperty({
    description: 'Target conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Target receiver UUID',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;

  @ApiProperty({
    description: 'Message text content (max 5000 chars)',
    example: 'Hello, I have a question about my appointment.',
  })
  content: string;

  @ApiPropertyOptional({
    description: 'Type of message',
    enum: MessageType,
    enumName: 'MessageType',
    default: MessageType.TEXT,
  })
  messageType?: MessageType;

  @ApiPropertyOptional({
    description: 'Client-generated UUID for idempotent delivery',
    example: 'client-uuid-abc-123',
  })
  clientMessageId?: string;
}

@WsModel({ description: 'Payload containing only a conversation ID' })
export class WsTypingPayloadDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Target receiver UUID',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;
}

@WsModel({ description: 'Payload containing only a conversation ID' })
export class WsMarkReadPayloadDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Target receiver UUID',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;
}

@WsModel({ description: 'Payload containing only a conversation ID' })
export class WsJoinConversationPayloadDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;
}

// ─── Server → Client Event Payloads ────────────────────────────

@WsModel({ description: 'Server event: a new message in a conversation' })
export class WsNewMessageEventDto {
  @ApiProperty({
    description: 'Server-generated message UUID',
    example: '660e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Account ID of the sender',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  senderId: string;

  @ApiProperty({
    description: 'Account ID of the receiver',
    example: '880e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;

  @ApiPropertyOptional({
    description: 'Display name of the sender',
    example: 'Dr. Nguyen Van A',
  })
  senderName?: string;

  @ApiPropertyOptional({
    description: 'Avatar URL of the sender',
    example: 'https://s3.example.com/avatars/doctor.jpg',
  })
  senderAvatar?: string;

  @ApiProperty({
    description: 'Message text content',
    example: 'Hello, I have a question about my appointment.',
  })
  content: string;

  @ApiProperty({
    description: 'Type of message',
    enum: MessageType,
    enumName: 'MessageType',
    example: MessageType.TEXT,
  })
  messageType: MessageType;

  @ApiPropertyOptional({
    description: 'Echoed client message ID for matching',
    example: 'client-uuid-abc-123',
  })
  clientMessageId?: string;

  @ApiProperty({
    description: 'When the message was created',
    example: '2026-03-31T00:00:00.000Z',
    type: Date,
  })
  createdAt: Date;
}

@WsModel({ description: 'Server acknowledgement after persisting a message' })
export class WsMessageSentAckDto {
  @ApiProperty({
    description: 'Server-generated message UUID',
    example: '660e8400-e29b-41d4-a716-446655440000',
  })
  id: string;

  @ApiPropertyOptional({
    description: 'Echoed client message ID for matching',
    example: 'client-uuid-abc-123',
  })
  clientMessageId?: string;
}

@WsModel({ description: 'Server event: messages were read by the other party' })
export class WsMessagesReadEventDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Account ID of the reader',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  readerId: string;

  @ApiProperty({
    description: 'Account ID of the message sender (who is being notified)',
    example: '880e8400-e29b-41d4-a716-446655440000',
  })
  receiverId?: string;

  @ApiProperty({
    description: 'When the messages were marked as read',
    example: '2026-03-31T00:00:00.000Z',
    type: Date,
  })
  readAt: Date;
}

@WsModel({ description: 'Server event: the other party is typing' })
export class WsTypingEventDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Account ID of the typer',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  userId: string;

  @ApiProperty({
    description: 'Account ID of the receiver',
    example: '880e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;

  @ApiProperty({
    description: 'Display name of the typer',
    example: 'Dr. Nguyen Van A',
  })
  userName: string;
}

@WsModel({ description: 'Server event: the other party stopped typing' })
export class WsStopTypingEventDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Account ID',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  userId: string;

  @ApiProperty({
    description: 'Account ID of the receiver',
    example: '880e8400-e29b-41d4-a716-446655440000',
  })
  receiverId: string;
}

@WsModel({ description: 'Server error event' })
export class WsErrorEventDto {
  @ApiProperty({
    description: 'Error message',
    example: 'You are not a participant of this conversation',
  })
  message: string;
}

// ─── Global Chat Notification Payloads ─────────────────────────

@WsModel({
  description:
    'Global notification event: a new chat message was received. ' +
    'Emitted on /chat-notifications namespace for popup notifications.',
})
export class WsNewMessageNotificationDto {
  @ApiProperty({
    description: 'Conversation UUID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  conversationId: string;

  @ApiProperty({
    description: 'Server-generated message UUID',
    example: '660e8400-e29b-41d4-a716-446655440000',
  })
  messageId: string;

  @ApiProperty({
    description: 'Account ID of the message sender',
    example: '770e8400-e29b-41d4-a716-446655440000',
  })
  senderId: string;

  @ApiProperty({
    description: 'Display name of the sender (for notification title)',
    example: 'Dr. Nguyen Van A',
  })
  senderName: string;

  @ApiPropertyOptional({
    description: 'Avatar URL of the sender (for notification icon)',
    example: 'https://s3.example.com/avatars/doctor.jpg',
  })
  senderAvatar?: string;

  @ApiProperty({
    description: 'First ~100 characters of the message content (for preview)',
    example: 'Hello, I have a question about my appointment.',
  })
  messagePreview: string;

  @ApiProperty({
    description: 'Type of message (text, image, file, etc.)',
    enum: MessageType,
    enumName: 'MessageType',
    example: MessageType.TEXT,
  })
  messageType: MessageType;

  @ApiProperty({
    description: 'When the message was created',
    example: '2026-04-06T00:00:00.000Z',
    type: Date,
  })
  createdAt: Date;
}
