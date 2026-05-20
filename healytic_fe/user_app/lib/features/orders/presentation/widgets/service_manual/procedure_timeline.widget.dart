import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Procedure Steps" section with
/// blue numbered circles and step descriptions.
class ProcedureTimeline extends StatelessWidget {
  const ProcedureTimeline({
    super.key,
    required this.steps,
  });

  /// Ordered list of procedure steps.
  final List<ProcedureStepEntity> steps;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      title: 'Procedure Steps',
      child: Column(
        children: steps
            .map((step) => _StepRow(step: step))
            .toList(),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ProcedureStepEntity step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.spaceLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepCircle(number: step.stepNumber),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  step.description,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Blue circle with a centered step number.
class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: AppDimens.ctaButtonMd,
      height: AppDimens.ctaButtonMd,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
