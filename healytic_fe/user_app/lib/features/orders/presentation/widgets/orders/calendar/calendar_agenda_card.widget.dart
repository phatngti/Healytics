import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Expandable agenda card for a single appointment
/// in the calendar view.
///
/// Displays time, service image, service name, and
/// specialist. Tapping toggles an inline detail
/// expansion with address and duration info.
class CalendarAgendaCard extends StatefulWidget {
  const CalendarAgendaCard({super.key, required this.appointment});

  final AppointmentEntity appointment;

  @override
  State<CalendarAgendaCard> createState() => _CalendarAgendaCardState();
}

class _CalendarAgendaCardState extends State<CalendarAgendaCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final apt = widget.appointment;

    return Material(
      color: colors.surface,
      borderRadius: AppDimens.radiusLarge,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: AppDimens.radiusLarge,
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusLarge,
            border: Border.all(
              color: _expanded
                  ? colors.primaryContainer
                  : colors.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              _CardHeader(appointment: apt),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _ExpandedDetails(appointment: apt),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Card header row ───────────────────────────────

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.appointment});
  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: AppDimens.paddingAllMedium,
      child: Row(
        children: [
          _TimeColumn(
            time: appointment.checkInTime,
            colors: colors,
            theme: theme,
          ),
          Container(
            width: 1,
            height: 36,
            margin: EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
            color: colors.outlineVariant.withValues(alpha: 0.3),
          ),
          _ServiceAvatar(imageUrl: appointment.imageUrl, colors: colors),
          SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.serviceName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  appointment.specialistName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.outline),
        ],
      ),
    );
  }
}

// ─── Time column ───────────────────────────────────

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.time,
    required this.colors,
    required this.theme,
  });

  final String time;
  final ColorScheme colors;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Parse "7:00 AM" → time + period
    final parts = time.split(' ');
    final clock = parts.first;
    final period = parts.length > 1 ? parts.last : '';

    return SizedBox(
      width: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            clock,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (period.isNotEmpty)
            Text(
              period.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: colors.outline,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Service avatar ────────────────────────────────

class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar({required this.imageUrl, required this.colors});

  final String imageUrl;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipOval(
        child: NetworkImageAuto(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_) => ColoredBox(
            color: colors.surfaceContainerHighest,
            child: Icon(Icons.spa, color: colors.onSurfaceVariant),
          ),
          errorWidget: (_) => ColoredBox(
            color: colors.surfaceContainerHighest,
            child: Icon(Icons.spa, color: colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

// ─── Expanded detail section ───────────────────────

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.appointment});

  final AppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        0,
        AppDimens.spaceLg,
        AppDimens.spaceLg,
      ),
      child: Column(
        children: [
          Divider(color: colors.outlineVariant.withValues(alpha: 0.3)),
          SizedBox(height: AppDimens.spaceSm),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: appointment.address,
            colors: colors,
            theme: theme,
          ),
          SizedBox(height: AppDimens.spaceSm),
          _DetailRow(
            icon: Icons.schedule,
            label: appointment.duration,
            colors: colors,
            theme: theme,
          ),
          SizedBox(height: AppDimens.spaceSm),
          _DetailRow(
            icon: Icons.login_rounded,
            label: 'Check in: ${appointment.checkInTime}',
            colors: colors,
            theme: theme,
          ),
          SizedBox(height: AppDimens.spaceSm),
          _StatusChip(status: appointment.status),
        ],
      ),
    );
  }
}

// ─── Detail row ────────────────────────────────────

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.colors,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colors;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconSm, color: colors.onSurfaceVariant),
        SizedBox(width: AppDimens.spaceSm),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Status chip ───────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final (bg, fg, label) = switch (status) {
      'upcoming' => (colors.primaryContainer, colors.primary, 'Upcoming'),
      'completed' => (colors.tertiaryContainer, colors.tertiary, 'Completed'),
      'canceled' => (colors.errorContainer, colors.error, 'Canceled'),
      _ => (colors.surfaceContainerHighest, colors.onSurfaceVariant, status),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXs,
        ),
        decoration: BoxDecoration(
          color: bg.withValues(alpha: 0.5),
          borderRadius: AppDimens.radiusExtraSmall,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
