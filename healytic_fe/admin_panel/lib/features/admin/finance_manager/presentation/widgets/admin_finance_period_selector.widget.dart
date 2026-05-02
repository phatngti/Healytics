import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Segmented period selector (7D, 30D, 90D, etc.).
class AdminFinancePeriodSelector extends StatelessWidget {
  const AdminFinancePeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AdminFinancePeriod selected;
  final ValueChanged<AdminFinancePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<AdminFinancePeriod>(
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
            ),
          ),
        ),
        segments: AdminFinancePeriod.values
            .map(
              (p) => ButtonSegment(
                value: p,
                label: Text(p.label),
              ),
            )
            .toList(),
        selected: {selected},
        onSelectionChanged: (selection) {
          onChanged(selection.first);
        },
      ),
    );
  }
}
