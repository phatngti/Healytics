/// Represents a single message in the chatbot conversation.
///
/// [isUser] distinguishes between user-sent and AI-generated messages.
/// [isRead] is only relevant for user messages (double-check icon).
class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isUser;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isUser = false,
    this.isRead = false,
  });
}
