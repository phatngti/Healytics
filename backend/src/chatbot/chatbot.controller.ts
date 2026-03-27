import {
  Controller,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { ChatbotService } from './chatbot.service';

/**
 * Chatbot controller providing SSE-based streaming chat responses.
 * API Version 1.
 *
 * Usage flow:
 * 1. POST /v1/chatbot/send — submit a message, receive a conversationId + streamUrl
 * 2. GET  /v1/chatbot/stream/:conversationId — connect to SSE stream for the response
 *
 * NOTE: Endpoints are currently disabled (commented out) pending AI integration.
 */
@ApiTags('Chatbot')
@ApiBearerAuth()
@Controller({ path: 'chatbot', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class ChatbotController {
  constructor(private readonly chatbotService: ChatbotService) {}
}
