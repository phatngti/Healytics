/// Types of messages displayed in the chat UI.
///
/// Each SSE segment (text, service recommendation,
/// NER location) maps to a distinct type so the bubble
/// widget can render the appropriate layout.
enum ChatMessageType {
  /// Plain text message (user or bot).
  text,

  /// Service recommendation card(s).
  serviceRecommendation,

  /// Extracted location entities.
  nerLocation,
}

/// Represents a single message in the chatbot conversation.
///
/// [isUser] distinguishes between user-sent and
/// AI-generated messages.
/// [messageType] controls which bubble layout is used.
/// [metadata] carries rich payload data for non-text types
/// (e.g. service list, location entities).
class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isUser;
  final bool isRead;
  final ChatMessageType messageType;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    this.isUser = false,
    this.isRead = false,
    this.messageType = ChatMessageType.text,
    this.metadata,
  });

  @override
  String toString() {
    return 'ChatMessage{id: $id, text: $text, timestamp: $timestamp, isUser: $isUser, isRead: $isRead, messageType: $messageType, metadata: $metadata}';
  }
}
