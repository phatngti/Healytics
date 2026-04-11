import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Right-rail card showing the completion progress
/// bar and checklist items.
class CompletionSidebarWidget
    extends StatelessWidget {
  const CompletionSidebarWidget({
    required this.summary,
    super.key,
  });

  final PublicProfileCompletionSummary summary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final pct = summary.completionPercent;

    return Card(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Profile Completion',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '$pct%',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: summary.isCompleted
                        ? cs.primary
                        : cs.error,
                  ),
                ),
              ],
            ),
            AppDimens.verticalSmall,
            ClipRRect(
              borderRadius:
                  AppDimens.radiusSmall,
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 8,
                backgroundColor:
                    cs.surfaceContainerHighest,
                color: summary.isCompleted
                    ? cs.primary
                    : cs.tertiary,
              ),
            ),
            AppDimens.verticalMedium,
            ...summary.checklist.map(
              (item) => _ChecklistRow(item: item),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final PublicProfileChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(
            item.completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked,
            color: item.completed
                ? cs.primary
                : cs.outline,
            size: AppDimens.iconSmMd,
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: Text(
              item.label,
              style: tt.bodySmall?.copyWith(
                color: item.completed
                    ? cs.onSurface
                    : cs.onSurfaceVariant,
                decoration: item.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          if (item.isRequired)
            Text(
              'Required',
              style: tt.labelSmall?.copyWith(
                color: item.completed
                    ? cs.primary
                    : cs.error,
              ),
            ),
        ],
      ),
    );
  }
}
