import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sticky glassmorphism app bar for the service manual
/// screen, showing the service name and vendor.
class ServiceManualHeader extends StatelessWidget {
  const ServiceManualHeader({
    super.key,
    required this.serviceName,
    required this.vendorName,
  });

  /// Name of the service being displayed.
  final String serviceName;

  /// Name of the vendor providing the service.
  final String vendorName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      backgroundColor: colors.surface.withValues(alpha: 0.7),
      surfaceTintColor: colors.surface.withValues(alpha: 0),
      leading: IconButton(
        tooltip: 'Back',
        icon: const Icon(Symbols.arrow_back, size: AppDimens.iconLg),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Column(
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
    );
  }
}
