import { NotificationType } from '@/notification/enums/notification-type.enum';

/**
 * Internal payload structure for notification events flowing through RabbitMQ.
 * NOT an API DTO — used only in-process and via the message broker.
 */
export interface NotificationEventPayload {
  /** The type of notification to create */
  type: NotificationType;

  /**
   * Target user ID for targeted notifications.
   * NULL or omitted for broadcasts.
   */
  recipientId?: string | null;

  /** Notification title */
  title: string;

  /** Notification body text */
  body: string;

  /** Optional deep-link data for frontend routing */
  data?: Record<string, any>;

  /** For broadcasts: the admin who sent it */
  senderId?: string;

  /** Whether this is a system-wide broadcast */
  isBroadcast?: boolean;
}
