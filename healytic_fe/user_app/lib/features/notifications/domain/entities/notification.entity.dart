// Domain entity — pure Dart, no Flutter imports.

/// The type of notification card to render.
enum NotificationType {
  /// A user-to-user interaction (message, share).
  userInteraction,

  /// A system-generated alert (order, security, gift).
  systemAlert,
}

/// An icon identifier for system alert
/// notifications, mapped to Material Symbols in
/// the presentation layer.
enum NotificationIcon {
  shipping,
  gift,
  shield,
  info,
}

/// Action button style for the notification card.
enum NotificationActionStyle {
  /// Filled primary gradient button.
  filled,

  /// Soft tonal (secondary-container) button.
  tonal,

  /// Outlined border button.
  outlined,

  /// Plain text with trailing arrow.
  text,
}

/// Represents a single in-app notification.
class NotificationEntity {
  final String id;
  final NotificationType type;

  /// Human-readable title (system alerts) or
  /// sender name (user interactions).
  final String title;

  /// Main body text of the notification.
  final String body;

  /// Optional quoted message (user interactions).
  final String? quote;

  /// Relative time label, e.g. "2m ago".
  final String timeAgo;

  /// Sender avatar URL (user interactions only).
  final String? avatarUrl;

  /// Icon for system alert cards.
  final NotificationIcon? icon;

  /// Label on the action button.
  final String actionLabel;

  /// Style of the action button.
  final NotificationActionStyle actionStyle;

  /// Whether this notification has been read.
  final bool isRead;

  /// The date section this notification belongs to.
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.quote,
    required this.timeAgo,
    this.avatarUrl,
    this.icon,
    required this.actionLabel,
    required this.actionStyle,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          body == other.body &&
          quote == other.quote &&
          timeAgo == other.timeAgo &&
          avatarUrl == other.avatarUrl &&
          icon == other.icon &&
          actionLabel == other.actionLabel &&
          actionStyle == other.actionStyle &&
          isRead == other.isRead &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        type,
        title,
        body,
        quote,
        timeAgo,
        avatarUrl,
        icon,
        actionLabel,
        actionStyle,
        isRead,
        createdAt,
      );
}
