import 'package:common/utils/demensions.dart';
import 'package:common/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// The semantic type of a toast notification.
///
/// Each type maps to a distinct icon, color scheme,
/// and background tint:
/// - [success] — Checkmark icon, primary color.
/// - [error] — Error icon, error color.
/// - [warning] — Warning icon, orange color.
/// - [info] — Info icon, primary color.
enum ToastType { success, error, warning, info }

/// Utility class for building and showing toast
/// notifications.
///
/// Provides both a widget builder ([switchToast])
/// and a convenience method ([showToast]) that
/// handles [FToast] initialization and positioning.
///
/// ```dart
/// // Show a success toast
/// ToastContext.showToast(
///   context, ToastType.success, 'Item saved!',
/// );
///
/// // Show an error toast
/// ToastContext.showToast(
///   context, ToastType.error, 'Failed to save.',
/// );
/// ```
class ToastContext {
  /// Builds a toast widget with the appropriate icon,
  /// colors, and message based on [type].
  /// Returns a styled [Container] ready to be shown.
  ///
  /// Override colors per type with optional
  /// [successColor], [errorColor], [warningColor],
  /// or [infoColor] parameters.
  static Widget switchToast(
    BuildContext context,
    ToastType type,
    String message, {
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
  }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final icon = switch (type) {
      ToastType.success => Icons.check,
      ToastType.error => Icons.error,
      ToastType.warning => Icons.warning,
      ToastType.info => Icons.info,
    };

    final iconColor = switch (type) {
      ToastType.success =>
        successColor ?? colorScheme.primary,
      ToastType.error =>
        errorColor ?? colorScheme.error,
      ToastType.warning =>
        warningColor ?? Colors.orange.shade700,
      ToastType.info =>
        infoColor ?? colorScheme.primary,
    };

    final bgColor = switch (type) {
      ToastType.success =>
        (successColor ?? colorScheme.primary)
            .withAlpha(25),
      ToastType.error =>
        (errorColor ?? colorScheme.error)
            .withAlpha(25),
      ToastType.warning =>
        Colors.orange.withAlpha(25),
      ToastType.info =>
        colorScheme.primary.withAlpha(25),
    };

    final textColor = switch (type) {
      ToastType.success =>
        successColor ?? colorScheme.primary,
      ToastType.error =>
        errorColor ?? colorScheme.error,
      ToastType.warning =>
        warningColor ?? Colors.orange.shade700,
      ToastType.info =>
        infoColor ?? colorScheme.primary,
    };

    final maxWidthFraction = responsive<double>(
      context,
      mobile: 0.85,
      tablet: 0.5,
      web: 0.3,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth:
            screenWidth(context) * maxWidthFraction,
      ),
      padding:
          AppDimens.responsivePadding(context),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          AppDimens.horizontalSmall,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a toast positioned at the top-right of
  /// the screen for 2 seconds.
  ///
  /// Defers display to the next frame via
  /// [SchedulerBinding.addPostFrameCallback] so the
  /// [Navigator]'s [Overlay] is guaranteed to be
  /// mounted. Silently drops the toast if the
  /// context becomes invalid or no [Overlay] exists.
  ///
  /// - [context] — Build context for theme access.
  /// - [type] — The [ToastType] for icon and color.
  /// - [message] — Text content of the toast.
  static void showToast(
    BuildContext context,
    ToastType type,
    String message,
  ) {
    // Defer to next frame so the Overlay is
    // guaranteed to be mounted.
    SchedulerBinding.instance
        .addPostFrameCallback((_) {
      // Guard: context may have been disposed.
      if (!context.mounted) return;

      // Guard: no Overlay available — skip
      // silently instead of crashing.
      if (Overlay.maybeOf(context) == null) return;

      final fToast = FToast()..init(context);
      fToast.showToast(
        positionedToastBuilder:
            (context, child, gravity) => Positioned(
          top: AppDimens.sizeSmall.height,
          right: AppDimens.sizeSmall.width,
          child: child,
        ),
        child: ToastContext.switchToast(
          context,
          type,
          message,
        ),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration:
            const Duration(seconds: 2),
      );
    });
  }
}

/// App-level toast facade used by feature modules.
///
/// This helper ensures toasts are shown on the root
/// navigator context when available, so they work
/// reliably from nested navigators.
final class AppToast {
  const AppToast._();

  static void success(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      type: ToastType.success,
      message: message,
    );
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      type: ToastType.error,
      message: message,
    );
  }

  static void warning(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      type: ToastType.warning,
      message: message,
    );
  }

  static void info(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      type: ToastType.info,
      message: message,
    );
  }

  static void _show(
    BuildContext context, {
    required ToastType type,
    required String message,
  }) {
    final rootContext =
        Navigator.maybeOf(
          context,
          rootNavigator: true,
        )?.context;
    final targetContext = rootContext ?? context;
    if (!targetContext.mounted) return;
    ToastContext.showToast(targetContext, type, message);
  }
}
