import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.entity.freezed.dart';

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

/// Represents a single message in the chatbot
/// conversation.
///
/// [isUser] distinguishes between user-sent and
/// AI-generated messages.
/// [messageType] controls which bubble layout is used.
/// [metadata] carries rich payload data for non-text
/// types (e.g. service list, location entities).
@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required DateTime timestamp,
    @Default(false) bool isUser,
    @Default(false) bool isRead,
    @Default(ChatMessageType.text)
    ChatMessageType messageType,
    Map<String, dynamic>? metadata,
  }) = _ChatMessage;
}
