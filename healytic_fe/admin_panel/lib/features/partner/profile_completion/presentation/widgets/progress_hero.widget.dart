import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Progress hero banner showing completion status,
/// percentage, and checklist chips.
class ProgressHeroWidget extends StatelessWidget {
  const ProgressHeroWidget({
    required this.entity,
    required this.checklist,
    required this.completionPercent,
    required this.requiredCompletedCount,
    super.key,
  });

  final PartnerProfileCompletionEntity entity;
  final List<CompletionChecklistItem> checklist;
  final int completionPercent;
  final int requiredCompletedCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceXxl + AppDimens.spaceXs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  colorScheme.primary.withValues(alpha: 0.18),
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                ]
              : [
                  colorScheme.primaryContainer,
                  colorScheme.surfaceContainerHighest,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: isDark
              ? colorScheme.primary.withValues(alpha: 0.25)
              : colorScheme.outlineVariant,
        ),
        boxShadow: [
          if (isDark)
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: AppDimens.spaceXxl,
              offset: const Offset(0, AppDimens.spaceSm),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VerifiedBadge(successColor: successColor),
          AppDimens.verticalLargeExtra,
          Text(
            'Profile $completionPercent% complete',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            'Your clinic account is verified. '
            'Add the final public profile details '
            'before entering the provider dashboard.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalLargeExtra,
          ClipRRect(
            borderRadius: AppDimens.radiusPill,
            child: LinearProgressIndicator(
              value: completionPercent / 100,
              minHeight: AppDimens.spaceSmMd,
              backgroundColor: isDark
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.surface,
            ),
          ),
          AppDimens.verticalMedium,
          Text(
            '$requiredCompletedCount of 4 '
            'required sections completed',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppDimens.verticalMedium,
          Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceMd,
            children: checklist
                .map((item) => ChecklistChipWidget(item: item))
                .toList(),
          ),
          if (entity.isCompleted) ...[
            AppDimens.verticalMedium,
            Text(
              'The backend already considers this '
              'profile complete. Press '
              '"Complete profile" to refresh your '
              'session and enter the dashboard.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small "Verification approved" pill badge.
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.successColor});

  final Color successColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMdLg,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: 0.16),
        borderRadius: AppDimens.radiusPill,
        border: Border.all(color: successColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: AppDimens.iconSmMd,
            color: successColor,
          ),
          AppDimens.horizontalSmall,
          Text(
            'Verification approved',
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: successColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single checklist chip showing completion
/// status for a profile section.
class ChecklistChipWidget extends StatelessWidget {
  const ChecklistChipWidget({required this.item, super.key});

  final CompletionChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDone = item.completed;
    final successClr = semanticColors?.success ?? colorScheme.primary;

    final backgroundColor = isDone
        ? successClr.withValues(alpha: 0.15)
        : isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMdLg,
        vertical: AppDimens.spaceSmMd,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppDimens.radiusPill,
        border: Border.all(
          color: isDone
              ? successClr.withValues(alpha: 0.4)
              : isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.5)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: AppDimens.iconSmMd,
            color: isDone ? successClr : colorScheme.onSurfaceVariant,
          ),
          AppDimens.horizontalSmall,
          Text(
            item.label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (!item.isRequired) ...[
            AppDimens.horizontalSmall,
            Text(
              'Optional',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
