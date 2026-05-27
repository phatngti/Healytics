import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { MessageType } from '@/chat/enums/message-type.enum';
import { PartnerChatMessage } from '@/common/entities/partner-chat-message.entity';

export class ChatAttachmentResponseDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String })
  @Expose()
  fileUrl: string;

  @ApiProperty({ type: String })
  @Expose()
  fileName: string;

  @ApiProperty({ type: String })
  @Expose()
  fileType: string;

  @ApiProperty({ type: Number })
  @Expose()
  fileSize: number;
}

export class ChatMessageResponseDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String })
  @Expose()
  conversationId: string;

  @ApiProperty({ type: String })
  @Expose()
  senderId: string;

  @ApiProperty({ type: String })
  @Expose()
  receiverId: string;

  @ApiPropertyOptional({ type: String })
  @Expose()
  senderName?: string;

  @ApiPropertyOptional({ type: String })
  @Expose()
  senderAvatar?: string;

  @ApiProperty({ type: String })
  @Expose()
  content: string;

  @ApiProperty({ enum: MessageType, enumName: 'MessageType' })
  @Expose()
  messageType: MessageType;

  @ApiPropertyOptional({ type: String })
  @Expose()
  clientMessageId?: string;

  @ApiPropertyOptional({ type: [ChatAttachmentResponseDto] })
  @Expose()
  @Type(() => ChatAttachmentResponseDto)
  attachments?: ChatAttachmentResponseDto[];

  @ApiProperty({ type: Date })
  @Expose()
  createdAt: Date;

  /**
   * Map a ChatMessage entity to the response DTO.
   */
  static fromEntity(entity: PartnerChatMessage): ChatMessageResponseDto {
    const dto = new ChatMessageResponseDto();
    dto.id = entity.id;
    dto.conversationId = entity.conversationId;
    dto.senderId = entity.senderId;
    dto.content = entity.content;
    dto.messageType = entity.messageType;
    dto.clientMessageId = entity.clientMessageId ?? undefined;
    dto.createdAt = entity.createdAt;

    // Sender info from joined relation
    if (entity.sender) {
      const profile = (entity.sender as any).userProfile;
      dto.senderName = profile?.fullName ?? entity.sender.email;
      dto.senderAvatar = profile?.avatarUrl ?? undefined;
    }

    // Attachments
    if (entity.attachments?.length) {
      dto.attachments = entity.attachments.map((a) => {
        const att = new ChatAttachmentResponseDto();
        att.id = a.id;
        att.fileUrl = a.fileUrl;
        att.fileName = a.fileName;
        att.fileType = a.fileType;
        att.fileSize = a.fileSize;
        return att;
      });
    }

    return dto;
  }

  static fromEntities(
    entities: PartnerChatMessage[],
  ): ChatMessageResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
