import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeHeaderButtons {
  static List<AppButton> buildTableButtons(BuildContext context) => [
    _buildAddButton(context),
    _buildDeleteAllButton(context),
  ];

  static AppButton _buildAddButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () => context.goNamed(EmployeeAddRoute.name),
      child: Row(
        children: [
          Icon(Icons.add, color: colorScheme.onPrimary),
          AppDimens.horizontalSmall,
          Text(
            'Add Employee',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  static AppButton _buildDeleteAllButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () {
        // TODO: Implement delete all functionality
      },
      customStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.error),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onError),
      ),
      child: Row(
        children: [
          Icon(Icons.delete, color: colorScheme.onError),
          AppDimens.horizontalSmall,
          Text(
            'Delete All',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onError),
          ),
        ],
      ),
    );
  }
}
