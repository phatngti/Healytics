import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:flutter/material.dart';

class EmployeeFormActions extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const EmployeeFormActions({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          buttonType: ButtonType.outline,
          onPressed: isLoading ? null : onCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        AppButton(
          buttonType: ButtonType.elevated,
          onPressed: isLoading ? null : onSubmit,
          isLoading: isLoading,
          icon: const Icon(Icons.check, size: 20),
          child: Text(
            isLoading ? 'Creating...' : 'Create Employee',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
