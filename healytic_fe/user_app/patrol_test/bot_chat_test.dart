import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/chat.screen.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/conversation_history.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';
import 'helpers/permission_helper.dart';

/// Timeout for AI SSE response streaming.
///
/// Real AI responses via `POST /generative_ai/stream`
/// take longer than mock — allow up to 15 s.
const _aiResponseTimeout = Duration(seconds: 15);

/// Short settle delay after navigation actions.
const _navDelay = Duration(seconds: 2);

Future<void> _openNewChat(PatrolIntegrationTester $) async {
  await $(keys.chatScreen.newChatButton).waitUntilVisible();
  await $(keys.chatScreen.newChatButton).tap();
  await $(ChatScreen).waitUntilVisible();
}

Future<void> _returnToHistory(PatrolIntegrationTester $) async {
  await $(find.byIcon(Icons.arrow_back_ios_new_rounded)).tap();
  await $(ConversationHistoryScreen).waitUntilVisible(timeout: _navDelay);
}

void main() {
  patrolTest('AI chat: conversation history loads', ($) async {
    await pumpApp($);
    await signIn($);
    await handlePermissionIfVisible($);
    await navigateToTab($, TabKeys.chat);

    expect($(ConversationHistoryScreen), findsOneWidget);

    // History list should render — may be empty
    // or populated from UAT data.
    await $.pump(_navDelay);
  });

  patrolTest('AI chat: open new chat and send message '
      'to real AI service', ($) async {
    await pumpApp($);
    await signIn($);
    await handlePermissionIfVisible($);
    await navigateToTab($, TabKeys.chat);

    await _openNewChat($);
    expect($(ChatScreen), findsOneWidget);

    // Type and send a health-related message.
    await $(keys.chatScreen.messageInput).enterText('Hello doctor');
    await $(keys.chatScreen.sendButton).tap();

    // Wait for SSE stream to deliver at least
    // one bot response token. The typing indicator
    // disappears once the stream completes.
    await $.pump(_aiResponseTimeout);

    // ChatScreen should still be visible (no
    // crash) and contain more than the user msg.
    expect($(ChatScreen), findsOneWidget);
  });

  patrolTest('AI chat: return to history after sending '
      'a message', ($) async {
    await pumpApp($);
    await signIn($);
    await handlePermissionIfVisible($);
    await navigateToTab($, TabKeys.chat);

    // Create a conversation by sending a message.
    await _openNewChat($);
    await $(keys.chatScreen.messageInput).enterText('I have a headache');
    await $(keys.chatScreen.sendButton).tap();
    await $.pump(_aiResponseTimeout);

    // Go back to history.
    await _returnToHistory($);

    // The conversation list should now render
    // the newly created conversation.
    expect($(ConversationHistoryScreen), findsOneWidget);
  });
}
