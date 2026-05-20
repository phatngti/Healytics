import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/router/routes.dart';

/// Full list of recent appointment activity from home.
class HomeRecentActivityScreen extends ConsumerWidget {
  const HomeRecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(allRecentActivityProvider);

    return HomeListScreenLayout(
      title: 'Recent Activity',
      body: switch (activityAsync) {
        AsyncData(:final value) => _ActivityList(activities: value),
        AsyncError(:final error, :final stackTrace) => Center(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: ErrorCard(
              title: 'Could not load recent activity',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(allRecentActivityProvider),
            ),
          ),
        ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.activities});

  final List<AppointmentEntity> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const _EmptyState();
    }

    final hPad = AppDimens.horizontalPadding(context);
    final gap = AppDimens.contentPadding(context);

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceLg,
        hPad,
        AppDimens.bottomScrollPadding(context),
      ),
      itemCount: activities.length,
      separatorBuilder: (_, __) => SizedBox(height: gap),
      itemBuilder: (context, index) {
        return _ActivityCard(appointment: activities[index]);
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);
    final style = _statusStyle(appointment.status, colorScheme);

    return Semantics(
      button: true,
      label: appointment.serviceName,
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: appointment.id.isEmpty
              ? null
              : () => OrderDetailsRoute(
                  appointmentId: appointment.id,
                ).push(context),
          child: Padding(
            padding: EdgeInsets.all(contentPad),
            child: Row(
              children: [
                _StatusIcon(style: style),
                AppDimens.horizontalMedium,
                Expanded(child: _ActivityDetails(appointment: appointment)),
                AppDimens.horizontalSmall,
                _StatusChip(style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.avatarMd,
      width: AppDimens.avatarMd,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(style.icon, color: style.color),
    );
  }
}

class _ActivityDetails extends StatelessWidget {
  const _ActivityDetails({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.serviceName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalExtraSmall,
        Text(
          _formatTime(appointment),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (appointment.healthPartnerName.isNotEmpty) ...[
          AppDimens.verticalExtraSmall,
          Text(
            appointment.healthPartnerName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String _formatTime(AppointmentEntity appointment) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDay = DateTime(
      appointment.date.year,
      appointment.date.month,
      appointment.date.day,
    );
    final diff = appointmentDay.difference(today).inDays;

    final dayLabel = switch (diff) {
      0 => 'Today',
      1 => 'Tomorrow',
      -1 => 'Yesterday',
      _ => '${appointment.date.day}/${appointment.date.month}',
    };
    return '$dayLabel at ${appointment.checkInTime}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        style.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: style.color,
          fontWeight: AppDimens.fontWeightBold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;
}

_StatusStyle _statusStyle(String status, ColorScheme colorScheme) {
  return switch (status) {
    'pending_payment' => _StatusStyle(
      icon: Symbols.payment,
      color: colorScheme.tertiary,
      label: 'Payment',
    ),
    'completed' => _StatusStyle(
      icon: Symbols.check_circle,
      color: colorScheme.primary,
      label: 'Done',
    ),
    'processing' => _StatusStyle(
      icon: Symbols.pending_actions,
      color: colorScheme.secondary,
      label: 'Processing',
    ),
    'canceled' || 'cancelled' => _StatusStyle(
      icon: Symbols.cancel,
      color: colorScheme.error,
      label: 'Canceled',
    ),
    _ => _StatusStyle(
      icon: Symbols.schedule,
      color: colorScheme.secondary,
      label: 'Scheduled',
    ),
  };
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Text(
          'No recent activity',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
