import 'package:flutter/widgets.dart';

/// Represents a past chatbot conversation session displayed on
/// the conversation history page.
///
/// Each session shows a [title], a [lastMessage] preview, and a
/// [timestamp]. Visual identity is provided by either an
/// [avatarUrl] (network image) or an [icon] fallback.
class ChatConversation {
  /// Unique identifier for this conversation session.
  final String id;

  /// Short title summarising the conversation topic.
  final String title;

  /// Preview text from the most recent message.
  final String lastMessage;

  /// Timestamp of the last activity in this conversation.
  final DateTime timestamp;

  /// Optional network avatar image URL.
  final String? avatarUrl;

  /// Fallback Material icon when [avatarUrl] is absent.
  final IconData? icon;

  const ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.icon,
  });
}
