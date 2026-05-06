import 'package:flutter/material.dart';

/// A pill-style segmented control for tab switching.
///
/// Renders as a rounded container with animated
/// indicator that slides to the selected tab.
class SegmentedTabControl extends StatelessWidget {
  /// Labels for each segment.
  final List<String> labels;

  /// Currently selected index.
  final int selectedIndex;

  /// Called when a segment is tapped.
  final ValueChanged<int> onChanged;

  const SegmentedTabControl({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? cs.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: cs.shadow.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? cs.onSurface
                              : cs.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
