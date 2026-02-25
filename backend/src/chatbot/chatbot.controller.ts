import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  Sse,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
  NotFoundException,
  ParseUUIDPipe,
  MessageEvent,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { Observable } from 'rxjs';
import { ChatbotService } from './chatbot.service';
import { SendMessageDto } from './dto/send-message.dto';
import { SendMessageResponseDto, ChatMessageResponseDto } from './dto/chat-message-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';

/**
 * Chatbot controller providing SSE-based streaming chat responses.
 * API Version 1.
 *
 * Usage flow:
 * 1. POST /v1/chatbot/send — submit a message, receive a conversationId + streamUrl
 * 2. GET  /v1/chatbot/stream/:conversationId — connect to SSE stream for the response
 */
@ApiTags('chatbot')
@ApiBearerAuth()
@Controller({ path: 'chatbot', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class ChatbotController {
  constructor(private readonly chatbotService: ChatbotService) {}

  /**
   * Submit a message to the chatbot.
   * Returns a conversation ID and the SSE stream URL to connect to.
   */
  @Post('send')
  @Roles(Role.USER, Role.ADMIN, Role.HEALTH_PARTNER)
  @ApiOperation({ summary: 'Send a message to the chatbot' })
  @ApiCreatedResponse({
    description: 'Message accepted. Use the streamUrl to connect to the SSE response stream.',
    type: SendMessageResponseDto,
  })
  sendMessage(@Body() dto: SendMessageDto): SendMessageResponseDto {
    const conversationId = this.chatbotService.storeMessage(
      dto.message,
      dto.conversationId,
    );

    return {
      conversationId,
      streamUrl: `/v1/chatbot/stream/${conversationId}`,
    };
  }

  /**
   * SSE endpoint that streams the chatbot response word-by-word.
   *
   * Event types:
   * - `start`  — stream has begun
   * - `token`  — a single word of the response
   * - `end`    — stream completed, `content` has the full message
   */
  @Sse('stream/:conversationId')
  @Roles(Role.USER, Role.ADMIN, Role.HEALTH_PARTNER)
  @ApiOperation({ summary: 'Stream chatbot response via SSE' })
  @ApiOkResponse({
    description: 'SSE stream of chat response tokens',
    type: ChatMessageResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Conversation not found or already consumed' })
  streamChat(
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
  ): Observable<MessageEvent> {
    const message = this.chatbotService.getMessage(conversationId);

    if (!message) {
      throw new NotFoundException(
        `Conversation ${conversationId} not found or already consumed`,
      );
    }

    return this.chatbotService.streamResponse(message, conversationId);
  }
}
