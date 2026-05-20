import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card displaying doctor specializations
/// as colored chips.
class DoctorSpecialtiesCard extends StatefulWidget {
  const DoctorSpecialtiesCard({super.key, required this.profile});

  final DoctorProfileEntity profile;

  @override
  State<DoctorSpecialtiesCard> createState() => _DoctorSpecialtiesCardState();
}

class _DoctorSpecialtiesCardState extends State<DoctorSpecialtiesCard> {
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
            title: 'Key Specialties',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppDimens.verticalMedium,
            _ChipList(
              items: widget.profile.specializations,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Expandable header with Semantics ──────────────

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

// ─── Specialty chips ───────────────────────────────

class _ChipList extends StatelessWidget {
  const _ChipList({
    required this.items,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<String> items;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    /// Use semantic theme colors for chip variants
    /// rather than hardcoded Material colors.
    final chipColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.error,
      colorScheme.inversePrimary,
    ];

    return Wrap(
      spacing: AppDimens.spaceSm,
      runSpacing: AppDimens.spaceSm,
      children: items.asMap().entries.map((entry) {
        final color = chipColors[entry.key % chipColors.length];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceXs + 2,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            entry.value,
            style: textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
