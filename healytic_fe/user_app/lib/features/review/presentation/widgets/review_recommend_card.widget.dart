import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Card with a toggle switch asking whether the user
/// would recommend the specialist.
class ReviewRecommendCard extends StatelessWidget {
  /// Current recommendation preference.
  final bool wouldRecommend;

  /// Called when the toggle is changed.
  final ValueChanged<bool> onChanged;

  const ReviewRecommendCard({
    super.key,
    required this.wouldRecommend,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface
                .withValues(alpha: 0.04),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(colorScheme),
          AppDimens.horizontalMedium,
          Expanded(child: _buildLabels(context)),
          _buildToggle(colorScheme),
        ],
      ),
    );
  }

  /// Thumb-up icon inside a tinted circle.
  Widget _buildIcon(ColorScheme colorScheme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.thumb_up,
        color: colorScheme.primary,
      ),
    );
  }

  /// Title and subtitle text column.
  Widget _buildLabels(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Would recommend',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          'Would you recommend this '
          'specialist?',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Adaptive toggle switch.
  Widget _buildToggle(ColorScheme colorScheme) {
    return Switch.adaptive(
      value: wouldRecommend,
      onChanged: onChanged,
      activeTrackColor: colorScheme.primary,
      inactiveThumbColor:
          colorScheme.surfaceContainerHighest,
      inactiveTrackColor:
          colorScheme.surfaceContainerHigh,
    );
  }
}
