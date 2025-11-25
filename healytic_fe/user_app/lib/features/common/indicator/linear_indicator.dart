import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppLinearPercentIndicator extends StatelessWidget {
  const AppLinearPercentIndicator({
    super.key,
    required this.step,
    required this.maxSteps,
  });

  final int step;
  final int maxSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Step $step/$maxSteps',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 4.0),
        LinearPercentIndicator(
          padding: EdgeInsets.all(0),
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
