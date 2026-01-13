import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeFormActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final String submitLabel;
  final Widget? submitIcon;

  const EmployeeFormActions({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.isLoading = false,
    this.submitLabel = 'Create Employee',
    this.submitIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppButton(
          buttonType: ButtonType.outline,
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),
        AppDimens.horizontalSmall,
        AppButton(
          buttonType: ButtonType.elevated,
          onPressed: isLoading ? null : onSubmit,
          isLoading: isLoading,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (submitIcon != null) ...[
                submitIcon!,
                AppDimens.horizontalSmall,
              ],
              Text(submitLabel),
            ],
          ),
        ),
      ],
    );
  }
}
