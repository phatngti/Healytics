import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_conversation.entity.freezed.dart';

/// Represents a past chatbot conversation session
/// displayed on the conversation history page.
///
/// Each session shows a [title], a [lastMessage]
/// preview, and a [timestamp]. Visual identity is
/// provided by either an [avatarUrl] (network image)
/// or an [iconName] string mapped to an icon in the
/// presentation layer.
@freezed
sealed class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    /// Unique identifier for this conversation session.
    required String id,

    /// Short title summarising the conversation topic.
    required String title,

    /// Preview text from the most recent message.
    required String lastMessage,

    /// Timestamp of the last activity in this
    /// conversation.
    required DateTime timestamp,

    /// Optional network avatar image URL.
    String? avatarUrl,

    /// Fallback icon name when [avatarUrl] is absent.
    /// Mapped to a Material icon in the presentation
    /// layer (e.g. `'smart_toy'`, `'fitness_center'`).
    String? iconName,
  }) = _ChatConversation;
}
