import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Full-width destructive "Log Out" button styled
/// with error-container colors and an icon.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    super.key,
    this.onPressed,
  });

  /// Callback when the user confirms logout.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cardRad = AppDimens.cardRadius(context);
    final cardPad = AppDimens.cardPadding(context);

    return Material(
      color: colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(cardRad),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: cardPad,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: AppDimens.iconLg,
                color:
                    colorScheme.onErrorContainer,
              ),
              SizedBox(width: AppDimens.spaceMd),
              Text(
                'Log Out',
                style:
                    textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color:
                      colorScheme.onErrorContainer,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
