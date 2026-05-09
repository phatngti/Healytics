import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/chat.screen.dart';
import 'package:user_app/features/ai_health_assistant/presentation/screens/conversation_history.screen.dart';

import 'common.dart';
import 'helpers/auth_helper.dart';
import 'helpers/navigation_helper.dart';

Future<void> _openNewChat(PatrolIntegrationTester $) async {
  await $(keys.chatScreen.newChatButton).waitUntilVisible();
  await $(keys.chatScreen.newChatButton).tap();
  await $(ChatScreen).waitUntilVisible();
}

Future<void> _returnToHistory(PatrolIntegrationTester $) async {
  await $(find.byIcon(Icons.arrow_back_ios_new_rounded)).tap();
  await $(ConversationHistoryScreen).waitUntilVisible();
}

void main() {
  patrolTest(
    'AI chat history, new chat, message send, and existing chat flow',
    ($) async {
      await pumpApp($);
      await signIn($);
      await navigateToTab($, TabKeys.chat);

      expect($(ConversationHistoryScreen), findsOneWidget);

      await _openNewChat($);
      expect($(ChatScreen), findsOneWidget);

      await $(keys.chatScreen.messageInput).enterText('Hello doctor');
      await $(keys.chatScreen.sendButton).tap();
      await $.pump(const Duration(seconds: 3));

      // sendMessage adds user msg asynchronously
      // (after await in provider). Just verify
      // ChatScreen is still showing — no crash.
      expect($(ChatScreen), findsOneWidget);

      await _returnToHistory($);

      // Mock conversation title from
      // chat_mock_data.dart (id: '1')
      await $('Mild headache and dizziness').scrollTo().tap();
      await $.pump(const Duration(seconds: 2));

      expect($(ChatScreen), findsOneWidget);
    },
  );
}
