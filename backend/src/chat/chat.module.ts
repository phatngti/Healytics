import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from '@/auth/constants';
import { AccountModule } from '@/account/account.module';
import { NotificationModule } from '@/notification/notification.module';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { PartnerChatMessage } from '@/common/entities/partner-chat-message.entity';
import { PartnerChatAttachment } from '@/common/entities/partner-chat-attachment.entity';
import { ChatService } from './chat.service';

import { UserChatController } from './user-chat.controller';
import { PartnerChatController } from './partner-chat.controller';
import { UserChatGateway } from './ws/user-chat.gateway';
import { PartnerChatGateway } from './ws/partner-chat.gateway';
import { ChatNotificationGateway } from './ws/chat-notification.gateway';
import { SendMessageHandler } from './application/handlers/send-message.handler';
import { CreateConversationHandler } from './application/handlers/create-conversation.handler';
import { GetConversationMessagesHandler } from './application/handlers/get-conversation-messages.handler';
import { MarkMessagesReadHandler } from './application/handlers/mark-messages-read.handler';
import { GetUserConversationsHandler } from './application/handlers/get-user-conversations.handler';
import { GetPartnerConversationsHandler } from './application/handlers/get-partner-conversations.handler';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      PartnerConversation,
      PartnerChatMessage,
      PartnerChatAttachment,
    ]),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '3600s' },
    }),
    AccountModule, // Provides AccountService for WS JWT auth
    NotificationModule, // Provides NotificationEventService for chat→notification pipeline
  ],
  controllers: [UserChatController, PartnerChatController],
  providers: [
    // Service facade
    ChatService,
    // WebSocket gateways
    UserChatGateway,
    PartnerChatGateway,
    ChatNotificationGateway,
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

