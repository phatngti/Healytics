// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-integration.sh ws
// =============================================================

// ignore_for_file: type=lint
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: unused_element

/// WebSocket event constants for the WsBookingEventsEvent namespace(s).
///
/// Client → Server events are used with `socket.emit()`.
/// Server → Client events are used with `socket.on()`.
abstract final class WsBookingEventsEvent {
  WsBookingEventsEvent._();

  // ── Server → Client ────────────────────────────────

  /// A booking status changed and should update local UI state
  static const bookingStatusChanged = 'booking.status.changed';
}

/// WebSocket event constants for the WsChatEvent namespace(s).
///
/// Client → Server events are used with `socket.emit()`.
/// Server → Client events are used with `socket.on()`.
abstract final class WsChatEvent {
  WsChatEvent._();

  // ── Client → Server ────────────────────────────────

  /// Send a chat message
  static const sendMessage = 'send_message';

  /// Notify the other party that the user is typing
  static const typing = 'typing';

  /// Notify the other party that the user stopped typing
  static const stopTyping = 'stop_typing';

  /// Mark all messages in a conversation as read
  static const markRead = 'mark_read';

  /// Join a conversation room (auto-joined on connect; use for new conversations)
  static const joinConversation = 'join_conversation';

  // ── Server → Client ────────────────────────────────

  /// A new message was sent in a conversation the user has joined
  static const newMessage = 'new_message';

  /// Acknowledgement that the server persisted the user's message
  static const messageSent = 'message_sent';

  /// The other party read messages in a conversation
  static const messagesRead = 'messages_read';

  /// A server error occurred while processing a WS event
  static const error = 'error';
}

/// WebSocket event constants for the WsChatNotificationsEvent namespace(s).
///
/// Client → Server events are used with `socket.emit()`.
/// Server → Client events are used with `socket.on()`.
abstract final class WsChatNotificationsEvent {
  WsChatNotificationsEvent._();

  // ── Server → Client ────────────────────────────────

  /// A new chat message was received — show a popup notification
  static const newMessageNotification = 'new_message_notification';
}

/// WebSocket event constants for the WsNotificationsEvent namespace(s).
///
/// Client → Server events are used with `socket.emit()`.
/// Server → Client events are used with `socket.on()`.
abstract final class WsNotificationsEvent {
  WsNotificationsEvent._();

  // ── Server → Client ────────────────────────────────

  /// A new notification was pushed to the user
  static const newNotification = 'new_notification';

  /// The unread notification count changed (after new notification or mark-read)
  static const unreadCount = 'unread_count';

  /// A system-wide broadcast was sent (admin-facing)
  static const broadcastSent = 'broadcast_sent';
}

