import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { ScheduleModule } from '@nestjs/schedule';
import { ConfigModule } from '@nestjs/config';
import { jwtConstants } from '@/auth/constants';
import { AccountModule } from '@/account/account.module';
import { Account } from '@/common/entities/account.entity';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { Booking } from '@/common/entities/booking.entity';
import pushConfig from './push/push.config';

// Service facade
import { NotificationService } from './notification.service';

// WebSocket gateway
import { NotificationGateway } from './ws/notification.gateway';

// Domain handlers
import { CreateNotificationHandler } from './application/handlers/create-notification.handler';
import { CreateBroadcastHandler } from './application/handlers/create-broadcast.handler';
import { MarkNotificationReadHandler } from './application/handlers/mark-notification-read.handler';
import { MarkAllReadHandler } from './application/handlers/mark-all-read.handler';

// Services
import { NotificationEventService } from './services/notification-event.service';
import { NotificationProcessorService } from './services/notification-processor.service';
import { AppointmentReminderService } from './services/appointment-reminder.service';
import { PushNotificationService } from './push/push-notification.service';

// Controllers
import { UserNotificationController } from './user-notification.controller';
import { AdminNotificationController } from './admin-notification.controller';
import { UserDeviceController } from './user-device.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Account,
      Notification,
      NotificationRead,
      DeviceToken,
      Booking,
    ]),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '3600s' },
    }),
    ScheduleModule.forRoot(),
    ConfigModule.forFeature(pushConfig),
    AccountModule,
  ],
  controllers: [
    UserNotificationController,
    AdminNotificationController,
    UserDeviceController,
    NotificationProcessorService,
  ],
  providers: [
    // Service facade
    NotificationService,
    // WebSocket gateway
    NotificationGateway,
    // Domain handlers
    CreateNotificationHandler,
    CreateBroadcastHandler,
    MarkNotificationReadHandler,
    MarkAllReadHandler,
    // Services
    NotificationEventService,
    AppointmentReminderService,
    PushNotificationService,
  ],
  exports: [NotificationService, NotificationEventService],
})
export class NotificationModule {}
