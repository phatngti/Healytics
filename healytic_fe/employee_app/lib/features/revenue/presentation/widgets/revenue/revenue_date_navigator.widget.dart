import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/revenue.entity.dart';

/// Date navigation row with prev/next arrows and a
/// tappable date label that jumps to today.
class RevenueDateNavigator extends StatelessWidget {
  /// The current period type.
  final RevenuePeriod period;

  /// The currently selected date.
  final DateTime selectedDate;

  /// Called when the user taps the previous arrow.
  final VoidCallback onPrevious;

  /// Called when the user taps the next arrow.
  final VoidCallback onNext;

  /// Called when the user taps the date label.
  final VoidCallback onToday;

  /// Optional test key for the previous button.
  final Key? previousKey;

  /// Optional test key for the next button.
  final Key? nextKey;

  const RevenueDateNavigator({
    required this.period,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    this.previousKey,
    this.nextKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            key: previousKey,
            icon: Icons.chevron_left,
            onTap: onPrevious,
            cs: cs,
          ),
          GestureDetector(
            onTap: onToday,
            child: Text(
              _formatLabel(),
              style: tt.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _NavButton(
            key: nextKey,
            icon: Icons.chevron_right,
            onTap: onNext,
            cs: cs,
          ),
        ],
      ),
    );
  }

  String _formatLabel() => switch (period) {
        RevenuePeriod.day =>
          DateFormat('EEE, MMM d, y')
              .format(selectedDate),
        RevenuePeriod.month =>
          DateFormat('MMMM y').format(selectedDate),
        RevenuePeriod.year => '${selectedDate.year}',
      };
}

/// Circular icon button for date navigation arrows.
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.cs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
