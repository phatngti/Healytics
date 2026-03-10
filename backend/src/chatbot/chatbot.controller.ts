import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  Query,
  Sse,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
  NotFoundException,
  ParseUUIDPipe,
  MessageEvent,
  Logger,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiNotFoundResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { Observable, of } from 'rxjs';
import { catchError, finalize, tap } from 'rxjs/operators';
import { ChatbotService } from './chatbot.service';
import { SendMessageDto } from './dto/send-message.dto';
import { SendMessageResponseDto } from './dto/chat-message-response.dto';
import {
  ConversationListQueryDto,
  ConversationListResponseDto,
} from './dto/conversation-list.dto';
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
@Controller({ path: 'chatbot' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class ChatbotController {
  private readonly logger = new Logger(ChatbotController.name);

  constructor(private readonly chatbotService: ChatbotService) {}

  /**
   * Retrieve the authenticated user's conversation list with pagination.
   *
   * Query params:
   * - `page`  — 1-indexed page number (default: 1)
   * - `limit` — items per page, 1-100 (default: 10)
   */
  @Get('conversations')
  @Roles(Role.USER)
  @ApiOperation({ summary: 'Get paginated list of conversations' })
  @ApiOkResponse({
    description: 'Paginated conversation list',
    type: ConversationListResponseDto,
  })
  listConversations(
    @Query() query: ConversationListQueryDto,
  ): ConversationListResponseDto {
    return this.chatbotService.getConversations(query.page, query.limit);
  }

  // /**
  //  * Submit a message to the chatbot.
  //  * Returns a conversation ID and the SSE stream URL to connect to.
  //  */
  // @Post('send')
  // @Roles(Role.USER)
  // @ApiOperation({ summary: 'Send a message to the chatbot' })
  // @ApiCreatedResponse({
  //   description: 'Message accepted. Use the streamUrl to connect to the SSE response stream.',
  //   type: SendMessageResponseDto,
  // })
  // sendMessage(@Body() dto: SendMessageDto): SendMessageResponseDto {
  //   const conversationId = this.chatbotService.storeMessage(
  //     dto.message,
  //     dto.conversationId,
  //   );

  //   return {
  //     conversationId,
  //     streamUrl: `/chatbot/stream/${conversationId}`,
  //   };
  // }

  // /**
  //  * SSE endpoint that streams the chatbot response as structured events.
  //  *
  //  * Event types:
  //  * - `token`                  — incremental text token
  //  * - `ner_location`           — named-entity recognition for locations
  //  * - `service_recommendation` — ranked service recommendations
  //  * - `done`                   — stream completed
  //  * - `error`                  — stream encountered an error
  //  */
  // @Sse('stream/:conversationId')
  // @Roles(Role.USER)
  // @ApiOperation({ summary: 'Stream chatbot response via SSE' })
  // @ApiOkResponse({ description: 'SSE stream of chatbot events' })
  // @ApiNotFoundResponse({ description: 'Conversation not found or already consumed' })
  // streamChat(
  //   @Param('conversationId', ParseUUIDPipe) conversationId: string,
  // ): Observable<MessageEvent> {
  //   const message = this.chatbotService.getMessage(conversationId);

  //   if (!message) {
  //     this.logger.warn(
  //       `SSE connect FAILED — conversation ${conversationId} not found or already consumed`,
  //     );
  //     throw new NotFoundException(
  //       `Conversation ${conversationId} not found or already consumed`,
  //     );
  //   }

  //   this.logger.log(
  //     `SSE connect OK — conversation ${conversationId}, message: "${message.substring(0, 80)}"`,
  //   );

  //   return this.chatbotService.streamResponse(message, conversationId).pipe(
  //     tap((event) =>
  //       this.logger.debug(
  //         `SSE event [${event.type ?? 'message'}] → conversation ${conversationId}`,
  //       ),
  //     ),
  //     catchError((error) => {
  //       this.logger.error(
  //         `SSE stream ERROR — conversation ${conversationId}: ${error.message}`,
  //         error.stack,
  //       );
  //       const errorEvent: MessageEvent = {
  //         type: 'error',
  //         data: { error: error.message },
  //       } as unknown as MessageEvent;
  //       return of(errorEvent);
  //     }),
  //     finalize(() =>
  //       this.logger.log(
  //         `SSE disconnect — conversation ${conversationId} (client disconnected or stream ended)`,
  //       ),
  //     ),
  //   );
  // }
}
