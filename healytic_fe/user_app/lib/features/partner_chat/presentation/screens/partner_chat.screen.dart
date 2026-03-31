import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';

import 'package:user_app/features/partner_chat/data/datasources/remote/partner_chat_socket_service.dart';
import 'package:user_app/features/partner_chat/presentation/providers/partner_chat.provider.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_header.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_input_bar.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_message_bubble.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_typing_indicator.widget.dart';

/// Full-screen chat screen for P2P conversations with
/// a health partner.
///
/// Composed of:
/// - [PartnerChatHeader] appBar (frosted glass)
/// - WS unavailable warning banner (when applicable)
/// - Message list (scrollable, chronological)
/// - Typing indicator when partner is typing
/// - [PartnerChatInputBar] sticky bottom
/// - Scroll-to-bottom FAB when scrolled up
class PartnerChatScreen extends HookConsumerWidget {
  final String partnerAccountId;
  final String partnerName;
  final String? partnerAvatar;

  const PartnerChatScreen({
    super.key,
    required this.partnerAccountId,
    required this.partnerName,
    this.partnerAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatState = ref.watch(
      partnerChatProvider(
        partnerAccountId,
        partnerName,
      ),
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

    // Auto-scroll on new messages.
    final prevCount = useRef(0);
    useEffect(() {
      final count = chatState.messages.length;
      if (count > prevCount.value &&
          scrollController.hasClients) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) {
          if (!scrollController.hasClients) return;
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
      return null;
    }, [chatState.messages]);

    // Resolve the current user ID from the provider.
    final currentUserId = ref
        .read(
          partnerChatProvider(
            partnerAccountId,
            partnerName,
          ).notifier,
        )
        .currentUserId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: PartnerChatHeader(
        partnerName: partnerName,
        partnerAvatar: partnerAvatar,
      ),
      body: Column(
        children: [
          // WS unavailable warning banner
          if (chatState.wsUnavailable)
            _WsUnavailableBanner(
              onRetry: () => ref
                  .read(
                    partnerChatProvider(
                      partnerAccountId,
                      partnerName,
                    ).notifier,
                  )
                  .retry(),
            ),

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
              currentUserId,
            ),
          ),

          // Typing indicator
          if (chatState.partnerIsTyping)
            Padding(
              padding: EdgeInsets.only(
                top: AppDimens.spaceXs,
                bottom: AppDimens.spaceXs,
              ),
              child: PartnerChatTypingIndicator(
                partnerName:
                    chatState.typingPartnerName ??
                        partnerName,
              ),
            ),

          // Input bar — disabled when WS unavailable
          PartnerChatInputBar(
            enabled: !chatState.wsUnavailable,
            onSend: (text) => ref
                .read(
                  partnerChatProvider(
                    partnerAccountId,
                    partnerName,
                  ).notifier,
                )
                .sendMessage(text),
            onTypingChanged: (isTyping) {
              final notifier = ref.read(
                partnerChatProvider(
                  partnerAccountId,
                  partnerName,
                ).notifier,
              );
              if (isTyping) {
                notifier.notifyTyping();
              } else {
                notifier.notifyStopTyping();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageArea(
    BuildContext context,
    WidgetRef ref,
    PartnerChatState chatState,
    ColorScheme colorScheme,
    double hPadding,
    ScrollController scrollController,
    bool showFab,
    String currentUserId,
  ) {
    // Connecting state
    if (chatState.connectionStatus ==
        ChatConnectionStatus.connecting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (chatState.connectionStatus ==
        ChatConnectionStatus.error) {
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
                chatState.error ??
                    'Connection failed.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppDimens.spaceMd,
              ),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(
                      partnerChatProvider(
                        partnerAccountId,
                        partnerName,
                      ).notifier,
                    )
                    .retry(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Loading messages
    if (chatState.isLoadingMessages &&
        chatState.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Empty state
    if (chatState.messages.isEmpty) {
      return _buildEmptyState(
        context,
        colorScheme,
      );
    }

    // Messages list
    final messages = chatState.messages;

    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: AppDimens.spaceMd,
          ),
          itemCount: messages.length + 1,
          itemBuilder: (context, index) {
            // Date header
            if (index == 0) {
              final firstDate =
                  messages.first.createdAt;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppDimens.spaceMd,
                ),
                child: _DateDivider(
                  date: firstDate,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: AppDimens.spaceSm,
              ),
              child: PartnerChatMessageBubble(
                key: ValueKey(
                  messages[index - 1].id,
                ),
                message: messages[index - 1],
                currentUserId: currentUserId,
              ),
            );
          },
        ),

        // Scroll-to-bottom FAB
        if (showFab)
          Positioned(
            right: hPadding,
            bottom: AppDimens.spaceSm,
            child: Material(
              color: colorScheme.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                onTap: () =>
                    scrollController.animateTo(
                  scrollController
                      .position.maxScrollExtent,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeOutCubic,
                ),
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(
                    AppDimens.spaceSm,
                  ),
                  child: Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                    color: colorScheme.onPrimary,
                    size: AppDimens.iconLg,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          AppDimens.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: colorScheme.primary
                    .withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: AppDimens.spaceMd),
            Text(
              'Start a conversation',
              style:
                  textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppDimens.spaceXs),
            Text(
              'Send a message to $partnerName to '
              'start chatting about your health '
              'services.',
              style:
                  textTheme.bodyMedium?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Warning banner shown when the WebSocket connection
/// is unavailable — real-time features (send, typing)
/// are disabled while the message history is still
/// displayed.
class _WsUnavailableBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const _WsUnavailableBanner({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.horizontalPadding(
          context,
        ),
        vertical: AppDimens.spaceXs,
      ),
      color: colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: colorScheme.onErrorContainer,
          ),
          SizedBox(width: AppDimens.spaceXs),
          Expanded(
            child: Text(
              'Real-time chat is unavailable. '
              'You can view message history but '
              'sending is disabled.',
              style: textTheme.labelSmall?.copyWith(
                color:
                    colorScheme.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: AppDimens.spaceXs),
          InkWell(
            onTap: onRetry,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.all(
                AppDimens.spaceXxs,
              ),
              child: Text(
                'Retry',
                style:
                    textTheme.labelSmall?.copyWith(
                  color:
                      colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                  decoration:
                      TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date divider displayed above messages.
class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final label = isToday
        ? 'Today'
        : DateFormat.yMMMd().format(date);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceXxs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
