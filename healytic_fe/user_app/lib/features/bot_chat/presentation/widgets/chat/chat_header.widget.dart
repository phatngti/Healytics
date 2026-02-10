import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';

/// Chat header bar displaying the AI doctor avatar, name, online
/// status indicator, and an overflow menu button.
///
/// Implements [PreferredSizeWidget] so it can be used as the
/// [Scaffold.appBar] directly. All dimensions use [AppDimens]
/// responsive helpers for consistent scaling across screen sizes.
class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeader({super.key});

  /// Header height adapts per mobile tier via [AppDimens.adaptive].
  static double _headerHeight(BuildContext context) =>
      AppDimens.adaptive(context, small: 64, medium: 68, large: 72);

  static const String _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCJHh7ofPHfQIvyav5jmHIiQwkzTq7FygWXvkojyZuRKh1XgzscOKkTR1TVjR2Y8SL7rI8s-ixuU-MUUUwKKobjK89HNWKjUppdrQI4clgq-qskHIMibxW5sKfNH5mjH0ybgjZjC0wjPC0U0xtE3DSS-neu5wAUTVHKpMRJjvW_JI5FSZOgaQs0asPD4UqktwyMsUdt-vVILGiYc16YWnpQI49H8s1PKbkpWAmbSh_BqRH5sHW_5YHBzv-OC2j_F4uqMmjS-z1aDn5E';

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPadding = AppDimens.horizontalPadding(context);

    return SafeArea(
      bottom: false,
      child: Container(
        height: _headerHeight(context),
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: AppDimens.borderWidth,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: AppDimens.spaceXs,
              offset: Offset(0, AppDimens.spaceXxs),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- Avatar with online dot ---
            _AvatarWithStatus(imageUrl: _avatarUrl, colorScheme: colorScheme),
            SizedBox(width: AppDimens.spaceMd),

            // --- Name + Status ---
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. AI Assistant',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: AppDimens.fontWeightBold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimens.spaceXxs),
                  Row(
                    children: [
                      _PulsingDot(color: colorScheme.primary),
                      SizedBox(width: AppDimens.spaceXs),
                      Text(
                        'Online Now',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: AppDimens.fontWeightSemiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- More button — uses AppButton.text ---
            AppButton(
              buttonType: ButtonType.text,
              onPressed: () {},
              primaryColor: colorScheme.primary,
              customStyle: TextButton.styleFrom(
                padding: EdgeInsets.all(AppDimens.spaceSm),
                minimumSize: Size(AppDimens.ctaButtonMd, AppDimens.ctaButtonMd),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
              ),
              child: Icon(
                Icons.more_vert,
                color: colorScheme.primary,
                size: AppDimens.iconLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Avatar image with a green online-status dot positioned at the
/// bottom-right corner.
class _AvatarWithStatus extends StatelessWidget {
  final String imageUrl;
  final ColorScheme colorScheme;

  const _AvatarWithStatus({required this.imageUrl, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.avatarMd,
      height: AppDimens.avatarMd,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surface,
                width: AppDimens.borderWidthThick,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: AppDimens.spaceXs,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: AppDimens.avatarMd,
                height: AppDimens.avatarMd,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.smart_toy_outlined,
                    color: colorScheme.onPrimaryContainer,
                    size: AppDimens.iconLg,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: AppDimens.spaceMd,
              height: AppDimens.spaceMd,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: AppDimens.borderWidthThick,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small pulsing green circle used as an "online" indicator
/// next to the status text.
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: AppDimens.spaceXs + AppDimens.spaceXxs,
        height: AppDimens.spaceXs + AppDimens.spaceXxs,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.5 + 0.5 * _controller.value),
        ),
      ),
    );
  }
}
