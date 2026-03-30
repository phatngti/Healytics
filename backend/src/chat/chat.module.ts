import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from '@/auth/constants';
import { AccountModule } from '@/account/account.module';
import { Conversation } from '@/common/entities/conversation.entity';
import { ChatMessage } from '@/common/entities/chat-message.entity';
import { ChatAttachment } from '@/common/entities/chat-attachment.entity';
import { ChatService } from './chat.service';
import { WsChatDocsController } from './ws-chat-docs.controller';
import { UserChatController } from './user-chat.controller';
import { PartnerChatController } from './partner-chat.controller';
import { UserChatGateway } from './ws/user-chat.gateway';
import { PartnerChatGateway } from './ws/partner-chat.gateway';
import { SendMessageHandler } from './application/handlers/send-message.handler';
import { CreateConversationHandler } from './application/handlers/create-conversation.handler';
import { GetConversationMessagesHandler } from './application/handlers/get-conversation-messages.handler';
import { MarkMessagesReadHandler } from './application/handlers/mark-messages-read.handler';
import { GetUserConversationsHandler } from './application/handlers/get-user-conversations.handler';
import { GetPartnerConversationsHandler } from './application/handlers/get-partner-conversations.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([Conversation, ChatMessage, ChatAttachment]),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '3600s' },
    }),
    AccountModule, // Provides AccountService for WS JWT auth
  ],
  controllers: [UserChatController, PartnerChatController, WsChatDocsController],
  providers: [
    // Service facade
    ChatService,
    // WebSocket gateways
    UserChatGateway,
    PartnerChatGateway,
    // Domain handlers
    SendMessageHandler,
    CreateConversationHandler,
    GetConversationMessagesHandler,
    MarkMessagesReadHandler,
    GetUserConversationsHandler,
    GetPartnerConversationsHandler,
  ],
  exports: [ChatService],
})
export class ChatModule {}
