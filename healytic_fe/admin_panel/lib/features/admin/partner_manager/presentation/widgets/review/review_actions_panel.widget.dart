import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Action panel with approve/reject buttons and notes field
class ReviewActionsPanel extends StatefulWidget {
  const ReviewActionsPanel({
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final void Function(String note) onApprove;
  final void Function(String note) onReject;

  @override
  State<ReviewActionsPanel> createState() => _ReviewActionsPanelState();
}

class _ReviewActionsPanelState extends State<ReviewActionsPanel> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();

    final successColor = semantics?.success ?? Colors.green;
    final dangerColor = semantics?.error ?? Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: AppDimens.paddingAllMediumLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note Field
            Text(
              'Note to Provider',
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalSmall,
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter reason for rejection or notes for approval...',
                hintStyle: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: AppDimens.radiusSmall,
                  borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppDimens.radiusSmall,
                  borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppDimens.radiusSmall,
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding: AppDimens.paddingAllMediumSmall,
              ),
              style: textTheme.bodySmall,
            ),
            AppDimens.verticalMedium,

            // Approve Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => widget.onApprove(_noteController.text),
                icon: const Icon(Icons.check_circle, size: 20),
                label: const Text('Approve Provider'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: successColor,
                  foregroundColor: Colors.white,
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimens.radiusSmall,
                  ),
                  elevation: 4,
                  shadowColor: successColor.withValues(alpha: 0.4),
                ),
              ),
            ),
            AppDimens.verticalMediumSmall,

            // Reject Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () => widget.onReject(_noteController.text),
                icon: const Icon(Icons.cancel, size: 20),
                label: const Text('Reject Application'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: dangerColor,
                  side: BorderSide(color: dangerColor, width: 2),
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimens.radiusSmall,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
