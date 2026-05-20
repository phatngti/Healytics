import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Sticky bottom action bar for the employee
/// booking flow steps.
///
/// Shows the primary "Continue" / "Confirm"
/// button and an optional "Add to Cart" icon.
class BookingBottomAction extends StatelessWidget {
  const BookingBottomAction({
    super.key,
    required this.canContinue,
    required this.onContinue,
    this.label = 'Continue',
    this.icon = Symbols.arrow_forward,
    this.onAddToCart,
    this.isAddingToCart = false,
  });

  final bool canContinue;
  final VoidCallback onContinue;
  final String label;
  final IconData icon;

  /// When non-null, an "Add to Cart" icon button
  /// is rendered beside the primary action.
  final VoidCallback? onAddToCart;

  /// Shows a spinner inside the cart button while
  /// the add-to-cart request is in flight.
  final bool isAddingToCart;

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
      child: Row(
        children: [
          if (onAddToCart != null) ...[
            _AddToCartButton(
              isLoading: isAddingToCart,
              onTap: onAddToCart!,
            ),
            SizedBox(width: AppDimens.spaceSm),
          ],
          Expanded(child: _primaryButton(theme)),
        ],
      ),
    );
  }

  Widget _primaryButton(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Material(
      color: canContinue
          ? colorScheme.primary
          : colorScheme.surfaceContainerHighest,
      borderRadius: AppDimens.radiusMedium,
      elevation: canContinue ? 4 : 0,
      shadowColor: colorScheme.primary
          .withValues(alpha: 0.2),
      child: InkWell(
        onTap: canContinue ? onContinue : null,
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
                style: theme.textTheme.labelLarge
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
    );
  }
}

/// Outlined cart icon button with loading spinner.
class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMedium,
        side: BorderSide(
          color: colorScheme.primary,
        ),
      ),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: AppDimens.radiusMedium,
        child: SizedBox(
          width: AppDimens.touchTarget,
          height: AppDimens.touchTarget,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: AppDimens.iconSm,
                    height: AppDimens.iconSm,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : Icon(
                    Symbols.add_shopping_cart,
                    color: colorScheme.primary,
                    size: AppDimens.iconSmMd,
                  ),
          ),
        ),
      ),
    );
  }
}
