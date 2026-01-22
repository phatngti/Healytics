import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Header action buttons for the partner verification table
class PartnerHeaderButtons {
  static List<AppButton> buildTableButtons(BuildContext context) => [
    _buildFilterButton(context),
  ];

  static AppButton _buildFilterButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.outline,
      onPressed: () {
        // TODO: Implement filter functionality
      },
      child: Row(
        children: [
          Icon(Icons.filter_list, color: colorScheme.primary, size: 20),
          AppDimens.horizontalSmall,
          Text(
            'Filter',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
