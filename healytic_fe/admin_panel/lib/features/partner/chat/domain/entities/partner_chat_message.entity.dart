import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_chat_message.entity.freezed.dart';

/// Types of messages in a partner chat conversation.
enum PartnerMessageType {
  /// Plain text message.
  text,

  /// System-generated message.
  system,
}

/// Represents a single message in a P2P partner chat
/// conversation.
@freezed
sealed class PartnerChatMessage with _$PartnerChatMessage {
  const factory PartnerChatMessage({
    required String id,
    required String conversationId,
    required String senderId,
    String? senderName,
    String? senderAvatar,
    required String content,
    @Default(PartnerMessageType.text) PartnerMessageType messageType,
    String? clientMessageId,
    required DateTime createdAt,
    @Default(false) bool isRead,
  }) = _PartnerChatMessage;
}
