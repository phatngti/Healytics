import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:flutter/material.dart';

/// Shared header for home sections with an optional
/// "View all" action.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.actionLabel = 'View all',
  });

  /// Section title displayed on the left.
  final String title;

  /// Callback for the trailing action.
  final VoidCallback? onViewAll;

  /// Text shown in the trailing action.
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: AppDimens.fontWeightBold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onViewAll != null) ...[
          AppDimens.horizontalSmall,
          Semantics(
            button: true,
            label: '$actionLabel $title',
            child: AppButton(
              buttonType: ButtonType.text,
              onPressed: onViewAll,
              customStyle: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                minimumSize: const Size(
                  AppDimens.touchTarget,
                  AppDimens.touchTarget,
                ),
                padding: AppDimens.paddingHorizontalSmall,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppDimens.fontWeightSemiBold,
                ),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ],
    );
  }
}
