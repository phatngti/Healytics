import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Sticky bottom action bar with Call, Map, and
/// "Book Consultation" CTA.
class ClinicBottomBar extends StatelessWidget {
  const ClinicBottomBar({super.key, this.onCall, this.onMap, this.onBook});

  final VoidCallback? onCall;
  final VoidCallback? onMap;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppDimens.spaceXxl,
            AppDimens.spaceMd,
            AppDimens.spaceXxl,
            bottomPad + AppDimens.spaceMd,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surface.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              _BottomIconAction(icon: Icons.call, label: 'Call', onTap: onCall),
              AppDimens.horizontalMediumSmall,
              _BottomIconAction(icon: Icons.map, label: 'Map', onTap: onMap),
              AppDimens.horizontalMediumSmall,
              Expanded(
                child: Material(
                  color: colorScheme.primary,
                  borderRadius: AppDimens.radiusMediumSmall,
                  elevation: 4,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  child: InkWell(
                    onTap: onBook,
                    borderRadius: AppDimens.radiusMediumSmall,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'BOOK CONSULTATION',
                        textAlign: TextAlign.center,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomIconAction extends StatelessWidget {
  const _BottomIconAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: colorScheme.primary),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
