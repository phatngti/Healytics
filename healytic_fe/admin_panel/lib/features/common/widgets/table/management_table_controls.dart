import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ManagementTableMenuOption extends StatelessWidget {
  const ManagementTableMenuOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedWidth = constraints.hasBoundedWidth;
        final option = InkWell(
          onTap: onTap,
          borderRadius: AppDimens.radiusSmall,
          child: Padding(
            padding: AppDimens.paddingAllSmall,
            child: Row(
              mainAxisSize: hasBoundedWidth
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      selected
                          ? Icons.check_circle
                          : icon ?? Icons.circle_outlined,
                      size: 18,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppDimens.horizontalSmall,
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        return hasBoundedWidth
            ? SizedBox(width: constraints.maxWidth, child: option)
            : option;
      },
    );
  }
}

class ManagementTableMenuSection extends StatelessWidget {
  const ManagementTableMenuSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: AppDimens.paddingHorizontalSmall,
          child: Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppDimens.verticalExtraSmall,
        ...children,
      ],
    );
  }
}

Future<bool> confirmManagementTableDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

void showManagementTableSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? colorScheme.error : null,
    ),
  );
}
