import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card displaying the service manual
/// (guidelines, rules, procedure steps) for a product.
class ProductDetailsServiceManualCard
    extends StatelessWidget {
  final Product product;

  const ProductDetailsServiceManualCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final manual = product.serviceManual;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, theme),
          if (manual == null || _isEmpty(manual))
            _buildEmptyState(theme)
          else
            _buildContent(context, theme, manual),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Manual',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            'Guidelines, rules, and procedure '
            'steps for this service.',
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: AppDimens.paddingAllMediumLarge,
      child: Center(
        child: Text(
          'No service manual data available.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color:
                theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ── Content ──────────────────────────────────

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ServiceManualEntity manual,
  ) {
    return Padding(
      padding: AppDimens.paddingAllMediumLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (manual.preServiceGuidelines.isNotEmpty)
            ...[
              _buildGuidelinesSection(
                context,
                theme,
                manual.preServiceGuidelines,
              ),
            ],
          if (manual.serviceRules.isNotEmpty) ...[
            if (manual.preServiceGuidelines.isNotEmpty)
              _sectionDivider(),
            _buildRulesSection(
              context,
              theme,
              manual.serviceRules,
            ),
          ],
          if (manual.procedureSteps.isNotEmpty) ...[
            if (manual.preServiceGuidelines
                    .isNotEmpty ||
                manual.serviceRules.isNotEmpty)
              _sectionDivider(),
            _buildStepsSection(
              context,
              theme,
              manual.procedureSteps,
            ),
          ],
        ],
      ),
    );
  }

  // ── Guidelines ───────────────────────────────

  Widget _buildGuidelinesSection(
    BuildContext context,
    ThemeData theme,
    List<String> guidelines,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(theme, 'Pre-Service Guidelines'),
        AppDimens.verticalSmall,
        ...guidelines.map(
          (g) => _buildBulletPoint(theme, g),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(
    ThemeData theme,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              text,
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                color: theme
                    .colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Rules ────────────────────────────────────

  Widget _buildRulesSection(
    BuildContext context,
    ThemeData theme,
    List<ServiceRuleEntity> rules,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(theme, 'Service Rules'),
        AppDimens.verticalSmall,
        ...rules.map(
          (rule) => _buildRuleRow(theme, rule),
        ),
      ],
    );
  }

  Widget _buildRuleRow(
    ThemeData theme,
    ServiceRuleEntity rule,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.secondaryContainer,
              borderRadius: AppDimens.radiusSmall,
            ),
            child: Icon(
              Icons.rule,
              size: 16,
              color: theme
                  .colorScheme.onSecondaryContainer,
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (rule.description.isNotEmpty)
                  Text(
                    rule.description,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(
                      color: theme.colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Procedure Steps ──────────────────────────

  Widget _buildStepsSection(
    BuildContext context,
    ThemeData theme,
    List<ProcedureStepEntity> steps,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(theme, 'Procedure Steps'),
        AppDimens.verticalSmall,
        ...steps.map(
          (step) => _buildStepRow(theme, step),
        ),
      ],
    );
  }

  Widget _buildStepRow(
    ThemeData theme,
    ProcedureStepEntity step,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${step.stepNumber}',
              style: theme.textTheme.labelMedium
                  ?.copyWith(
                color: theme
                    .colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (step.description.isNotEmpty)
                  Text(
                    step.description,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(
                      color: theme.colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared Helpers ───────────────────────────

  Widget _sectionTitle(
    ThemeData theme,
    String text,
  ) {
    return Text(
      text,
      style: theme.textTheme.titleSmall
          ?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _sectionDivider() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1),
    );
  }

  bool _isEmpty(ServiceManualEntity manual) {
    return manual.preServiceGuidelines.isEmpty &&
        manual.serviceRules.isEmpty &&
        manual.procedureSteps.isEmpty;
  }
}
