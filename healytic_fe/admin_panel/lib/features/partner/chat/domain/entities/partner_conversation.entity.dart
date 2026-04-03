import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_conversation.entity.freezed.dart';

/// Participant info in a conversation.
@freezed
sealed class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    required String id,
    required String name,
    String? avatar,
    required String role,
  }) = _ParticipantInfo;
}

/// Preview of the last message.
@freezed
sealed class LastMessagePreview with _$LastMessagePreview {
  const factory LastMessagePreview({
    String? text,
    DateTime? timestamp,
    String? senderId,
  }) = _LastMessagePreview;
}

/// Conversation entity for the partner's inbox.
@freezed
sealed class PartnerConversation
    with _$PartnerConversation {
  const factory PartnerConversation({
    required String id,
    required String status,
    String? bookingId,
    required ParticipantInfo otherParticipant,
    required LastMessagePreview lastMessage,
    @Default(0) int unreadCount,
    required DateTime createdAt,
  }) = _PartnerConversation;
}
