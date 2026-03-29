import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card listing devices the therapist
/// is proficient with.
class TherapistDeviceProficiencyCard extends StatefulWidget {
  const TherapistDeviceProficiencyCard({super.key, required this.profile});

  final TherapistProfileEntity profile;

  @override
  State<TherapistDeviceProficiencyCard> createState() =>
      _TherapistDeviceProficiencyCardState();
}

class _TherapistDeviceProficiencyCardState
    extends State<TherapistDeviceProficiencyCard> {
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
            title: 'Device Proficiency',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppDimens.verticalMedium,
            _DeviceList(
              devices: widget.profile.deviceProficiency,
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

// ─── Device list ───────────────────────────────────

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.devices,
    required this.colorScheme,
    required this.textTheme,
  });

  final List<String> devices;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: devices
          .map(
            (device) => Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceSm),
              child: Row(
                children: [
                  Icon(
                    Symbols.devices,
                    size: AppDimens.iconSmMd,
                    color: colorScheme.primary,
                  ),
                  AppDimens.horizontalMediumSmall,
                  Expanded(
                    child: Text(
                      device,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
