import 'package:admin_panel/features/admin/partner_manager/domain/field_feedback.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/review_feedback.provider.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Action panel with approve/reject buttons, notes field, and flagged fields
/// counter for field-level feedback
class ReviewActionsPanel extends ConsumerStatefulWidget {
  const ReviewActionsPanel({
    required this.onApprove,
    required this.onRequestRevision,
    required this.onReject,
    super.key,
  });

  final void Function(String note) onApprove;
  final void Function(String note, List<FieldFeedback> fieldFeedback)
  onRequestRevision;
  final void Function(String note) onReject;

  @override
  ConsumerState<ReviewActionsPanel> createState() => _ReviewActionsPanelState();
}

class _ReviewActionsPanelState extends ConsumerState<ReviewActionsPanel> {
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
    final warningColor = semantics?.warning ?? Colors.orange;
    final dangerColor = semantics?.error ?? Colors.red;

    // Watch the feedback provider state to trigger rebuilds on state changes
    final feedbackState = ref.watch(reviewFeedbackProvider);
    final flaggedCount = feedbackState.values
        .where((f) => f.status == FieldFeedbackStatus.revisionRequested)
        .length;
    final hasRevisionRequests = flaggedCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'General feedback...',
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

            // Divider and action buttons
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flagged fields counter
                    if (hasRevisionRequests) ...[
                      _buildFlaggedCounter(context, flaggedCount, warningColor),
                      AppDimens.verticalMedium,
                    ],

                    // Action Buttons
                    _buildActionButtons(
                      context,
                      successColor,
                      warningColor,
                      dangerColor,
                      hasRevisionRequests,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlaggedCounter(
    BuildContext context,
    int count,
    Color warningColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.05),
        borderRadius: AppDimens.radiusExtraSmall,
        border: Border.all(color: warningColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 16, color: warningColor),
          const SizedBox(width: 6),
          Text(
            '$count field${count > 1 ? 's' : ''} flagged for revision',
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: warningColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Color successColor,
    Color warningColor,
    Color dangerColor,
    bool hasRevisionRequests,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final feedbackNotifier = ref.read(reviewFeedbackProvider.notifier);

    return Column(
      children: [
        // Approve Button with glow shadow
        Container(
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusSmall,
            boxShadow: [
              BoxShadow(
                color: successColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SizedBox(
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
                elevation: 0,
              ),
            ),
          ),
        ),
        AppDimens.verticalMediumSmall,

        // Request Revision Button with glow shadow (only shown when fields are flagged)
        if (hasRevisionRequests) ...[
          Container(
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusSmall,
              boxShadow: [
                BoxShadow(
                  color: warningColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => widget.onRequestRevision(
                  _noteController.text,
                  feedbackNotifier.revisionFeedbackList,
                ),
                icon: const Icon(Icons.edit_note, size: 20),
                label: const Text('Request Revision'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: warningColor,
                  foregroundColor: Colors.white,
                  textStyle: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimens.radiusSmall,
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
          AppDimens.verticalMediumSmall,
        ],

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
    );
  }
}
