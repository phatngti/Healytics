import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';

/// Mock conversations for the partner inbox.
final kMockInboxConversations = <PartnerConversation>[
  PartnerConversation(
    id: 'conv-001',
    status: 'active',
    otherParticipant: ParticipantInfo(
      id: 'user-001',
      name: 'John Doe',
      role: 'user',
    ),
    lastMessage: LastMessagePreview(
      text: 'Can I book for this Saturday?',
      timestamp: DateTime(2026, 3, 30, 10, 30),
      senderId: 'user-001',
    ),
    unreadCount: 3,
    createdAt: DateTime(2026, 3, 28, 9, 0),
  ),
  PartnerConversation(
    id: 'conv-002',
    status: 'active',
    otherParticipant: ParticipantInfo(
      id: 'user-002',
      name: 'Jane Smith',
      role: 'user',
    ),
    lastMessage: LastMessagePreview(
      text: 'Thank you for the great service!',
      timestamp: DateTime(2026, 3, 29, 14, 15),
      senderId: 'user-002',
    ),
    unreadCount: 0,
    createdAt: DateTime(2026, 3, 25, 11, 0),
  ),
  PartnerConversation(
    id: 'conv-003',
    status: 'active',
    otherParticipant: ParticipantInfo(
      id: 'user-003',
      name: 'Alice Nguyen',
      role: 'user',
    ),
    lastMessage: LastMessagePreview(
      text: 'What time does my appointment start?',
      timestamp: DateTime(2026, 3, 28, 16, 45),
      senderId: 'user-003',
    ),
    unreadCount: 1,
    createdAt: DateTime(2026, 3, 26, 8, 30),
  ),
];

/// Mock messages for conversation conv-001.
final kMockInboxMessages = <PartnerChatMessage>[
  PartnerChatMessage(
    id: 'msg-001',
    conversationId: 'conv-001',
    senderId: 'user-001',
    senderName: 'John Doe',
    content:
        'Hello! I am interested in the Deep Tissue '
        'Massage. Can you tell me more?',
    createdAt: DateTime(2026, 3, 28, 9, 5),
  ),
  PartnerChatMessage(
    id: 'msg-002',
    conversationId: 'conv-001',
    senderId: 'partner-001',
    senderName: 'You',
    content:
        'Hi John! Our Deep Tissue Massage is a '
        '60-minute session that targets chronic '
        'muscle tension. It costs \$120.',
    createdAt: DateTime(2026, 3, 28, 9, 10),
    isRead: true,
  ),
  PartnerChatMessage(
    id: 'msg-003',
    conversationId: 'conv-001',
    senderId: 'user-001',
    senderName: 'John Doe',
    content:
        'That sounds perfect! Is there availability '
        'this Saturday afternoon?',
    createdAt: DateTime(2026, 3, 28, 9, 12),
  ),
  PartnerChatMessage(
    id: 'msg-004',
    conversationId: 'conv-001',
    senderId: 'partner-001',
    senderName: 'You',
    content:
        'Yes, we have slots available at 2:00 PM '
        'and 4:00 PM. Which would you prefer?',
    createdAt: DateTime(2026, 3, 28, 9, 15),
    isRead: true,
  ),
  PartnerChatMessage(
    id: 'msg-005',
    conversationId: 'conv-001',
    senderId: 'user-001',
    senderName: 'John Doe',
    content: 'Can I book for this Saturday?',
    createdAt: DateTime(2026, 3, 30, 10, 30),
  ),
];
