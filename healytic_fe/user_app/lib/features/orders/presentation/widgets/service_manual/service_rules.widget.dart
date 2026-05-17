import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/service_rule_icon_data.dart';

/// Displays the "Service Rules" section with
/// purple icon badges and rule descriptions.
class ServiceRules extends StatelessWidget {
  const ServiceRules({
    super.key,
    required this.rules,
  });

  /// List of service rule entries.
  final List<ServiceRuleEntity> rules;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      title: 'Service Rules',
      child: Column(
        children: rules
            .map((rule) => _RuleRow(rule: rule))
            .toList(),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.rule});

  final ServiceRuleEntity rule;

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
          Container(
            width: AppDimens.ctaButtonMd,
            height: AppDimens.ctaButtonMd,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: AppDimens.radiusSmall,
            ),
            child: Icon(
              serviceRuleIconData(rule.iconSlug) ??
                  Symbols.tune,
              size: AppDimens.iconMd,
              color: colors.onPrimary,
            ),
          ),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  rule.description,
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
