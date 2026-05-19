import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/presentation/'
    'providers/home.provider.dart';
import 'package:user_app/features/orders/domain/entities/'
    'appointment.entity.dart';
import 'package:user_app/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_section_header.widget.dart';
import 'package:user_app/router/routes.dart';

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
    final titleGap = AppDimens.titleGap(context);
    final asyncActivities = ref.watch(recentActivityProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Recent Activity',
          onViewAll: () {
            const HomeRecentActivityRoute().push(context);
          },
        ),
        SizedBox(height: titleGap),
        asyncActivities.when(
          loading: () => const _LoadingState(),
          error: (_, __) => const _ErrorState(),
          data: (activities) {
            if (activities.isEmpty) {
              return const _EmptyState();
            }
            return _ActivityList(activities: activities);
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
    final orderedActivities = _sortActivitiesNewestFirst(activities);

    if (orderedActivities.length <= 3) {
      return _ActivityWindow(
        key: ValueKey(
          orderedActivities.map((activity) => activity.id).join('|'),
        ),
        activities: orderedActivities,
      );
    }

    return _AnimatedActivityTicker(activities: orderedActivities);
  }
}

class _AnimatedActivityTicker extends StatefulWidget {
  final List<AppointmentEntity> activities;

  const _AnimatedActivityTicker({required this.activities});

  @override
  State<_AnimatedActivityTicker> createState() =>
      _AnimatedActivityTickerState();
}

class _AnimatedActivityTickerState extends State<_AnimatedActivityTicker> {
  static const _visibleCount = 3;
  static const _switchInterval = Duration(seconds: 3);

  Timer? _ticker;
  int _startIndex = 0;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant _AnimatedActivityTicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_activitySignature(widget.activities) !=
        _activitySignature(oldWidget.activities)) {
      _startIndex = 0;
    } else if (_startIndex >= widget.activities.length) {
      _startIndex = 0;
    }

    _syncTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleActivities = _visibleActivities(
      widget.activities,
      _startIndex,
    );

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 550),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (child, animation) {
          final isIncoming = child.key == ValueKey<int>(_startIndex);

          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (context, child) {
              final progress = animation.value;
              final offsetY = isIncoming ? 1 - progress : progress - 1;

              return FractionalTranslation(
                translation: Offset(0, offsetY),
                child: child,
              );
            },
          );
        },
        child: _ActivityWindow(
          key: ValueKey<int>(_startIndex),
          activities: visibleActivities,
        ),
      ),
    );
  }

  void _syncTicker() {
    _ticker?.cancel();

    if (widget.activities.length <= _visibleCount) {
      return;
    }

    _ticker = Timer.periodic(_switchInterval, (_) {
      if (!mounted) return;
      setState(() {
        _startIndex = (_startIndex + 1) % widget.activities.length;
      });
    });
  }

  List<AppointmentEntity> _visibleActivities(
    List<AppointmentEntity> activities,
    int startIndex,
  ) {
    return List.generate(
      _visibleCount,
      (index) => activities[(startIndex + index) % activities.length],
    );
  }

  String _activitySignature(List<AppointmentEntity> activities) {
    return activities.map((activity) => activity.id).join('|');
  }
}

class _ActivityWindow extends StatelessWidget {
  final List<AppointmentEntity> activities;

  const _ActivityWindow({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < activities.length; i++) ...[
          if (i > 0) SizedBox(height: AppDimens.spaceMd),
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
    final semanticColors = theme.extension<SemanticColors>()!;
    final contentPad = AppDimens.contentPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final cardColor = _cardColor(theme.colorScheme);

    final statusStyle = _resolveStatusStyle(appointment.status, semanticColors);

    return Container(
      padding: EdgeInsets.all(contentPad),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardRad),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
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
            child: Icon(statusStyle.icon, color: statusStyle.iconColor),
          ),
          SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.serviceName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXxs),
                Text(
                  _formatTime(appointment),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
              style: theme.textTheme.bodySmall?.copyWith(
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
    final today = DateTime(now.year, now.month, now.day);
    final apptDay = DateTime(appt.date.year, appt.date.month, appt.date.day);
    final diff = apptDay.difference(today).inDays;

    final String dayLabel;
    if (diff == 0) {
      dayLabel = 'Today';
    } else if (diff == 1) {
      dayLabel = 'Tomorrow';
    } else if (diff == -1) {
      dayLabel = 'Yesterday';
    } else {
      dayLabel = '${appt.date.day}/${appt.date.month}';
    }
    return '$dayLabel at ${appt.checkInTime}';
  }

  /// Maps an appointment status string to visual
  /// properties (icon, colours, label).
  _StatusStyle _resolveStatusStyle(String status, SemanticColors semantic) {
    switch (status) {
      case 'pending_payment':
        return _StatusStyle(
          icon: Symbols.payment,
          iconColor: semantic.warning!,
          iconBgColor: semantic.warning!.withValues(alpha: 0.1),
          statusColor: semantic.warning!,
          statusBgColor: semantic.warning!.withValues(alpha: 0.1),
          label: 'Pending Payment',
        );
      case 'completed':
        return _StatusStyle(
          icon: Symbols.check_circle,
          iconColor: semantic.success!,
          iconBgColor: semantic.success!.withValues(alpha: 0.1),
          statusColor: semantic.success!,
          statusBgColor: semantic.success!.withValues(alpha: 0.1),
          label: 'Completed',
        );
      case 'processing':
        return _StatusStyle(
          icon: Symbols.pending_actions,
          iconColor: semantic.info!,
          iconBgColor: semantic.info!.withValues(alpha: 0.1),
          statusColor: semantic.info!,
          statusBgColor: semantic.info!.withValues(alpha: 0.1),
          label: 'Processing',
        );
      case 'canceled':
      case 'cancelled':
        return _StatusStyle(
          icon: Symbols.cancel,
          iconColor: semantic.error!,
          iconBgColor: semantic.error!.withValues(alpha: 0.1),
          statusColor: semantic.error!,
          statusBgColor: semantic.error!.withValues(alpha: 0.1),
          label: 'Canceled',
        );
      case 'scheduled':
      case 'upcoming':
      default:
        return _StatusStyle(
          icon: Symbols.schedule,
          iconColor: semantic.info!,
          iconBgColor: semantic.info!.withValues(alpha: 0.1),
          statusColor: semantic.info!,
          statusBgColor: semantic.info!.withValues(alpha: 0.1),
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
    final contentPad = AppDimens.contentPadding(context);
    final cardRad = AppDimens.cardRadius(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == 0 ? AppDimens.spaceMd : 0),
          child: Container(
            padding: EdgeInsets.all(contentPad),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(cardRad),
            ),
            child: Row(
              children: [
                Container(
                  height: AppDimens.avatarMd,
                  width: AppDimens.avatarMd,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppDimens.spaceLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppDimens.spaceLg,
                        width: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: AppDimens.radiusExtraSmall,
                        ),
                      ),
                      SizedBox(height: AppDimens.spaceXs),
                      Container(
                        height: AppDimens.spaceMd,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: AppDimens.radiusExtraSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AppDimens.spaceMdLg,
                  width: screenWidth * 0.18,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimens.radiusPill,
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
        padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXl),
        child: Column(
          children: [
            Icon(
              Symbols.history_toggle_off,
              size: AppDimens.avatarMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No recent activity',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
        padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXl),
        child: Column(
          children: [
            Icon(
              Symbols.error_outline,
              size: AppDimens.avatarMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'Could not load activity',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<AppointmentEntity> _sortActivitiesNewestFirst(
  List<AppointmentEntity> activities,
) {
  final ordered = List<AppointmentEntity>.from(activities);

  ordered.sort((a, b) {
    final aDateTime = _activityDateTime(a);
    final bDateTime = _activityDateTime(b);
    return bDateTime.compareTo(aDateTime);
  });

  return ordered;
}

DateTime _activityDateTime(AppointmentEntity appointment) {
  final time = appointment.checkInTime.trim();
  final match = RegExp(
    r'^(\d{1,2}):(\d{2})(?:\s*([AaPp][Mm]))?$',
  ).firstMatch(time);

  if (match == null) {
    return appointment.date;
  }

  var hour = int.tryParse(match.group(1) ?? '');
  final minute = int.tryParse(match.group(2) ?? '') ?? 0;
  final meridiem = match.group(3)?.toUpperCase();

  if (hour == null) {
    return appointment.date;
  }

  if (meridiem == 'PM' && hour < 12) {
    hour += 12;
  } else if (meridiem == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(
    appointment.date.year,
    appointment.date.month,
    appointment.date.day,
    hour,
    minute,
  );
}
