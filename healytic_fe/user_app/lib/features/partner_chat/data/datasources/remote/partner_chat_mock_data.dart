import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_conversation.entity.dart';

/// Mock conversations for UI development.
const kMockPartnerConversations = <Map<String, dynamic>>[
  {
    'id': 'conv-001',
    'status': 'active',
    'otherParticipant': {
      'id': 'partner-001',
      'name': 'Mindful Wellness Spa',
      'avatar': null,
      'role': 'partner',
    },
    'lastMessage': {
      'text': 'Your appointment has been confirmed.',
      'timestamp': '2026-03-30T10:30:00.000Z',
      'senderId': 'partner-001',
    },
    'unreadCount': 2,
    'createdAt': '2026-03-28T09:00:00.000Z',
  },
  {
    'id': 'conv-002',
    'status': 'active',
    'otherParticipant': {
      'id': 'partner-002',
      'name': 'HealthFirst Clinic',
      'avatar': null,
      'role': 'partner',
    },
    'lastMessage': {
      'text': 'Thank you for choosing our service!',
      'timestamp': '2026-03-29T14:15:00.000Z',
      'senderId': 'partner-002',
    },
    'unreadCount': 0,
    'createdAt': '2026-03-25T11:00:00.000Z',
  },
];

/// Mock messages for conversation conv-001.
List<PartnerChatMessage> kMockMessages = [
  PartnerChatMessage(
    id: 'msg-001',
    conversationId: 'conv-001',
    senderId: 'partner-001',
    senderName: 'Mindful Wellness Spa',
    content:
        'Hello! Welcome to Mindful Wellness Spa. '
        'How can we help you today?',
    createdAt: DateTime(2026, 3, 28, 9, 5),
  ),
  PartnerChatMessage(
    id: 'msg-002',
    conversationId: 'conv-001',
    senderId: 'user-001',
    senderName: 'You',
    content:
        'Hi! I would like to know more about '
        'the Deep Tissue Massage service.',
    createdAt: DateTime(2026, 3, 28, 9, 7),
    isRead: true,
  ),
  PartnerChatMessage(
    id: 'msg-003',
    conversationId: 'conv-001',
    senderId: 'partner-001',
    senderName: 'Mindful Wellness Spa',
    content:
        'Our Deep Tissue Massage is a 60-minute '
        'session that targets chronic muscle tension. '
        'It is performed by certified therapists.',
    createdAt: DateTime(2026, 3, 28, 9, 10),
  ),
  PartnerChatMessage(
    id: 'msg-004',
    conversationId: 'conv-001',
    senderId: 'user-001',
    senderName: 'You',
    content: 'That sounds great! Can I book for this Saturday?',
    createdAt: DateTime(2026, 3, 28, 9, 12),
    isRead: true,
  ),
  PartnerChatMessage(
    id: 'msg-005',
    conversationId: 'conv-001',
    senderId: 'partner-001',
    senderName: 'Mindful Wellness Spa',
    content: 'Your appointment has been confirmed.',
    createdAt: DateTime(2026, 3, 30, 10, 30),
  ),
];

/// Helper to parse mock conversation data into entities.
PartnerConversation parseConversation(
  Map<String, dynamic> data,
) {
  final participant =
      data['otherParticipant'] as Map<String, dynamic>;
  final lastMsg =
      data['lastMessage'] as Map<String, dynamic>;

  return PartnerConversation(
    id: data['id'] as String,
    status: data['status'] as String,
    bookingId: data['bookingId'] as String?,
    otherParticipant: ParticipantInfo(
      id: participant['id'] as String,
      name: participant['name'] as String,
      avatar: participant['avatar'] as String?,
      role: participant['role'] as String,
    ),
    lastMessage: LastMessagePreview(
      text: lastMsg['text'] as String?,
      timestamp: lastMsg['timestamp'] != null
          ? DateTime.parse(
              lastMsg['timestamp'] as String,
            )
          : null,
      senderId: lastMsg['senderId'] as String?,
    ),
    unreadCount: data['unreadCount'] as int? ?? 0,
    createdAt: DateTime.parse(
      data['createdAt'] as String,
    ),
  );
}
