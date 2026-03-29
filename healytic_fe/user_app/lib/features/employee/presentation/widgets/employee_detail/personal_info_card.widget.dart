import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/employee/domain/entities/employee_detail.entity.dart';

/// Expandable card showing personal information:
/// date of birth, gender, start date, employment
/// type.
class EmployeePersonalInfoCard extends StatefulWidget {
  const EmployeePersonalInfoCard({super.key, required this.employee});

  final EmployeeDetailEntity employee;

  @override
  State<EmployeePersonalInfoCard> createState() =>
      _EmployeePersonalInfoCardState();
}

class _EmployeePersonalInfoCardState extends State<EmployeePersonalInfoCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardPad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    final items = _buildInfoItems;
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

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
            title: 'Personal Information',
            expanded: _expanded,
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded) ...[AppDimens.verticalMedium, _InfoGrid(items: items)],
        ],
      ),
    );
  }

  List<_InfoItem> get _buildInfoItems {
    final employee = widget.employee;
    final items = <_InfoItem>[];

    if (employee.dob != null) {
      items.add(
        _InfoItem(
          icon: Symbols.cake,
          label: 'Date of Birth',
          value: _formatDate(employee.dob!),
        ),
      );
    }

    if (employee.gender != null) {
      items.add(
        _InfoItem(
          icon: Symbols.person,
          label: 'Gender',
          value: employee.gender!.label,
        ),
      );
    }

    if (employee.startDate != null) {
      items.add(
        _InfoItem(
          icon: Symbols.calendar_today,
          label: 'Start Date',
          value: _formatDate(employee.startDate!),
        ),
      );
    }

    if (employee.employmentType != null) {
      items.add(
        _InfoItem(
          icon: Symbols.work,
          label: 'Employment',
          value: employee.employmentType!,
        ),
      );
    }

    return items;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

// ─── Data class for info items ─────────────────────

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
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

// ─── 2-column info grid ────────────────────────────

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final gap = AppDimens.sectionSpacing(context);

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = _InfoCell(
        item: items[i],
        colorScheme: colorScheme,
        textTheme: textTheme,
      );
      final right = i + 1 < items.length
          ? _InfoCell(
              item: items[i + 1],
              colorScheme: colorScheme,
              textTheme: textTheme,
            )
          : const SizedBox.shrink();

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              SizedBox(width: gap),
              Expanded(child: right),
            ],
          ),
        ),
      );

      if (i + 2 < items.length) {
        rows.add(SizedBox(height: gap));
      }
    }

    return Column(children: rows);
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  final _InfoItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.icon, size: AppDimens.iconSmMd, color: colorScheme.primary),
        AppDimens.horizontalSmall,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                item.value,
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
