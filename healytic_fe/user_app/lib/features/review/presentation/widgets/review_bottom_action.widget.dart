import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ReviewBottomAction extends StatelessWidget {
  /// Button label text.
  final String label;

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// Whether to show a trailing arrow icon.
  final bool showArrow;

  /// Whether the button is in a loading state.
  final bool isLoading;

  const ReviewBottomAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: colors.surface.withValues(alpha: 0.7),
          padding: EdgeInsets.only(
            left: AppDimens.spaceXxl,
            right: AppDimens.spaceXxl,
            top: AppDimens.spaceXxl,
            bottom: MediaQuery.of(context).padding.bottom +
                AppDimens.spaceXxl,
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.spaceLg,
                ),
                elevation: 10,
                shadowColor: colors.shadow
                    .withValues(alpha: 0.1),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      AppDimens.radiusMediumLarge,
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.onPrimary,
                      ),
                    )
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: theme
                              .textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onPrimary,
                          ),
                        ),
                        if (showArrow) ...[
                          AppDimens.horizontalSmall,
                          Icon(
                            Icons.arrow_forward,
                            color: colors.onPrimary,
                            size: AppDimens.iconLg,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
