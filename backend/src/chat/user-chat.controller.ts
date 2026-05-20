import {
  Get,
  Post,
  Body,
  Param,
  Query,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiOperation,
  ApiOkResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { ChatService } from './chat.service';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { ConversationResponseDto } from './dto/conversation-response.dto';
import { ChatMessageResponseDto } from './dto/chat-message-response.dto';
import { MessagesQueryDto } from './dto/messages-query.dto';

/**
 * REST controller for user (patient) chat operations.
 * Route: /v1/user/chat
 *
 * Used for conversation management and message history retrieval.
 * Real-time messaging is handled via the UserChatGateway WebSocket.
 */
@UserApi('chat')
export class UserChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get('conversations')
  @ApiOperation({ summary: 'List all conversations for the current user' })
  @ApiOkResponse({ type: [ConversationResponseDto] })
  getConversations(
    @CurrentUser('id') userId: string,
  ): Promise<ConversationResponseDto[]> {
    return this.chatService.userConversations(userId);
  }

  @Get('conversations/:id/messages')
  @ApiOperation({
    summary: 'Get message history for a conversation (cursor-paginated)',
  })
  @ApiOkResponse({ description: 'Paginated message list with hasMore flag' })
  @ApiNotFoundResponse({
    description: 'Conversation not found or not a participant',
  })
  getMessages(
    @Param('id', ParseUUIDPipe) conversationId: string,
    @CurrentUser('id') userId: string,
    @Query() query: MessagesQueryDto,
  ): Promise<{
    messages: ChatMessageResponseDto[];
    hasMore: boolean;
    nextCursor: string | null;
  }> {
    return this.chatService.messagesFor(conversationId, userId, query);
  }

  @Post('conversations')
  @ApiOperation({ summary: 'Create a new conversation with a health partner' })
  @ApiCreatedResponse({ type: ConversationResponseDto })
  createConversation(
    @Body() dto: CreateConversationDto,
    @CurrentUser('id') userId: string,
  ): Promise<ConversationResponseDto> {
    return this.chatService.create(dto, userId);
  }

  @Post('conversations/:id/read')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Mark all messages in a conversation as read' })
  @ApiNoContentResponse()
  markRead(
    @Param('id', ParseUUIDPipe) conversationId: string,
    @CurrentUser('id') userId: string,
  ): Promise<void> {
    return this.chatService.markAsRead(conversationId, userId);
  }
}
