import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card showing employee contact
/// information: email, phone, emergency contact.
class EmployeeContactInfoCard extends StatefulWidget {
  const EmployeeContactInfoCard({super.key, required this.employee});

  final EmployeeDetailEntity employee;

  @override
  State<EmployeeContactInfoCard> createState() =>
      _EmployeeContactInfoCardState();
}

class _EmployeeContactInfoCardState extends State<EmployeeContactInfoCard> {
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
            title: 'Contact Information',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[
            AppDimens.verticalMedium,
            _ContactRow(
              icon: Symbols.mail,
              label: 'Email',
              value: widget.employee.email,
            ),
            if (widget.employee.phone != null) ...[
              AppDimens.verticalSmall,
              _ContactRow(
                icon: Symbols.phone,
                label: 'Phone',
                value: widget.employee.phone!,
              ),
            ],
            if (_hasEmergencyContact) ...[
              AppDimens.verticalMedium,
              _EmergencyContactSection(
                name: widget.employee.emergencyContactName!,
                phone: widget.employee.emergencyContactPhone,
              ),
            ],
          ],
        ],
      ),
    );
  }

  bool get _hasEmergencyContact => widget.employee.emergencyContactName != null;
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

// ─── Contact row ───────────────────────────────────

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          height: AppDimens.ctaButtonMd,
          width: AppDimens.ctaButtonMd,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusMediumSmall,
          ),
          child: Icon(
            icon,
            size: AppDimens.iconSmMd,
            color: colorScheme.primary,
          ),
        ),
        AppDimens.horizontalMediumSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Emergency contact section ─────────────────────

class _EmergencyContactSection extends StatelessWidget {
  const _EmergencyContactSection({required this.name, this.phone});

  final String name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.contentPadding(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.15),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.emergency,
            size: AppDimens.iconSmMd,
            color: colorScheme.error,
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contact',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  name,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (phone != null)
                  Text(
                    phone!,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
