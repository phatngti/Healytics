import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card displaying the partner's verified
/// business information (brand, legal, tax, type).
class BusinessOverviewCardWidget extends StatelessWidget {
  const BusinessOverviewCardWidget({required this.info, super.key});

  final PublicProfileBusinessInfo info;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.business_rounded,
                  color: cs.primary,
                  size: AppDimens.iconMd,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'Business Overview',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _ReadOnlyChip(colorScheme: cs),
              ],
            ),
            AppDimens.verticalMedium,
            _InfoRow(label: 'Brand Name', value: info.brandName),
            _InfoRow(label: 'Legal Name', value: info.legalName),
            _InfoRow(label: 'Tax Code', value: info.taxCode),
            AppDimens.verticalSmall,
            Wrap(
              spacing: AppDimens.spaceSm,
              runSpacing: AppDimens.spaceXs,
              children: info.businessType
                  .map(
                    (type) => Chip(
                      label: Text(
                        _formatBusinessType(type),
                        style: tt.labelSmall,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBusinessType(String raw) {
    return raw
        .split('_')
        .where((p) => p.isNotEmpty)
        .map(
          (p) =>
              '${p[0].toUpperCase()}'
              '${p.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

class _ReadOnlyChip extends StatelessWidget {
  const _ReadOnlyChip({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: AppDimens.iconXs,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            'Read-only',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          Expanded(child: Text(value, style: tt.bodyMedium)),
        ],
      ),
    );
  }
}
