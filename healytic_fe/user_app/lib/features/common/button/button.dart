import 'package:flutter/material.dart';

/// Enum to define the type of button to be created.
enum ButtonType { elevated, outline, text, link }

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// A factory widget that builds different types of buttons
/// based on the [buttonType] parameter.
class AppButton extends StatelessWidget {
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
  });

  final VoidCallback? onPressed;
  final ValueSetter<bool>? onHover;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final ButtonType buttonType;
  final Widget? icon;
  final ButtonStyle? customStyle;
  final Widget child;
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
        ).merge(baseStyle);
    }
  }
}
