import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/images/avatar.dart';

/// Chat header for partner conversations.
///
/// Frosted-glass style matching the existing AI chat
/// header, but parameterized with partner info.
class PartnerChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String partnerName;
  final String? partnerAvatar;

  const PartnerChatHeader({
    super.key,
    required this.partnerName,
    this.partnerAvatar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                // Back button
                AppButton(
                  buttonType: ButtonType.text,
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
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

                // Partner avatar
                AvatarImage(
                  name: partnerName,
                  imageUrl: partnerAvatar,
                  radius: 20,
                ),
                SizedBox(width: AppDimens.spaceSm),

                // Partner name
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partnerName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Health Partner',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // More options
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
