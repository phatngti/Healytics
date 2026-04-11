import { Injectable, Logger, Inject } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { RABBITMQ_CLIENT } from '@/rabbitmq/rabbitmq.module';
import { NotificationEventPayload } from '@/notification/dto/notification-event.payload';

/**
 * Lightweight event producer for notification events.
 *
 * Other modules inject this service and call `emit()` to trigger
 * notifications without tight coupling to the notification module's internals.
 *
 * Events are published to RabbitMQ and processed asynchronously by
 * NotificationProcessorService.
 */
@Injectable()
export class NotificationEventService {
  private readonly logger = new Logger(NotificationEventService.name);

  constructor(
    @Inject(RABBITMQ_CLIENT) private readonly rmqClient: ClientProxy,
  ) {}

  /**
   * Emit a notification event to the message broker.
   * Fire-and-forget — does not block the calling handler.
   */
  emit(event: NotificationEventPayload): void {
    this.logger.log(
      `Emitting notification event: type=${event.type} recipientId=${event.recipientId ?? 'broadcast'}`,
    );
    try {
      this.rmqClient.emit('notification.event', event);
    } catch (error) {
      this.logger.error(
        `RabbitMQ emit failed for notification.event — type=${event.type}, recipientId=${event.recipientId ?? 'broadcast'}, title="${event.title}", data=${JSON.stringify(event.data ?? {})}`,
        error.stack,
      );
      // Don't re-throw — fire-and-forget semantics
    }
  }
}
