import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'package:admin_panel/features/partner/chat/domain/entities/partner_chat_message.entity.dart';
import 'package:admin_panel/features/partner/chat/domain/entities/partner_conversation.entity.dart';
import 'package:admin_panel/features/partner/chat/presentation/providers/partner_inbox.provider.dart';

enum _OutgoingMessageStatus { sending, sent }

/// Desktop-first split-pane chat inbox for health
/// partners.
///
/// Layout:
/// ┌─────────────────┬──────────────────────────┐
/// │ Conversation     │  Active Conversation     │
/// │ List (320px)     │  Messages                │
/// └─────────────────┴──────────────────────────┘
class PartnerChatInboxScreen extends HookConsumerWidget {
  const PartnerChatInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final inboxState =
        ref.watch(partnerInboxProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          // ── Left: Conversation List ────────
          SizedBox(
            width: 360,
            child: _ConversationListPanel(
              conversations:
                  inboxState.conversations,
              isLoading: inboxState.isLoading,
              error: inboxState.error,
              activeId:
                  inboxState.activeConversationId,
              onSelect: (id) => ref
                  .read(partnerInboxProvider.notifier)
                  .selectConversation(id),
              onRefresh: () => ref
                  .read(partnerInboxProvider.notifier)
                  .refresh(),
            ),
          ),

          // ── Divider ───────────────────────
          VerticalDivider(
            width: 1,
            color: colorScheme.outlineVariant
                .withValues(alpha: 0.3),
          ),

          // ── Right: Chat Detail ────────────
          Expanded(
            child: inboxState.activeConversationId !=
                    null
                ? _ChatDetailPanel(
                    key: ValueKey(
                      inboxState
                          .activeConversationId,
                    ),
                    conversationId: inboxState
                        .activeConversationId!,
                    conversation: inboxState
                        .conversations
                        .where((c) =>
                            c.id ==
                            inboxState
                                .activeConversationId)
                        .firstOrNull,
                  )
                : const _EmptyPanel(),
          ),
        ],
      ),
    );
  }
}

// ─── Conversation List Panel ─────────────────────────

class _ConversationListPanel extends StatelessWidget {
  final List<PartnerConversation> conversations;
  final bool isLoading;
  final String? error;
  final String? activeId;
  final ValueChanged<String> onSelect;
  final VoidCallback onRefresh;

  const _ConversationListPanel({
    required this.conversations,
    required this.isLoading,
    this.error,
    this.activeId,
    required this.onSelect,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.chat_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Messages',
                style:
                    textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh_rounded,
                  color:
                      colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              hintStyle:
                  textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant
                      .withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant
                      .withValues(alpha: 0.3),
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              isDense: true,
            ),
          ),
        ),

        // List
        Expanded(
          child: isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : error != null
                  ? Center(
                      child: Text(
                        error!,
                        style: textTheme.bodyMedium
                            ?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    )
                  : conversations.isEmpty
                      ? Center(
                          child: Text(
                            'No conversations yet',
                            style: textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              conversations.length,
                          itemBuilder:
                              (context, index) {
                            final conv =
                                conversations[index];
                            final isActive =
                                conv.id == activeId;
                            return _ConversationTile(
                              conversation: conv,
                              isActive: isActive,
                              onTap: () =>
                                  onSelect(conv.id),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

// ─── Conversation Tile ───────────────────────────────

class _ConversationTile extends StatelessWidget {
  final PartnerConversation conversation;
  final bool isActive;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final participant =
        conversation.otherParticipant;
    final lastMsg = conversation.lastMessage;

    final timeStr = lastMsg.timestamp != null
        ? _formatTime(lastMsg.timestamp!)
        : '';

    return Material(
      color: isActive
          ? colorScheme.primaryContainer
              .withValues(alpha: 0.3)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    colorScheme.primaryContainer,
                backgroundImage:
                    participant.avatar != null
                        ? NetworkImage(
                            participant.avatar!,
                          )
                        : null,
                child: participant.avatar == null
                    ? Text(
                        participant.name.isNotEmpty
                            ? participant.name[0]
                                .toUpperCase()
                            : '?',
                        style: textTheme.titleMedium
                            ?.copyWith(
                          color: colorScheme
                              .onPrimaryContainer,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Name + last message
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            participant.name,
                            style: textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight:
                                  conversation
                                          .unreadCount >
                                      0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: colorScheme
                                  .onSurface,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ),
                        Text(
                          timeStr,
                          style: textTheme
                              .labelSmall
                              ?.copyWith(
                            color: conversation
                                        .unreadCount >
                                    0
                                ? colorScheme
                                    .primary
                                : colorScheme
                                    .onSurfaceVariant
                                    .withValues(
                                        alpha:
                                            0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMsg.text ?? '',
                            style: textTheme
                                .bodySmall
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                          ),
                        ),
                        if (conversation
                                .unreadCount >
                            0)
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration:
                                BoxDecoration(
                              color: colorScheme
                                  .primary,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          10),
                            ),
                            child: Text(
                              '${conversation.unreadCount}',
                              style: textTheme
                                  .labelSmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onPrimary,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d';
    }
    return DateFormat.MMMd().format(dt);
  }
}

// ─── Chat Detail Panel ──────────────────────────────

class _ChatDetailPanel extends HookConsumerWidget {
  final String conversationId;
  final PartnerConversation? conversation;

  const _ChatDetailPanel({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final detailState = ref.watch(
      partnerChatDetailProvider(conversationId),
    );
    final scrollController = useScrollController();
    final inputController =
        useTextEditingController();
    final hasText = useState(false);

    final participantName =
        conversation?.otherParticipant.name ??
            'Patient';

    // Auto-scroll on new messages
    final prevCount = useRef(0);
    useEffect(() {
      final count = detailState.messages.length;
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
    }, [detailState.messages]);

    return Column(
      children: [
        // Header
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    colorScheme.primaryContainer,
                child: Text(
                  participantName.isNotEmpty
                      ? participantName[0]
                          .toUpperCase()
                      : '?',
                  style: textTheme.titleSmall
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      participantName,
                      style: textTheme.titleSmall
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            colorScheme.onSurface,
                      ),
                    ),
                    if (detailState.userIsTyping)
                      Text(
                        'typing...',
                        style: textTheme.bodySmall
                            ?.copyWith(
                          color:
                              colorScheme.primary,
                          fontStyle:
                              FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: detailState.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : detailState.messages.isEmpty
                  ? Center(
                      child: Text(
                        'No messages yet',
                        style: textTheme.bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding:
                          const EdgeInsets.all(16),
                      itemCount: detailState
                          .messages.length,
                      itemBuilder:
                          (context, index) {
                        final msg = detailState
                            .messages[index];
                        final outgoingStatus =
                            _resolveOutgoingMessageStatus(
                          msg,
                          detailState
                              .pendingClientMessageIds,
                        );
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child:
                              _DesktopMessageBubble(
                            message: msg,
                            isPartner:
                                _isCurrentPartnerMessage(
                              msg,
                              conversation,
                            ),
                            outgoingStatus:
                                outgoingStatus,
                          ),
                        );
                      },
                    ),
        ),

        // Input bar
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant
                    .withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: inputController,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization:
                      TextCapitalization.sentences,
                  onChanged: (v) => hasText.value =
                      v.trim().isNotEmpty,
                  onSubmitted: (_) {
                    if (hasText.value) {
                      ref
                          .read(
                            partnerChatDetailProvider(
                              conversationId,
                            ).notifier,
                          )
                          .sendMessage(
                            inputController.text,
                          );
                      inputController.clear();
                      hasText.value = false;
                    }
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Type a message...',
                    hintStyle: textTheme.bodyMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(
                              alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                      borderSide: BorderSide(
                        color: colorScheme
                            .outlineVariant
                            .withValues(
                                alpha: 0.3),
                      ),
                    ),
                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              12),
                      borderSide: BorderSide(
                        color: colorScheme
                            .outlineVariant
                            .withValues(
                                alpha: 0.3),
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: hasText.value
                    ? () {
                        ref
                            .read(
                              partnerChatDetailProvider(
                                conversationId,
                              ).notifier,
                            )
                            .sendMessage(
                              inputController.text,
                            );
                        inputController.clear();
                        hasText.value = false;
                      }
                    : null,
                icon: const Icon(
                  Icons.send_rounded,
                ),
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _isCurrentPartnerMessage(
    PartnerChatMessage message,
    PartnerConversation? conversation,
  ) {
    // Determine "my message" by comparing against the
    // known counterpart in the active conversation.
    final counterpartId =
        conversation?.otherParticipant.id;
    if (counterpartId != null &&
        counterpartId.isNotEmpty) {
      return message.senderId != counterpartId;
    }

    // Fallback for optimistic local messages while
    // conversation data is still resolving.
    return message.senderId == 'current-partner';
  }

  _OutgoingMessageStatus? _resolveOutgoingMessageStatus(
    PartnerChatMessage message,
    Set<String> pendingClientMessageIds,
  ) {
    if (!_isCurrentPartnerMessage(
      message,
      conversation,
    )) {
      return null;
    }
    final clientMessageId = message.clientMessageId;
    if (clientMessageId == null) {
      return _OutgoingMessageStatus.sent;
    }
    if (pendingClientMessageIds.contains(clientMessageId)) {
      return _OutgoingMessageStatus.sending;
    }
    return _OutgoingMessageStatus.sent;
  }
}

// ─── Desktop Message Bubble ─────────────────────────

class _DesktopMessageBubble extends StatelessWidget {
  final PartnerChatMessage message;
  final bool isPartner;
  final _OutgoingMessageStatus? outgoingStatus;

  const _DesktopMessageBubble({
    required this.message,
    required this.isPartner,
    this.outgoingStatus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr =
        DateFormat.jm().format(message.createdAt);

    return Align(
      alignment: isPartner
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: Column(
          crossAxisAlignment: isPartner
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isPartner
                    ? colorScheme.primary
                    : colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight:
                      const Radius.circular(16),
                  bottomLeft: Radius.circular(
                    isPartner ? 16 : 4,
                  ),
                  bottomRight: Radius.circular(
                    isPartner ? 4 : 16,
                  ),
                ),
              ),
              child: Text(
                message.content,
                style:
                    textTheme.bodyMedium?.copyWith(
                  color: isPartner
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: textTheme.labelSmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  if (isPartner &&
                      outgoingStatus ==
                          _OutgoingMessageStatus
                              .sending) ...[
                    const SizedBox(width: 6),
                    Text(
                      'Sending',
                      style: textTheme.labelSmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (isPartner &&
                      outgoingStatus ==
                          _OutgoingMessageStatus.sent) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ],
                  if (isPartner &&
                      message.isRead) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty Panel ─────────────────────────────────────

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer
                  .withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forum_outlined,
              size: 40,
              color: colorScheme.primary
                  .withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select a conversation',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a conversation from the list\n'
            'to start messaging.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
