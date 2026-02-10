import 'package:flutter/material.dart';

import 'package:user_app/features/bot_chat/domain/entities/chat_conversation.entity.dart';
import 'package:user_app/features/bot_chat/domain/entities/chat_message.entity.dart';

// ─────────────────────────────────────────────────────────────────
// Mock Conversations
// ─────────────────────────────────────────────────────────────────

/// Mock conversation sessions for development and testing.
final List<ChatConversation> kMockConversations = [
  // Today
  ChatConversation(
    id: '1',
    title: 'Mild headache and dizziness',
    lastMessage: 'Recommended hydration and rest...',
    timestamp: DateTime(2026, 2, 10, 14, 0),
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuCVWTg_SV4Js4JCVC5o9uSbD0aWlqcW8iznU-KktZyGaCsEFm'
        'vfXEMw83VMH_L_Yh841XMLGVq5N-eH-BW2mojEp3PhR_KxEXSg45Rd'
        'AsCj9L7_UZdy-EaPtY6lFdiZD3OHTxPw6tX9EA_qFqf_i083ACGWSjl'
        'ruw_UIkV2ISbXOajbg0aktF1y7sThG7mKLN2IGuPdbPdZS0cBtn_FGb'
        'ot44D9gWpQBy8hgmCgWPWM5k9c5myQ75EeqTjIcj-VeUzsUfggLHjE'
        'milU',
  ),
  ChatConversation(
    id: '2',
    title: 'Blood test results interpretation',
    lastMessage: 'Analyzing lipid profile markers...',
    timestamp: DateTime(2026, 2, 10, 11, 30),
    icon: Icons.smart_toy,
  ),

  // Yesterday
  ChatConversation(
    id: '3',
    title: 'Sore throat remedies',
    lastMessage: 'Discussed tea with honey and...',
    timestamp: DateTime(2026, 2, 9, 16, 45),
    avatarUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuDBkb7ganb3_j-ePQKtR9MOUEDPMnC55RW8_hAOGREmpPXeDS'
        'GAV9ekyvCLbbXiMb-IqL7q2zCM7f1LnfHsvZwOJk0hZdoYpu22xb0m'
        'GwJTg9JDiZW9Nx7TO_y3-N_Yn2k0UgTnw7b8db0AHkaUpPsmLTaPgm'
        '2M11EULbE12NwLjuA50-T8SrkwDxUnyjb-eSAHBytVXdncNjWknpXnk'
        '4mCpsICj8zz5jZ1QM2lgKL_uSilmc8iqjWpUHMjTvxHdBWG8ACRnO5'
        'XGVXD',
  ),
  ChatConversation(
    id: '4',
    title: 'Weekly workout plan',
    lastMessage: 'Generated low impact cardio routine...',
    timestamp: DateTime(2026, 2, 9, 9, 15),
    icon: Icons.fitness_center,
  ),

  // Last Week
  ChatConversation(
    id: '5',
    title: 'Medication reminder setup',
    lastMessage: 'Configured daily alerts for vitamins...',
    timestamp: DateTime(2026, 2, 3, 10, 0),
    icon: Icons.medical_services,
  ),
];

// ─────────────────────────────────────────────────────────────────
// Mock Messages
// ─────────────────────────────────────────────────────────────────

/// Mock messages for the default conversation (id: '1').
final List<ChatMessage> kMockMessages = [
  ChatMessage(
    id: '1',
    text:
        'Hello! 👋 I\'m your personal health assistant. '
        'I can help verify symptoms or guide you to the right '
        'specialist. How are you feeling today?',
    timestamp: DateTime(2026, 2, 10, 9, 41),
  ),
  ChatMessage(
    id: '2',
    text:
        'Hi Dr. AI. I\'ve had a mild headache since this morning '
        'and I\'m feeling a bit dizzy.',
    timestamp: DateTime(2026, 2, 10, 9, 42),
    isUser: true,
    isRead: true,
  ),
  ChatMessage(
    id: '3',
    text:
        'I\'m sorry to hear that. To help me understand better, '
        'on a scale of 1 to 10, how severe would you say the '
        'pain is right now?',
    timestamp: DateTime(2026, 2, 10, 9, 42),
  ),
];
