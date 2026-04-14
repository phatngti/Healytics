import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';

import '../providers/chat.provider.dart';
import '../widgets/chat/chat_empty_state.widget.dart';
import '../widgets/chat/chat_header.widget.dart';
import '../widgets/chat/chat_input_bar.widget.dart';
import '../widgets/chat/chat_message_bubble.widget.dart';
import '../widgets/chat/chat_scroll_to_bottom_fab.widget.dart';
import '../widgets/chat/chat_suggestion_chips.widget.dart';
import '../widgets/chat/chat_timestamp.widget.dart';
import '../widgets/chat/chat_typing_indicator.widget.dart';

/// Telegram-style chatbot screen.
///
/// Composed of:
/// - [ChatHeader] appBar (frosted glass)
/// - Message list (scrollable)
/// - Sticky bottom with suggestion chips + input bar
/// - Scroll-to-bottom FAB when scrolled up
/// - Empty state when no messages exist
/// - Typing indicator while bot is responding
class ChatScreen extends HookConsumerWidget {
  final String? conversationId;
  const ChatScreen({super.key, this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final chatState = ref.watch(
      chatProvider(conversationId),
    );
    final hPadding =
        AppDimens.horizontalPadding(context);

    final scrollController = useScrollController();
    final showFab = useState(false);

    // Toggle FAB visibility on scroll.
    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) return;
        final pos = scrollController.position;
        showFab.value =
            pos.pixels < pos.maxScrollExtent - 80;
      }

      scrollController.addListener(listener);
      return () =>
          scrollController.removeListener(listener);
    }, [scrollController]);

    // Auto-scroll on new messages or streaming
    // updates.
    final prevCount = useRef(0);
    final prevLastText = useRef('');
    useEffect(() {
      final count = chatState.messages.length;
      final lastText = count > 0
          ? chatState.messages.last.text
          : '';
      final shouldScroll = count > prevCount.value ||
          lastText != prevLastText.value;

      if (shouldScroll &&
          scrollController.hasClients) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) {
              if (!scrollController.hasClients) {
                return;
              }
              scrollController.animateTo(
                scrollController
                    .position.maxScrollExtent,
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.easeOutCubic,
              );
            });
      }
      prevCount.value = count;
      prevLastText.value = lastText;
      return null;
    }, [chatState.messages]);

    return Scaffold(
      appBar: const ChatHeader(),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: MediaQuery.of(context)
              .textScaler
              .clamp(
                minScaleFactor: 0.8,
                maxScaleFactor: 1.3,
              ),
        ),
        child: Column(
          children: [
            // Messages area
            Expanded(
              child: _buildMessageArea(
                context,
                ref,
                chatState,
                colorScheme,
                hPadding,
                scrollController,
                showFab.value,
              ),
            ),

            // Suggestion chips
            if (chatState.messages.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: AppDimens.spaceXs,
                ),
                child:
                    const ChatSuggestionChips(),
              ),

            // Input bar
            ChatInputBar(
              onSend: (text) => ref
                  .read(
                    chatProvider(conversationId)
                        .notifier,
                  )
                  .sendMessage(text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageArea(
    BuildContext context,
    WidgetRef ref,
    ChatState chatState,
    ColorScheme colorScheme,
    double hPadding,
    ScrollController scrollController,
    bool showFab,
  ) {
    // Loading state
    if (chatState.isLoading &&
        chatState.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (chatState.error != null &&
        chatState.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(hPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.error
                    .withValues(alpha: 0.6),
              ),
              SizedBox(
                height: AppDimens.spaceMd,
              ),
              Text(
                chatState.error!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (chatState.messages.isEmpty) {
      return ChatEmptyState(
        onSend: (text) => ref
            .read(
              chatProvider(conversationId).notifier,
            )
            .sendMessage(text),
      );
    }

    // Messages list
    final messages = chatState.messages;
    final itemCount = messages.length +
        1 +
        (chatState.isLoading ? 1 : 0);

    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: AppDimens.spaceMd,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppDimens.spaceMd,
                ),
                child: const ChatTimestamp(
                  label: 'Today, 9:41 AM',
                ),
              );
            }
            if (chatState.isLoading &&
                index == messages.length + 1) {
              return Padding(
                padding: EdgeInsets.only(
                  top: AppDimens.spaceSm,
                ),
                child:
                    const ChatTypingIndicator(),
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: AppDimens.spaceSm,
              ),
              child: ChatMessageBubble(
                key: ValueKey(
                  messages[index - 1].id,
                ),
                message: messages[index - 1],
              ),
            );
          },
        ),

        // Scroll-to-bottom FAB
        if (showFab)
          Positioned(
            right: hPadding,
            bottom: AppDimens.spaceSm,
            child: ChatScrollToBottomFab(
              onTap: () =>
                  scrollController.animateTo(
                    scrollController
                        .position.maxScrollExtent,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
      ],
    );
  }
}
