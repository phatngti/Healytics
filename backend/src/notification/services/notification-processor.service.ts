import { Controller, Logger } from '@nestjs/common';
import { EventPattern, Payload, Ctx, RmqContext } from '@nestjs/microservices';
import { NotificationEventPayload } from '@/notification/dto/notification-event.payload';
import { NotificationService } from '@/notification/notification.service';

/**
 * RabbitMQ consumer that processes notification events.
 *
 * Listens for events emitted by `NotificationEventService` and:
 * 1. Persists the notification to the database
 * 2. Pushes it in real-time via the WebSocket gateway
 * 3. Sends push notifications to offline users (FCM/APNs)
 */
@Controller()
export class NotificationProcessorService {
  private readonly logger = new Logger(NotificationProcessorService.name);

  constructor(
    private readonly notificationService: NotificationService,
  ) {}

  @EventPattern('notification.event')
  async handleNotificationEvent(
    @Payload() payload: NotificationEventPayload,
    @Ctx() context: RmqContext,
  ): Promise<void> {
    this.logger.log(
      `Processing notification event: type=${payload.type} recipientId=${payload.recipientId ?? 'broadcast'}`,
    );

    try {
      if (payload.isBroadcast) {
        await this.notificationService.createAndPushBroadcast({
          title: payload.title,
          body: payload.body,
          data: payload.data,
          senderId: payload.senderId!,
        });
      } else if (payload.recipientId) {
        await this.notificationService.createAndPushNotification({
          recipientId: payload.recipientId,
          type: payload.type,
          title: payload.title,
          body: payload.body,
          data: payload.data,
        });
      } else {
        this.logger.warn(
          `Notification event has no recipient and is not a broadcast — skipping`,
        );
      }

      // Acknowledge the message
      const channel = context.getChannelRef();
      const originalMsg = context.getMessage();
      channel.ack(originalMsg);
    } catch (error) {
      this.logger.error(
        `Failed to process notification event: ${(error as Error).message}`,
        (error as Error).stack,
      );
      // Negative acknowledge — message will be requeued
      const channel = context.getChannelRef();
      const originalMsg = context.getMessage();
      channel.nack(originalMsg, false, true);
    }
  }
}
