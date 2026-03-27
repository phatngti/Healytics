import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Quy định dịch vụ" section with
/// icon-labelled rule cards.
class ServiceRules extends StatelessWidget {
  const ServiceRules({super.key, required this.rules});

  /// List of service rule entries.
  final List<ServiceRuleEntity> rules;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      icon: Symbols.policy,
      title: 'Quy định dịch vụ',
      child: Column(
        children: rules.map((rule) => _RuleRow(rule: rule)).toList(),
      ),
    );
  }
}

/// Maps an icon slug string to an [IconData].
IconData _resolveIcon(String slug) {
  return switch (slug) {
    'volume_off' => Symbols.volume_off,
    'event_busy' => Symbols.event_busy,
    _ => Symbols.info,
  };
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.rule});

  final ServiceRuleEntity rule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _resolveIcon(rule.iconSlug),
            size: AppDimens.iconMd,
            color: colors.primary,
          ),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  rule.description,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.outline,
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
