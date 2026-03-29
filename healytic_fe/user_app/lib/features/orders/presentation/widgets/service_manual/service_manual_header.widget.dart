import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Pinned header for the service manual screen.
///
/// Shows a centred title ("Service Manual") with a
/// subtitle combining [serviceName] and [vendorName].
/// Uses a glassmorphism backdrop blur and a thin
/// bottom border.
class ServiceManualHeader extends StatelessWidget {
  const ServiceManualHeader({
    super.key,
    required this.serviceName,
    required this.vendorName,
  });

  /// Display name of the booked service.
  final String serviceName;

  /// Display name of the vendor / spa.
  final String vendorName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: colors.surface.withValues(
        alpha: 0.8,
      ),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Service Manual',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            '$serviceName • $vendorName',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w500,
              letterSpacing: AppDimens.letterSpacingSmall,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: const SizedBox.expand(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          AppDimens.borderWidth,
        ),
        child: Divider(
          height: AppDimens.borderWidth,
          thickness: AppDimens.borderWidth,
          color: colors.outlineVariant.withValues(
            alpha: 0.5,
          ),
        ),
      ),
    );
  }
}
