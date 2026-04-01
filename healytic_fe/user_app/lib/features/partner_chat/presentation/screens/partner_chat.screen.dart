import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';

import 'package:user_app/core/services/ws/ws_client.dart';
import 'package:user_app/features/partner_chat/domain/entities/partner_chat_message.entity.dart';
import 'package:user_app/features/partner_chat/presentation/providers/partner_chat.provider.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_header.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_input_bar.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_message_bubble.widget.dart';
import 'package:user_app/features/partner_chat/presentation/widgets/partner_chat_typing_indicator.widget.dart';
import 'package:user_app/hooks/use_chat_scroll.dart';

/// Full-screen chat screen for P2P conversations with
/// a health partner.
///
/// Uses a **reverse `ListView`** so the newest message
/// sits at scroll offset 0 — auto-scroll to bottom is
/// the natural default and requires no manual heuristic.
///
/// Composed of:
/// - [PartnerChatHeader] appBar (frosted glass)
/// - WS unavailable warning banner (when applicable)
/// - Message list (reversed, newest at bottom)
/// - "Load older" spinner at top edge
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
    final colorScheme =
        Theme.of(context).colorScheme;
    final chatState = ref.watch(
      partnerChatProvider(
        partnerAccountId,
        partnerName,
      ),
    );
    final hPadding =
        AppDimens.horizontalPadding(context);

    // Shared hook — reverse-aware scroll + FAB.
    final chat = useChatScroll();

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
              chat,
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
    ChatScrollState chat,
    String currentUserId,
  ) {
    // Connecting state
    if (chatState.connectionStatus ==
        WsConnectionStatus.connecting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (chatState.connectionStatus ==
        WsConnectionStatus.error) {
      return _buildErrorState(
        context,
        ref,
        chatState,
        colorScheme,
        hPadding,
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

    // Messages list — reversed so newest = index 0.
    final messages = chatState.messages;

    // Extra item count for load-more spinner and
    // date header at the oldest edge.
    final hasLoadMore = chatState.hasMoreMessages;
    // +1 for date header, +1 for load-more spinner
    final extraTop = 1 + (hasLoadMore ? 1 : 0);
    final itemCount = messages.length + extraTop;

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            _onScrollNotification(
              notification,
              ref,
              chatState,
            );
            return false;
          },
          child: ListView.builder(
            controller: chat.controller,
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: hPadding,
              vertical: AppDimens.spaceMd,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return _buildReversedItem(
                index,
                messages,
                extraTop,
                hasLoadMore,
                chatState,
                currentUserId,
              );
            },
          ),
        ),

        // Scroll-to-bottom FAB
        if (chat.showFab)
          Positioned(
            right: hPadding,
            bottom: AppDimens.spaceSm,
            child: _ScrollToBottomFab(
              onTap: chat.scrollToBottom,
            ),
          ),
      ],
    );
  }

  /// Maps a reversed-list [index] to the correct
  /// widget: message bubble, date header, or
  /// load-more spinner.
  ///
  /// In a reversed `ListView`:
  /// - index 0 = newest message (last in list)
  /// - index (messages.length - 1) = oldest message
  /// - index messages.length = date header
  /// - index messages.length + 1 = load-more spinner
  Widget _buildReversedItem(
    int index,
    List<PartnerChatMessage> messages,
    int extraTop,
    bool hasLoadMore,
    PartnerChatState chatState,
    String currentUserId,
  ) {
    // Load-more spinner (oldest edge of the list)
    if (hasLoadMore &&
        index == messages.length + extraTop - 1) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.spaceMd,
        ),
        child: Center(
          child: chatState.isLoadingMessages
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );
    }

    // Date header (above oldest visible message)
    if (index == messages.length + extraTop - 1 -
            (hasLoadMore ? 1 : 0)) {
      final oldestDate =
          messages.first.createdAt;
      return Padding(
        padding: EdgeInsets.only(
          bottom: AppDimens.spaceMd,
        ),
        child: _DateDivider(date: oldestDate),
      );
    }

    // Message bubble — reversed index mapping
    final msgIndex =
        messages.length - 1 - index;
    final message = messages[msgIndex];

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.spaceSm,
      ),
      child: PartnerChatMessageBubble(
        key: ValueKey(message.id),
        message: message,
        currentUserId: currentUserId,
      ),
    );
  }

  /// Triggers [loadMoreMessages] when the user scrolls
  /// near the top edge (oldest messages) of the
  /// reversed list.
  void _onScrollNotification(
    ScrollNotification notification,
    WidgetRef ref,
    PartnerChatState chatState,
  ) {
    if (notification is! ScrollUpdateNotification) {
      return;
    }

    final metrics = notification.metrics;
    // In a reversed list, maxScrollExtent
    // corresponds to the oldest messages.
    final nearEdge = metrics.pixels >=
        metrics.maxScrollExtent - 200;

    if (nearEdge &&
        chatState.hasMoreMessages &&
        !chatState.isLoadingMessages) {
      ref
          .read(
            partnerChatProvider(
              partnerAccountId,
              partnerName,
            ).notifier,
          )
          .loadMoreMessages();
    }
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    PartnerChatState chatState,
    ColorScheme colorScheme,
    double hPadding,
  ) {
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
                Icons
                    .chat_bubble_outline_rounded,
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
              'Send a message to $partnerName '
              'to start chatting about your '
              'health services.',
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

/// Scroll-to-bottom FAB for the partner chat.
class _ScrollToBottomFab extends StatelessWidget {
  final VoidCallback onTap;

  const _ScrollToBottomFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.primary,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(
            AppDimens.spaceSm,
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onPrimary,
            size: AppDimens.iconLg,
          ),
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
    final colorScheme =
        Theme.of(context).colorScheme;
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
              style:
                  textTheme.labelSmall?.copyWith(
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
            borderRadius:
                BorderRadius.circular(4),
            child: Padding(
              padding: EdgeInsets.all(
                AppDimens.spaceXxs,
              ),
              child: Text(
                'Retry',
                style: textTheme.labelSmall
                    ?.copyWith(
                  color: colorScheme
                      .onErrorContainer,
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
    final colorScheme =
        Theme.of(context).colorScheme;
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
          color: colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color:
                colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
