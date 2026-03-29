import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card showing the employee's weekly
/// work schedule.
class EmployeeScheduleCard extends StatefulWidget {
  const EmployeeScheduleCard({super.key, required this.schedule});

  final List<WorkScheduleEntry> schedule;

  @override
  State<EmployeeScheduleCard> createState() => _EmployeeScheduleCardState();
}

class _EmployeeScheduleCardState extends State<EmployeeScheduleCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cardPad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _ExpandableHeader(
            title: 'Workplaces & Schedule',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppDimens.verticalMedium,
            _ScheduleList(
              schedule: widget.schedule,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Shared expandable header ──────────────────────

class _ExpandableHeader extends StatelessWidget {
  const _ExpandableHeader({
    required this.title,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: expanded ? 'Collapse $title' : 'Expand $title',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              expanded ? Symbols.expand_less : Symbols.expand_more,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconLg,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({
    required this.schedule,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<WorkScheduleEntry> schedule;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final workingDays = schedule.where((e) => e.isWorking).toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: workingDays.length,
        separatorBuilder: (_, __) => Divider(
          height: AppDimens.borderWidth,
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          return _ScheduleRow(
            entry: workingDays[index],
            isFirst: index == 0,
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.entry,
    required this.isFirst,
    required this.colorScheme,
    required this.textTheme,
  });

  final WorkScheduleEntry entry;
  final bool isFirst;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.contentPadding(context),
        vertical: AppDimens.contentPadding(context),
      ),
      decoration: isFirst
          ? BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.spaceMd),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            entry.day,
            style: isFirst
                ? textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  )
                : textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
          Text(
            _formatTime,
            style: isFirst
                ? textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)
                : textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
        ],
      ),
    );
  }

  String get _formatTime {
    if (!entry.isWorking) return 'Off';
    final start = entry.startTime ?? '--';
    final end = entry.endTime ?? '--';
    return '$start - $end';
  }
}
