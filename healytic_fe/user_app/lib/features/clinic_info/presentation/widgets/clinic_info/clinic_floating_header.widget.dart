import 'dart:ui';

import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

/// Floating glass header bar that transitions from
/// transparent to blurred as the user scrolls past
/// the hero image area.
///
/// Shows the clinic name + mini avatar when
/// [showTitle] is true (collapsed state).
class ClinicFloatingHeader extends StatelessWidget {
  const ClinicFloatingHeader({
    super.key,
    required this.clinicName,
    required this.logoUrl,
    required this.showBlur,
    required this.onBack,
    required this.onShare,
    required this.onMore,
  });

  /// Clinic name shown in collapsed state.
  final String clinicName;

  /// Clinic logo URL for the mini avatar.
  final String? logoUrl;

  /// Whether to show blur + title (collapsed).
  final ValueNotifier<bool> showBlur;

  /// Back navigation callback.
  final VoidCallback onBack;

  /// Share action callback.
  final VoidCallback onShare;

  /// More-menu callback.
  final VoidCallback onMore;

  /// Cached identity filter to avoid allocation
  /// when blur is off.
  static final _noBlur = ImageFilter.blur();

  /// Active blur filter for the header backdrop.
  static final _activeBlur = ImageFilter.blur(sigmaX: 12, sigmaY: 12);

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return ValueListenableBuilder<bool>(
      valueListenable: showBlur,
      builder: (context, blur, child) {
        return ClipRect(
          child: BackdropFilter(
            filter: blur ? _activeBlur : _noBlur,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.fromLTRB(
                AppDimens.spaceSm,
                topPad + AppDimens.spaceXs,
                AppDimens.spaceSm,
                AppDimens.spaceXs,
              ),
              color: blur ? const Color(0x33000000) : Colors.transparent,
              child: Row(
                children: [
                  _GlassCircleButton(icon: Icons.arrow_back, onTap: onBack),
                  // Collapsed title with avatar
                  if (blur) ...[
                    AppDimens.horizontalSmall,
                    _CollapsedTitle(name: clinicName, logoUrl: logoUrl),
                  ] else
                    const Spacer(),
                  AppDimens.horizontalSmall,
                  _GlassCircleButton(
                    icon: Icons.share,
                    label: 'Share clinic',
                    onTap: onShare,
                  ),
                  const SizedBox(width: 8),
                  _GlassCircleButton(
                    icon: Icons.more_vert,
                    label: 'More clinic actions',
                    onTap: onMore,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Mini avatar + clinic name shown in the collapsed
/// app bar state.
class _CollapsedTitle extends StatelessWidget {
  const _CollapsedTitle({required this.name, required this.logoUrl});

  final String name;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Row(
        children: [
          AvatarImage(name: name, imageUrl: logoUrl, radius: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular icon button with semi-transparent
/// dark background for the floating header.
///
/// Uses the parent header's [BackdropFilter] for
/// the blur effect — no individual blur needed.
class _GlassCircleButton extends StatelessWidget {
  const _GlassCircleButton({required this.icon, this.label, this.onTap});

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}
