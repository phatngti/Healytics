/**
 * WebSocket event names for the chat system.
 * Used by both gateways and clients for type-safe event handling.
 */
export enum ChatEvent {
  // ── Client → Server ──────────────────────────────────────────
  SEND_MESSAGE = 'send_message',
  TYPING = 'typing',
  STOP_TYPING = 'stop_typing',
  MARK_READ = 'mark_read',
  JOIN_CONVERSATION = 'join_conversation',

  // ── Server → Client ──────────────────────────────────────────
  NEW_MESSAGE = 'new_message',
  MESSAGE_SENT = 'message_sent',
  MESSAGES_READ = 'messages_read',
  USER_ONLINE = 'user_online',
  USER_OFFLINE = 'user_offline',
  CONVERSATION_UPDATED = 'conversation_updated',
  ERROR = 'error',
}
