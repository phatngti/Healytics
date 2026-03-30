import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ConversationStatus } from '@/chat/enums/conversation-status.enum';
import { Conversation } from '@/common/entities/conversation.entity';

class ParticipantInfoDto {
  @ApiProperty()
  @Expose()
  id: string;

  @ApiProperty()
  @Expose()
  name: string;

  @ApiPropertyOptional()
  @Expose()
  avatar?: string;

  @ApiProperty()
  @Expose()
  role: string;
}

class LastMessageDto {
  @ApiPropertyOptional()
  @Expose()
  text?: string;

  @ApiPropertyOptional()
  @Expose()
  timestamp?: Date;

  @ApiPropertyOptional()
  @Expose()
  senderId?: string;
}

/**
 * Conversation list item response DTO.
 */
export class ConversationResponseDto {
  @ApiProperty()
  @Expose()
  id: string;

  @ApiProperty({ enum: ConversationStatus })
  @Expose()
  status: ConversationStatus;

  @ApiPropertyOptional()
  @Expose()
  bookingId?: string;

  @ApiProperty({ type: ParticipantInfoDto })
  @Expose()
  @Type(() => ParticipantInfoDto)
  otherParticipant: ParticipantInfoDto;

  @ApiProperty({ type: LastMessageDto })
  @Expose()
  @Type(() => LastMessageDto)
  lastMessage: LastMessageDto;

  @ApiProperty()
  @Expose()
  unreadCount: number;

  @ApiProperty()
  @Expose()
  createdAt: Date;

  /**
   * Build a conversation response for a specific viewer.
   * @param entity The conversation entity with loaded user/partnerAccount relations
   * @param viewerAccountId The account ID of the person viewing the list
   */
  static fromEntity(entity: Conversation, viewerAccountId: string): ConversationResponseDto {
    const dto = new ConversationResponseDto();
    dto.id = entity.id;
    dto.status = entity.status;
    dto.bookingId = entity.bookingId ?? undefined;
    dto.createdAt = entity.createdAt;

    // Determine who is the "other" participant from the viewer's perspective
    const isUser = entity.userId === viewerAccountId;

    // Unread count for the viewer
    dto.unreadCount = isUser ? entity.userUnreadCount : entity.partnerUnreadCount;

    // Other participant info
    const otherAccount = isUser ? entity.partnerAccount : entity.user;
    dto.otherParticipant = {
      id: otherAccount?.id ?? (isUser ? entity.partnerAccountId : entity.userId),
      name: (otherAccount as any)?.userProfile?.fullName
        ?? otherAccount?.username
        ?? otherAccount?.email
        ?? 'Unknown',
      avatar: (otherAccount as any)?.userProfile?.avatarUrl ?? undefined,
      role: isUser ? 'partner' : 'user',
    };

    // Last message summary
    dto.lastMessage = {
      text: entity.lastMessageText ?? undefined,
      timestamp: entity.lastMessageAt ?? undefined,
      senderId: entity.lastMessageSenderId ?? undefined,
    };

    return dto;
  }

  static fromEntities(entities: Conversation[], viewerAccountId: string): ConversationResponseDto[] {
    return entities.map((e) => this.fromEntity(e, viewerAccountId));
  }
}
