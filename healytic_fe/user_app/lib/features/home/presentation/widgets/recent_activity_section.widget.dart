import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/presentation/'
    'providers/home.provider.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';
import 'package:user_app/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';

/// Neutral card colour from the surface-container
/// tier so cards stand out slightly without
/// inheriting a primary/secondary tint.
Color _cardColor(ColorScheme cs) => cs.surfaceContainerLow;

/// Displays a list of recent appointment activity
/// on the home dashboard, fetched via
/// [recentActivityProvider].
class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final titleGap = AppDimens.titleGap(context);
    final asyncActivities = ref.watch(
      recentActivityProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: titleGap),
        asyncActivities.when(
          loading: () => const _LoadingState(),
          error: (_, __) => const _ErrorState(),
          data: (activities) {
            if (activities.isEmpty) {
              return const _EmptyState();
            }
            return _ActivityList(
              activities: activities,
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Activity list
// ─────────────────────────────────────────────────

class _ActivityList extends StatelessWidget {
  final List<AppointmentEntity> activities;

  const _ActivityList({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < activities.length; i++) ...[
          if (i > 0)
            SizedBox(height: AppDimens.spaceMd),
          _ActivityCard(appointment: activities[i]),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// Single activity card
// ─────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _ActivityCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors =
        theme.extension<SemanticColors>()!;
    final contentPad =
        AppDimens.contentPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final cardColor = _cardColor(theme.colorScheme);

    final statusStyle = _resolveStatusStyle(
      appointment.status,
      semanticColors,
    );

    return Container(
      padding: EdgeInsets.all(contentPad),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardRad),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: Offset(0, AppDimens.spaceXs),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: AppDimens.avatarMd,
            width: AppDimens.avatarMd,
            decoration: BoxDecoration(
              color: statusStyle.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusStyle.icon,
              color: statusStyle.iconColor,
            ),
          ),
          SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.serviceName,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: AppDimens.spaceXxs,
                ),
                Text(
                  _formatTime(appointment),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.spaceSm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceXs,
            ),
            decoration: BoxDecoration(
              color: statusStyle.statusBgColor,
              borderRadius: AppDimens.radiusPill,
            ),
            child: Text(
              statusStyle.label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color: statusStyle.statusColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats the appointment date and check-in time
  /// into a human-readable string.
  String _formatTime(AppointmentEntity appt) {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );
    final apptDay = DateTime(
      appt.date.year,
      appt.date.month,
      appt.date.day,
    );
    final diff = apptDay.difference(today).inDays;

    final String dayLabel;
    if (diff == 0) {
      dayLabel = 'Today';
    } else if (diff == 1) {
      dayLabel = 'Tomorrow';
    } else if (diff == -1) {
      dayLabel = 'Yesterday';
    } else {
      dayLabel =
          '${appt.date.day}/${appt.date.month}';
    }
    return '$dayLabel at ${appt.checkInTime}';
  }

  /// Maps an appointment status string to visual
  /// properties (icon, colours, label).
  _StatusStyle _resolveStatusStyle(
    String status,
    SemanticColors semantic,
  ) {
    switch (status) {
      case 'completed':
        return _StatusStyle(
          icon: Symbols.check_circle,
          iconColor: semantic.success!,
          iconBgColor: semantic.success!
              .withValues(alpha: 0.1),
          statusColor: semantic.success!,
          statusBgColor: semantic.success!
              .withValues(alpha: 0.1),
          label: 'Completed',
        );
      case 'canceled':
      case 'cancelled':
        return _StatusStyle(
          icon: Symbols.cancel,
          iconColor: semantic.error!,
          iconBgColor: semantic.error!
              .withValues(alpha: 0.1),
          statusColor: semantic.error!,
          statusBgColor: semantic.error!
              .withValues(alpha: 0.1),
          label: 'Canceled',
        );
      case 'scheduled':
      case 'upcoming':
      default:
        return _StatusStyle(
          icon: Symbols.schedule,
          iconColor: semantic.info!,
          iconBgColor: semantic.info!
              .withValues(alpha: 0.1),
          statusColor: semantic.info!,
          statusBgColor: semantic.info!
              .withValues(alpha: 0.1),
          label: 'Scheduled',
        );
    }
  }
}

// ─────────────────────────────────────────────────
// Status style value object
// ─────────────────────────────────────────────────

class _StatusStyle {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color statusColor;
  final Color statusBgColor;
  final String label;

  const _StatusStyle({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.statusColor,
    required this.statusBgColor,
    required this.label,
  });
}

// ─────────────────────────────────────────────────
// Loading state
// ─────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentPad =
        AppDimens.contentPadding(context);
    final cardRad = AppDimens.cardRadius(context);

    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == 0
                ? AppDimens.spaceMd
                : 0,
          ),
          child: Container(
            padding: EdgeInsets.all(contentPad),
            decoration: BoxDecoration(
              color: theme.colorScheme
                  .surfaceContainerLow,
              borderRadius:
                  BorderRadius.circular(cardRad),
            ),
            child: Row(
              children: [
                Container(
                  height: AppDimens.avatarMd,
                  width: AppDimens.avatarMd,
                  decoration: BoxDecoration(
                    color: theme.colorScheme
                        .surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: AppDimens.spaceLg,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppDimens.spaceLg,
                        width: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme
                              .surfaceContainerHighest,
                          borderRadius: AppDimens
                              .radiusExtraSmall,
                        ),
                      ),
                      SizedBox(
                        height: AppDimens.spaceXs,
                      ),
                      Container(
                        height: AppDimens.spaceMd,
                        width: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme
                              .surfaceContainerHighest,
                          borderRadius: AppDimens
                              .radiusExtraSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AppDimens.spaceMdLg,
                  width: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme
                        .surfaceContainerHighest,
                    borderRadius:
                        AppDimens.radiusPill,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.spaceXl,
        ),
        child: Column(
          children: [
            Icon(
              Symbols.history_toggle_off,
              size: AppDimens.avatarMd,
              color: theme
                  .colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No recent activity',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color: theme
                    .colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.spaceXl,
        ),
        child: Column(
          children: [
            Icon(
              Symbols.error_outline,
              size: AppDimens.avatarMd,
              color: theme
                  .colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'Could not load activity',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color: theme
                    .colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
