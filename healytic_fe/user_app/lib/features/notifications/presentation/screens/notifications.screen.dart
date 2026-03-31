import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/widgets/main_screen_layout.widget.dart';
import 'package:user_app/features/notifications/'
    'domain/repositories/notification.repository.dart';
import 'package:user_app/features/notifications/'
    'presentation/providers/notification.provider.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/notification_card.widget.dart';
import 'package:user_app/features/notifications/'
    'presentation/widgets/'
    'notification_section_header.widget.dart';

/// Main notifications screen, rendered as a tab in
/// the bottom navigation shell.
///
/// Uses [MainScreenLayout] for consistent
/// header/background across navigation tabs.
///
/// Layout reference: grouped date sections
/// ("Today", "Yesterday") with notification cards.
class NotificationsPage extends HookConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSections = ref.watch(notificationsProvider);
    final hPad = AppDimens.horizontalPadding(context);
    final bottomPad = AppDimens.bottomScrollPadding(context);

    return MainScreenLayout(
      title: 'Notifications',
      body: asyncSections.when(
        loading: () => _LoadingState(hPadding: hPad),
        error: (error, _) => const _ErrorState(),
        data: (sections) {
          if (sections.isEmpty) {
            return const _EmptyState();
          }
          return _NotificationList(
            sections: sections,
            hPadding: hPad,
            bottomPadding: bottomPad,
          );
        },
      ),
    );
  }
}

// ─── Notification List ──────────────────────────

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.sections,
    required this.hPadding,
    required this.bottomPadding,
  });

  final List<NotificationSection> sections;
  final double hPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        hPadding,
        AppDimens.spaceXl,
        hPadding,
        bottomPadding,
      ),
      itemCount: _calculateItemCount(),
      itemBuilder: (context, index) {
        return _buildItem(index);
      },
    );
  }

  int _calculateItemCount() {
    var count = 0;
    for (final section in sections) {
      // 1 for header, N for notifications,
      // 1 for bottom spacing
      count += 1 + section.notifications.length + 1;
    }
    return count;
  }

  Widget _buildItem(int index) {
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
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.spaceLg),
          child: NotificationCard(
            notification: section.notifications[notifIndex],
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
    return const SizedBox.shrink();
  }
}

// ─── Loading State ──────────────────────────────

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
        ...List.generate(3, (i) {
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
                        SizedBox(height: AppDimens.spaceLg),
                        Container(
                          height: 32,
                          width: 100,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: AppDimens.radiusPill,
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

// ─── Empty State ────────────────────────────────

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
            Icons.notifications_none_rounded,
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

// ─── Error State ────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
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
        ],
      ),
    );
  }
}
