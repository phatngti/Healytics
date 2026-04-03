import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Rating / followers row + Follow and Chat buttons.
class ClinicStatsActions extends StatelessWidget {
  const ClinicStatsActions({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.followersLabel,
    this.onFollow,
    this.onChat,
  });

  final double rating;
  final int reviewCount;
  final String followersLabel;
  final VoidCallback? onFollow;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.horizontalPadding(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$rating ★',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' ($reviewCount Reviews)'
                        ' • ',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: followersLabel,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' Followers',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FilledButton(
            onPressed: onFollow,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceXs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Follow'),
          ),
          AppDimens.horizontalSmall,
          OutlinedButton.icon(
            onPressed: onChat,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceXs,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(color: colorScheme.primary),
              textStyle: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(
              Icons.chat_bubble_outline,
              size: 14,
              color: colorScheme.primary,
            ),
            label: Text(
              'Chat',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
