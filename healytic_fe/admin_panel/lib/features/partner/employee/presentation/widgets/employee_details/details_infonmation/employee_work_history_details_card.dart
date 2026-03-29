import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card displaying an employee's work history
/// timeline in the details view.
class EmployeeWorkHistoryDetailsCard extends StatelessWidget {
  /// The work history entries to display.
  final List<WorkHistoryEntry> workHistory;

  const EmployeeWorkHistoryDetailsCard({super.key, required this.workHistory});

  @override
  Widget build(BuildContext context) {
    if (workHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colorScheme, textTheme, semanticColors),
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              children: workHistory
                  .asMap()
                  .entries
                  .map(
                    (e) => _WorkHistoryTimelineItem(
                      entry: e.value,
                      isLast: e.key == workHistory.length - 1,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    SemanticColors semanticColors,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest.withAlpha(100),
            colorScheme.surface,
          ],
        ),
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(Icons.work_history_outlined, color: colorScheme.primary),
          AppDimens.horizontalSmall,
          Text(
            'Work History',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppDimens.radiusLarge,
            ),
            child: Text(
              '${workHistory.length} positions',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single item in the work history timeline.
class _WorkHistoryTimelineItem extends StatelessWidget {
  final WorkHistoryEntry entry;
  final bool isLast;

  const _WorkHistoryTimelineItem({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          _buildTimelineIndicator(colorScheme, semanticColors),
          AppDimens.horizontalMedium,
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: AppDimens.paddingAllMedium,
              decoration: BoxDecoration(
                borderRadius: AppDimens.radiusSmall,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          entry.facility,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.position,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.period,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(
    ColorScheme colorScheme,
    SemanticColors semanticColors,
  ) {
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.outlineVariant,
              border: Border.all(color: colorScheme.outline, width: 2),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(width: 2, color: colorScheme.outlineVariant),
            ),
        ],
      ),
    );
  }
}
