import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';

import 'package:user_app/theme/app_theme.dart';

/// Telegram-style chat header: clean, minimal, with a
/// frosted-glass backdrop, avatar, name, online status,
/// and action buttons.
///
/// Implements [PreferredSizeWidget] so it can be used as
/// the [Scaffold.appBar] directly.
class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatHeader({super.key});

  static const String _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/'
      'AB6AXuCJHh7ofPHfQIvyav5jmHIiQwkzTq7FygWXvko'
      'jyZuRKh1XgzscOKkTR1TVjR2Y8SL7rI8s-ixuU-MUUU'
      'wKKobjK89HNWKjUppdrQI4clgq-qskHIMibxW5sKfNH5'
      'mjH0ybgjZjC0wjPC0U0xtE3DSS-neu5wAUTVHKpMRJjv'
      'W_JI5FSZOgaQs0asPD4UqktwyMsUdt-vVILGiYc16YWn'
      'pQI49H8s1PKbkpWAmbSh_BqRH5sHW_5YHBzv-OC2j_F4'
      'uqMmjS-z1aDn5E';

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                // Back
                AppButton(
                  buttonType: ButtonType.text,
                  onPressed: () => Navigator.of(context).pop(),
                  primaryColor: colorScheme.primary,
                  customStyle: TextButton.styleFrom(
                    padding: EdgeInsets.all(AppDimens.spaceSm),
                    minimumSize: Size(
                      AppDimens.ctaButtonMd,
                      AppDimens.ctaButtonMd,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: colorScheme.primary,
                    size: AppDimens.iconMd,
                  ),
                ),

                // Avatar
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: const NetworkImage(_avatarUrl),
                        onBackgroundImageError: (_, __) {},
                        child: Icon(
                          Icons.smart_toy_outlined,
                          size: AppDimens.iconMd,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                semanticColors?.success ?? colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppDimens.spaceSm),

                // Name + status
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. AI Assistant',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'online',
                        style: textTheme.bodySmall?.copyWith(
                          color: semanticColors?.success ?? colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                AppButton(
                  buttonType: ButtonType.text,
                  onPressed: () {},
                  primaryColor: colorScheme.primary,
                  customStyle: TextButton.styleFrom(
                    padding: EdgeInsets.all(AppDimens.spaceSm),
                    minimumSize: Size(
                      AppDimens.ctaButtonMd,
                      AppDimens.ctaButtonMd,
                    ),
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
        ),
      ),
    );
  }
}
