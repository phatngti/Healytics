import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/features/notifications/'
    'domain/entities/notification.entity.dart';
import 'package:user_app/features/notifications/'
    'presentation/providers/notification.provider.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/notification_card.widget.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/'
    'notification_section_header.widget.dart';

/// Main notifications screen rendered as a tab in
/// the bottom navigation shell.
///
/// Features:
/// - Cursor-based pagination (load-more on scroll)
/// - Pull-to-refresh
/// - Mark-all-read action in app bar
/// - Date-grouped sections (Today, Yesterday, etc.)
/// - Real-time updates via WebSocket
/// - Auto-refresh on tab focus
class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auto-refresh every time the tab becomes visible.
    // This ensures the user always sees the latest data
    // without requiring a manual pull-to-refresh.
    useEffect(() {
      Future.microtask(() {
        if (context.mounted) {
          ref.read(notificationProvider.notifier).refresh();
        }
      });
      return null;
    }, const []);

    final asyncNotifications = ref.watch(notificationProvider);
    final hPad = AppDimens.horizontalPadding(context);
    final bottomPad = AppDimens.bottomScrollPadding(context);
    final unreadAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadAsync.value ?? 0;

    return MainScreenLayout(
      title: 'Notifications',
      actions: [
        if (unreadCount > 0)
          IconButton(
            key: keys.notificationsPage.markAllReadButton,
            icon: const Icon(Symbols.done_all, size: AppDimens.iconMd),
            tooltip: 'Mark all as read',
            onPressed: () {
              ref.read(notificationProvider.notifier).markAllRead();
            },
          ),
        const SizedBox(width: 4),
      ],
      body: asyncNotifications.when(
        loading: () => _LoadingState(hPadding: hPad),
        error: (error, _) =>
            _ErrorState(onRetry: () => ref.invalidate(notificationProvider)),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const _EmptyState();
          }
          return _NotificationList(
            notifications: notifications,
            hPadding: hPad,
            bottomPadding: bottomPad,
            onRefresh: () => ref.read(notificationProvider.notifier).refresh(),
            onLoadMore: () =>
                ref.read(notificationProvider.notifier).loadMore(),
            hasMore: ref.read(notificationProvider.notifier).hasMore,
            onMarkRead: (id) =>
                ref.read(notificationProvider.notifier).markRead(id),
          );
        },
      ),
    );
  }
}

// ─── Notification List ──────────────────────────────

class _NotificationList extends StatefulWidget {
  const _NotificationList({
    required this.notifications,
    required this.hPadding,
    required this.bottomPadding,
    required this.onRefresh,
    required this.onLoadMore,
    required this.hasMore,
    required this.onMarkRead,
  });

  final List<NotificationEntity> notifications;
  final double hPadding;
  final double bottomPadding;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final bool hasMore;
  final void Function(String id) onMarkRead;

  @override
  State<_NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<_NotificationList> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || !widget.hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Trigger load-more when 200px from bottom
    if (currentScroll >= maxScroll - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    await widget.onLoadMore();
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by date section
    final sections = _groupByDate(widget.notifications);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        key: keys.notificationsPage.notificationsList,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          widget.hPadding,
          AppDimens.spaceXl,
          widget.hPadding,
          widget.bottomPadding,
        ),
        itemCount: _calculateItemCount(sections),
        itemBuilder: (context, index) {
          return _buildItem(index, sections, context);
        },
      ),
    );
  }

  /// Groups a flat notification list into
  /// date-labelled sections.
  List<_DateSection> _groupByDate(List<NotificationEntity> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<NotificationEntity>> grouped = {};
    for (final n in notifications) {
      final date = DateTime(
        n.createdAt.year,
        n.createdAt.month,
        n.createdAt.day,
      );

      String label;
      if (date == today) {
        label = 'Today';
      } else if (date == yesterday) {
        label = 'Yesterday';
      } else if (now.difference(date).inDays < 7) {
        label = 'This Week';
      } else {
        label = '${date.day}/${date.month}/${date.year}';
      }

      (grouped[label] ??= []).add(n);
    }

    return grouped.entries
        .map((e) => _DateSection(label: e.key, notifications: e.value))
        .toList();
  }

  int _calculateItemCount(List<_DateSection> sections) {
    var count = 0;
    for (final section in sections) {
      // 1 header + N cards + 1 spacing
      count += 1 + section.notifications.length + 1;
    }
    // +1 for load-more indicator
    if (widget.hasMore || _isLoadingMore) count++;
    return count;
  }

  Widget _buildItem(
    int index,
    List<_DateSection> sections,
    BuildContext context,
  ) {
    var cursor = 0;
    for (final section in sections) {
      // Section header
      if (index == cursor) {
        return NotificationSectionHeader(label: section.label);
      }
      cursor++;

      // Notification cards
      final notifCount = section.notifications.length;
      if (index < cursor + notifCount) {
        final notifIndex = index - cursor;
        final notification = section.notifications[notifIndex];
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.spaceLg),
          child: NotificationCard(
            key: keys.notificationsPage.card(notification.id),
            notification: notification,
            onTap: () {
              if (!notification.isRead) {
                widget.onMarkRead(notification.id);
              }
            },
          ),
        );
      }
      cursor += notifCount;

      // Section bottom spacing
      if (index == cursor) {
        return SizedBox(height: AppDimens.spaceXl);
      }
      cursor++;
    }

    // Load-more indicator (last item)
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Internal date section for grouping.
class _DateSection {
  final String label;
  final List<NotificationEntity> notifications;
  const _DateSection({required this.label, required this.notifications});
}

// ─── Loading State ──────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.hPadding});

  final double hPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardRad = AppDimens.cardRadius(context);
    final cardPad = AppDimens.cardPadding(context);

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding,
        vertical: AppDimens.spaceXl,
      ),
      children: [
        // Shimmer header
        Container(
          width: 60,
          height: 12,
          margin: EdgeInsets.only(bottom: AppDimens.spaceLg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusExtraSmall,
          ),
        ),
        // Shimmer cards
        ...List.generate(4, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimens.spaceLg),
            child: Container(
              padding: EdgeInsets.all(cardPad),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(cardRad),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppDimens.avatarLg,
                    height: AppDimens.avatarLg,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: AppDimens.radiusMedium,
                    ),
                  ),
                  SizedBox(width: AppDimens.spaceLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: 160,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppDimens.radiusExtraSmall,
                          ),
                        ),
                        SizedBox(height: AppDimens.spaceSm),
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppDimens.radiusExtraSmall,
                          ),
                        ),
                        SizedBox(height: AppDimens.spaceXs),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppDimens.radiusExtraSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Empty State ────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.notifications_none,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppDimens.verticalMedium,
          Text(
            'No notifications yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            "We'll notify you when something "
            'important happens',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Error State ────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          AppDimens.verticalMedium,
          Text(
            'Could not load notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            AppDimens.verticalMedium,
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
