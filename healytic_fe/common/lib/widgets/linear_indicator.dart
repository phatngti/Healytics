import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

/// A step-based linear progress indicator that displays "Step X/Y"
/// text above a horizontal progress bar.
///
/// Useful for multi-step forms, onboarding flows, or wizard-style UIs.
///
/// ```dart
/// AppLinearPercentIndicator(
///   step: 2,
///   maxSteps: 5,
/// )
/// ```
class AppLinearPercentIndicator extends StatelessWidget {
  /// Creates an [AppLinearPercentIndicator].
  ///
  /// - [step] — The current step number (1-based).
  /// - [maxSteps] — Total number of steps.
  const AppLinearPercentIndicator({
    super.key,
    required this.step,
    required this.maxSteps,
  });

  /// The current step (1-based index).
  final int step;

  /// The total number of steps.
  final int maxSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Step $step/$maxSteps',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        AppDimens.verticalExtraSmall,
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 8.0,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(100),
          percent: step / maxSteps,
          progressColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
