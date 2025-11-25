import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/theme/app_theme.dart';
import 'package:user_app/utils/demensions.dart';

enum ToastType { success, error, warning, info }

class ToastContext {
  static Widget switchToast(
    BuildContext context,
    ToastType type,
    String message,
  ) {
    final icon = switch (type) {
      ToastType.success => Icons.check,
      ToastType.error => Icons.error,
      ToastType.warning => Icons.warning,
      ToastType.info => Icons.info,
    };

    final iconColor = switch (type) {
      ToastType.success => Theme.of(
        context,
      ).extension<SemanticColors>()?.onSuccess,
      ToastType.error => Theme.of(context).extension<SemanticColors>()?.onError,
      ToastType.warning => Theme.of(
        context,
      ).extension<SemanticColors>()?.onWarning,
      ToastType.info => Theme.of(context).extension<SemanticColors>()?.onInfo,
    };

    final color = switch (type) {
      ToastType.success => Theme.of(
        context,
      ).extension<SemanticColors>()?.onSuccessContainer,
      ToastType.error => Theme.of(
        context,
      ).extension<SemanticColors>()?.onErrorContainer,
      ToastType.warning => Theme.of(
        context,
      ).extension<SemanticColors>()?.onWarningContainer,
      ToastType.info => Theme.of(
        context,
      ).extension<SemanticColors>()?.onInfoContainer,
    };

    final textStyle = switch (type) {
      ToastType.success => Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).extension<SemanticColors>()?.onSuccess,
      ),
      ToastType.error => Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).extension<SemanticColors>()?.onError,
      ),
      ToastType.warning => Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).extension<SemanticColors>()?.onWarning,
      ),
      ToastType.info => Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).extension<SemanticColors>()?.onInfo,
      ),
    };

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        borderRadius: AppDimens.radiusSmall,
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          AppDimens.horizontalSmall,
          Expanded(
            child: Text(
              message,
              style: textStyle?.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  static showToast(BuildContext context, ToastType type, String message) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: ToastContext.switchToast(context, type, message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
    );
  }
}
