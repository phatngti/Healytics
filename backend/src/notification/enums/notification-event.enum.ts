/**
 * WebSocket event names for the notification system.
 * Used by the NotificationGateway and frontend clients.
 */
export enum NotificationEvent {
  // ── Server → Client ──────────────────────────────────────────
  /** A new notification was created and pushed to the user */
  NEW_NOTIFICATION = 'new_notification',

  /** The unread count has changed (after mark-read or new notification) */
  UNREAD_COUNT = 'unread_count',

  // ── Server → Client (admin) ──────────────────────────────────
  /** A system-wide broadcast was sent */
  BROADCAST_SENT = 'broadcast_sent',
}
