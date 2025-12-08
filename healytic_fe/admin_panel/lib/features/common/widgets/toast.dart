import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';

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
      constraints: BoxConstraints(
        maxWidth: DeviceUtils.getScreenWidth(context) * 0.3,
      ),
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: color,
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
              style: textStyle?.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
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
      positionedToastBuilder: (context, child, gravity) => Positioned(
        top: AppDimens.sizeSmall.height,
        right: AppDimens.sizeSmall.width,
        child: child,
      ),
      child: ToastContext.switchToast(context, type, message),
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
