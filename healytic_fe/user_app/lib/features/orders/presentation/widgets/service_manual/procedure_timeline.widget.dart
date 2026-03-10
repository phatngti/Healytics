import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Quy trình thực hiện" section with
/// a numbered vertical timeline.
class ProcedureTimeline extends StatelessWidget {
  const ProcedureTimeline({super.key, required this.steps});

  /// Ordered list of procedure steps.
  final List<ProcedureStepEntity> steps;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      icon: Symbols.spa,
      title: 'Quy trình thực hiện',
      child: _Timeline(steps: steps),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.steps});

  final List<ProcedureStepEntity> steps;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: AppDimens.spaceXs),
      child: Stack(
        children: [
          // Vertical connector line
          Positioned(
            left: 9,
            top: AppDimens.spaceSm,
            bottom: AppDimens.spaceXxl,
            child: Container(
              width: AppDimens.borderWidthThick,
              color: colors.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          Column(
            children: steps
                .map((step) => _StepRow(step: step, isLast: step == steps.last))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  final ProcedureStepEntity step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : AppDimens.spaceXl,
        left: 28,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Step number circle
          Positioned(
            left: -28,
            top: AppDimens.spaceXxs,
            child: _StepCircle(
              number: step.stepNumber,
              isActive: step.isActive,
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              AppDimens.verticalExtraSmall,
              Text(
                step.description,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.number, required this.isActive});

  final int number;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isActive ? colors.primary : colors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.surfaceContainerLowest,
          width: AppDimens.borderWidthThick,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.3),
                  blurRadius: AppDimens.spaceXs,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$number',
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? colors.onPrimary : colors.primary,
          ),
        ),
      ),
    );
  }
}
