import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Sticky bottom "Continue" / "Confirm" action
/// button for the employee booking flow steps.
///
/// Employee-booking-specific clone — not shared
/// with the standard booking flow.
class BookingBottomAction extends StatelessWidget {
  const BookingBottomAction({
    super.key,
    required this.canContinue,
    required this.onContinue,
    this.label = 'Continue',
    this.icon = Symbols.arrow_forward,
  });

  /// Whether the button is enabled.
  final bool canContinue;

  /// Callback when pressed.
  final VoidCallback onContinue;

  /// Button label text.
  final String label;

  /// Trailing icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hPad =
        AppDimens.horizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceMd,
        hPad,
        AppDimens.spaceXxl,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant
                .withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Material(
        color: canContinue
            ? colorScheme.primary
            : colorScheme
                .surfaceContainerHighest,
        borderRadius: AppDimens.radiusMedium,
        elevation: canContinue ? 4 : 0,
        shadowColor: colorScheme.primary
            .withValues(alpha: 0.2),
        child: InkWell(
          onTap:
              canContinue ? onContinue : null,
          borderRadius: AppDimens.radiusMedium,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.spaceLg,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: theme
                      .textTheme.labelLarge
                      ?.copyWith(
                    color: canContinue
                        ? colorScheme.onPrimary
                        : colorScheme
                            .onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: AppDimens.spaceSm,
                ),
                Icon(
                  icon,
                  size: AppDimens.iconSmMd,
                  color: canContinue
                      ? colorScheme.onPrimary
                      : colorScheme
                          .onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
