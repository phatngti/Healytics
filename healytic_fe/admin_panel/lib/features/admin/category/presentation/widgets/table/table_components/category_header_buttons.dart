import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryHeaderButtons {
  static List<AppButton> buildTableButtons(BuildContext context) => [
    _buildAddButton(context),
  ];

  static AppButton _buildAddButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppButton(
      buttonType: ButtonType.elevated,
      onPressed: () {
        context.goNamed(CategoryAddRoute.name);
      },
      child: Row(
        children: [
          Icon(Icons.add, color: colorScheme.onPrimary),
          AppDimens.horizontalSmall,
          Text(
            'Add Category',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }
}
