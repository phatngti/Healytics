import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Defines the visual style variant of an [AppButton].
///
/// - [elevated] — A filled button with elevation (Material `ElevatedButton`).
/// - [outline] — A bordered button with no fill (Material `OutlinedButton`).
/// - [text] — A flat text-only button (Material `TextButton`).
/// - [link] — A text button styled as a hyperlink with underline decoration.
enum ButtonType { elevated, outline, text, link }

/// A compact loading indicator displayed inside a button when [AppButton.isLoading] is `true`.
///
/// Renders a responsive-sized [CircularProgressIndicator] using the
/// `onPrimary` color from the current theme.
///
/// ```dart
/// // Typically used internally by AppButton, but can be used standalone:
/// const LoadingContainer()
/// ```
class LoadingContainer extends StatelessWidget {
  /// Creates a [LoadingContainer] with a responsive circular spinner.
  const LoadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppDimens.responsiveIconSizeLarge(context);
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// A factory-pattern button widget that renders different Material button
/// styles based on the [buttonType] parameter.
///
/// Supports all four [ButtonType] variants, optional leading [icon],
/// a [isLoading] state that swaps the label for a spinner, and full
/// style customization via [customStyle].
///
/// {@tool snippet}
/// ```dart
/// // Elevated button (default)
/// AppButton(
///   onPressed: () => print('Tapped'),
///   child: Text('Submit'),
/// )
///
/// // Outlined button with icon and loading state
/// AppButton(
///   buttonType: ButtonType.outline,
///   icon: Icon(Icons.save),
///   isLoading: _isSaving,
///   onPressed: _isSaving ? null : _save,
///   child: Text('Save'),
/// )
/// ```
/// {@end-tool}
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  ///
  /// - [child] — The button label widget (typically a [Text]).
  /// - [onPressed] — Tap callback. Pass `null` to disable the button.
  /// - [buttonType] — Visual variant (defaults to [ButtonType.elevated]).
  /// - [icon] — Optional leading icon; when set, uses the `.icon` constructor.
  /// - [isLoading] — When `true`, replaces [child] with a [LoadingContainer].
  /// - [customStyle] — Merged with the internally built style for fine-tuning.
  /// - [primaryColor] / [onPrimaryColor] — Override the theme's primary colors.
  const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonType = ButtonType.elevated,
    this.onHover,
    this.primaryColor,
    this.onPrimaryColor,
    this.icon,
    this.customStyle,
    this.isLoading = false,
    this.selectColor,
  });

  /// Callback invoked when the button is tapped. Pass `null` to disable.
  final VoidCallback? onPressed;

  /// Called when the pointer enters or exits the button area.
  final ValueSetter<bool>? onHover;

  /// Override for the button's primary/background color.
  final Color? primaryColor;

  /// Override for the button's foreground (text/icon) color on primary.
  final Color? onPrimaryColor;

  /// Color applied when the button is in a selected state.
  final Color? selectColor;

  /// The visual style variant of the button.
  final ButtonType buttonType;

  /// Optional leading icon widget. When provided, the button uses
  /// Material's `.icon` constructor for proper icon+label layout.
  final Widget? icon;

  /// Custom [ButtonStyle] merged on top of the internally generated style.
  final ButtonStyle? customStyle;

  /// The button's label widget (typically [Text]).
  final Widget child;

  /// When `true`, replaces the [child] label with a [LoadingContainer] spinner.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? style = _buildStyle(context, customStyle);

    // This switch statement acts as the "Factory"
    //
    switch (buttonType) {
      case ButtonType.elevated:
        return (icon != null)
            ? ElevatedButton.icon(
                onPressed: onPressed,
                onHover: onHover,
                style: style,

                icon: icon!,
                label: isLoading ? const LoadingContainer() : child,
              )
            : ElevatedButton(
                onPressed: onPressed,
                onHover: onHover,
                style: style,
                child: isLoading ? const LoadingContainer() : child,
              );

      case ButtonType.outline:
        return (icon != null)
            ? OutlinedButton.icon(
                onPressed: onPressed,
                onHover: onHover,
                style: style,
                icon: icon!,
                label: isLoading ? const LoadingContainer() : child,
              )
            : OutlinedButton(
                onPressed: onPressed,
                onHover: onHover,
                style: style,
                child: isLoading ? const LoadingContainer() : child,
              );

      case ButtonType.text:
        return (icon != null)
            ? TextButton.icon(
                onPressed: onPressed,
                onHover: onHover,
                style: style,
                icon: icon!,
                label: isLoading ? const LoadingContainer() : child,
              )
            : TextButton(
                onPressed: onPressed,
                onHover: onHover,
                style: customStyle ?? style,
                child: isLoading ? const LoadingContainer() : child,
              );

      case ButtonType.link:
        // "Link" is just a TextButton with specific styling
        final linkStyle = TextButton.styleFrom(
          foregroundColor:
              primaryColor ?? Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          textStyle: const TextStyle(decoration: TextDecoration.underline),
        ).merge(style); // Merge with other custom styles

        return (icon != null)
            ? TextButton.icon(
                onPressed: onPressed,
                onHover: onHover,
                style: linkStyle,
                icon: icon!,
                label: isLoading ? const LoadingContainer() : child,
              )
            : TextButton(
                onPressed: onPressed,
                onHover: onHover,
                style: linkStyle,
                child: isLoading ? const LoadingContainer() : child,
              );
    }
  }

  /// Internal helper to build the [ButtonStyle] based on provided colors.
  ButtonStyle? _buildStyle(BuildContext context, ButtonStyle? baseStyle) {
    final shape = RoundedRectangleBorder(borderRadius: AppDimens.radiusSmall);

    switch (buttonType) {
      case ButtonType.elevated:
        final style = ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withAlpha(100),
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(900),
          shape: shape,
        );
        return baseStyle?.merge(style) ?? style;

      case ButtonType.outline:
        return OutlinedButton.styleFrom(
          // backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(
            context,
          ).colorScheme.primary, // Text/icon color
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(0x38),
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(0x61),
          shape: shape,
        ).merge(baseStyle);
      case ButtonType.text:
      case ButtonType.link:
        return TextButton.styleFrom(
          foregroundColor: primaryColor, // Text/icon color
          disabledForegroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(0x38),
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(0x61),
          shape: shape,
          padding: EdgeInsets.all(0),
        ).merge(baseStyle);
    }
  }
}
