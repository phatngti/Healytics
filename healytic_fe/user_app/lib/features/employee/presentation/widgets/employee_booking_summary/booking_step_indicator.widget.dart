import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Linear progress indicator showing the current
/// booking step with a label and description.
///
/// Employee-booking-specific clone — not shared
/// with the standard booking flow.
class BookingStepIndicator extends StatelessWidget {
  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
  });

  /// Current step number (1-indexed).
  final int currentStep;

  /// Total number of steps.
  final int totalSteps;

  /// Short description shown on the right
  /// (e.g. "Details", "Schedule", "Confirm").
  final String stepLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep of $totalSteps',
              style: theme.textTheme.labelSmall
                  ?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: colorScheme.primary,
              ),
            ),
            Text(
              stepLabel,
              style: theme.textTheme.labelMedium
                  ?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.spaceSm),
        ClipRRect(
          borderRadius: AppDimens.radiusPill,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppDimens.spaceXs,
            backgroundColor: colorScheme
                .surfaceContainerHighest,
            valueColor:
                AlwaysStoppedAnimation(
              colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
