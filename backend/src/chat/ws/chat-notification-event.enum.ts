/**
 * WebSocket event names for the global chat notification gateway.
 *
 * These events are emitted on the `/chat-notifications` namespace
 * and are received by ALL authenticated roles (user, partner, employee).
 * Used to power popup notifications across the entire app.
 */
export enum ChatNotificationEvent {
  // ── Server → Client ──────────────────────────────────────────
  /** A new chat message was received — triggers a popup notification */
  NEW_MESSAGE_NOTIFICATION = 'new_message_notification',
}
