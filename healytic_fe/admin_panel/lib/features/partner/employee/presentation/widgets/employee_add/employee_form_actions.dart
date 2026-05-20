import 'package:common/widgets/button/button.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeFormActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final bool isFormValid;
  final String submitLabel;
  final Widget? submitIcon;

  const EmployeeFormActions({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.isLoading = false,
    this.isFormValid = false,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDimens.horizontalSmall,
              AppButton(
                buttonType: ButtonType.elevated,
                onPressed: isLoading || !isFormValid ? null : onSubmit,
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
          ),
        ),
      ],
    );
  }
}
