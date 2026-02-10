import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';

import '../providers/chat.provider.dart';
import '../widgets/chat/chat_header.widget.dart';
import '../widgets/chat/chat_input_bar.widget.dart';
import '../widgets/chat/chat_message_bubble.widget.dart';
import '../widgets/chat/chat_suggestion_chips.widget.dart';
import '../widgets/chat/chat_timestamp.widget.dart';

/// The main chatbot screen that composes all chat sub-widgets.
///
/// Structure:
/// - [ChatHeader] as appBar
/// - Body: [Stack] with a [ListView] of messages and a bottom-
///   pinned overlay containing [ChatSuggestionChips] and
///   [ChatInputBar].
///
/// All dimensions use [AppDimens] responsive helpers and
/// [MediaQuery] text-scale clamping per the design system rules.
class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatState = ref.watch(chatProvider);
    final hPadding = AppDimens.horizontalPadding(context);

    // Bottom overlay occupies ~160–180 dp; use adaptive value.
    final bottomOverlaySpace = AppDimens.adaptive(
      context,
      small: 160,
      medium: 170,
      large: 180,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const ChatHeader(),
      body: MediaQuery(
        // Clamp text scale to prevent layout breaks on extreme
        // system font sizes (0.8× – 1.3×).
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(
            context,
          ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
        ),
        child: _buildBody(
          context,
          chatState,
          colorScheme,
          hPadding,
          bottomOverlaySpace,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ChatState chatState,
    ColorScheme colorScheme,
    double hPadding,
    double bottomOverlaySpace,
  ) {
    if (chatState.isLoading && chatState.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatState.error != null && chatState.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(hPadding),
          child: Text(
            chatState.error!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final messages = chatState.messages;

    return Stack(
      children: [
        // ── Message list ──────────────────────────────────
        ListView.separated(
          padding: EdgeInsets.only(
            left: hPadding,
            right: hPadding,
            top: AppDimens.spaceLg,
            // Extra space so content doesn't hide behind
            // the bottom overlay.
            bottom: bottomOverlaySpace,
          ),
          itemCount: messages.length + 1, // +1 for timestamp
          separatorBuilder: (_, __) => SizedBox(height: AppDimens.spaceXl),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const ChatTimestamp(label: 'Today, 9:41 AM');
            }
            return ChatMessageBubble(message: messages[index - 1]);
          },
        ),

        // ── Bottom overlay ────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomOverlay(colorScheme: colorScheme),
        ),
      ],
    );
  }
}

/// Sticky bottom section containing suggestion chips, input bar,
/// and a gradient fade at the top so messages fade smoothly.
class _BottomOverlay extends StatelessWidget {
  final ColorScheme colorScheme;
  const _BottomOverlay({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.25, 1.0],
          colors: [
            colorScheme.surface.withValues(alpha: 0.0),
            colorScheme.surface.withValues(alpha: 0.95),
            colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: AppDimens.spaceSm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDimens.verticalMedium,
              const ChatSuggestionChips(),
              AppDimens.verticalMediumSmall,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.horizontalPadding(context),
                ),
                child: const ChatInputBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
