import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Horizontal 4-column trust metrics bar.
class TrustMetricsBar extends StatelessWidget {
  const TrustMetricsBar({super.key, required this.metrics});

  final ClinicTrustMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = [
      _MetricItem(
        value: metrics.experienceLabel,
        label: 'EXPERIENCE',
      ),
      _MetricItem(
        value: metrics.rating.toStringAsFixed(1),
        label: 'RATING',
      ),
      _MetricItem(
        value: '${metrics.reviewCount}',
        label: 'REVIEWS',
      ),
      _MetricItem(
        value: metrics.clientsLabel,
        label: 'CLIENTS',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0)
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      items[i].value,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].label,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricItem {
  const _MetricItem({required this.value, required this.label});

  final String value;
  final String label;
}
