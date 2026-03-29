import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card showing work history as position
/// cards grouped by facility.
class EmployeeWorkHistoryCard extends StatefulWidget {
  const EmployeeWorkHistoryCard({super.key, required this.workHistory});

  final List<WorkHistoryEntry> workHistory;

  @override
  State<EmployeeWorkHistoryCard> createState() =>
      _EmployeeWorkHistoryCardState();
}

class _EmployeeWorkHistoryCardState extends State<EmployeeWorkHistoryCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            title: 'Work History',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppDimens.verticalMedium,
            ...widget.workHistory.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: AppDimens.spaceSm),
                child: _PositionCard(entry: entry),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Expandable header ─────────────────────────────

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

// ─── Position card per facility ─────────────────────

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.entry});

  final WorkHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.contentPadding(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: entry.isCurrent
            ? colorScheme.primary.withValues(alpha: 0.05)
            : colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: entry.isCurrent
              ? colorScheme.primary.withValues(alpha: 0.2)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _FacilityIcon(isCurrent: entry.isCurrent),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.facility,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.isCurrent) ...[
                      AppDimens.horizontalSmall,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceXs + 2,
                          vertical: AppDimens.spaceXxs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: AppDimens.radiusExtraSmall,
                        ),
                        child: Text(
                          'CURRENT',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.fontSizeSmall - 3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  entry.position,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  entry.period,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityIcon extends StatelessWidget {
  const _FacilityIcon({required this.isCurrent});

  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: AppDimens.ctaButtonMd,
      width: AppDimens.ctaButtonMd,
      decoration: BoxDecoration(
        color: isCurrent
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHigh,
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Icon(
        Symbols.domain,
        size: AppDimens.iconMd,
        color: isCurrent ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
    );
  }
}
