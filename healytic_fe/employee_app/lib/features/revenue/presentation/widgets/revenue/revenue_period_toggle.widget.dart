import 'package:flutter/material.dart';

import '../../../domain/entities/revenue.entity.dart';

/// Pill-style period toggle for Day / Month / Year.
///
/// Renders a rounded container with an animated
/// indicator that highlights the active period,
/// matching the HTML design's segmented control.
class RevenuePeriodToggle extends StatelessWidget {
  /// Currently selected period.
  final RevenuePeriod selected;

  /// Called when the user taps a different period.
  final ValueChanged<RevenuePeriod> onChanged;

  /// Optional integration test keys per period.
  final Map<RevenuePeriod, Key>? testKeys;

  const RevenuePeriodToggle({
    required this.selected,
    required this.onChanged,
    this.testKeys,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: RevenuePeriod.values.map((period) {
          final isActive = period == selected;
          return GestureDetector(
            key: testKeys?[period],
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? cs.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  100,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: cs.shadow
                              .withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                period.displayLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isActive
                          ? cs.onPrimary
                          : cs.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
