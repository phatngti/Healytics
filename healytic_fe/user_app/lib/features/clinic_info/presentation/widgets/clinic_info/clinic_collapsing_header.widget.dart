import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Flexible space content for the clinic profile
/// collapsing toolbar.
///
/// Animates cover image parallax, logo scale, and
/// info text opacity based on the scroll-driven
/// [collapseProgress] (0.0 = expanded, 1.0 = collapsed).
class ClinicCollapsingHeader extends StatelessWidget {
  const ClinicCollapsingHeader({
    super.key,
    required this.clinic,
    required this.collapseProgress,
    required this.expandedHeight,
  });

  /// Full clinic entity for display data.
  final ClinicInfoEntity clinic;

  /// 0.0 = fully expanded, 1.0 = fully collapsed.
  final double collapseProgress;

  /// The total expanded height of the SliverAppBar.
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = AppDimens.horizontalPadding(context);

    // Content fades out faster than the cover image
    // so text disappears before the image is gone.
    final contentOpacity = (1.0 - collapseProgress * 2.5).clamp(0.0, 1.0);

    // Responsive avatar size and overlap
    final avatarSize = AppDimens.adaptive(
      context,
      small: 64.0,
      medium: 72.0,
      large: 80.0,
    );
    final topOverlap = avatarSize / 2;

    // Cover image height based on 21:9 aspect ratio.
    final coverHeight = screenWidth * 9 / 21;

    // Parallax offset: image scrolls at 40% speed.
    final parallaxOffset = collapseProgress * coverHeight * 0.4;

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background (surface color) ──
          Positioned.fill(child: Container(color: colorScheme.surface)),

          // ── Cover image with parallax ──
          Positioned(
            top: -parallaxOffset,
            left: 0,
            right: 0,
            height: coverHeight,
            child: _CoverImage(
              imageUrl: clinic.coverImageUrl,
              fallbackColor: colorScheme.surfaceContainerHighest,
            ),
          ),

          // ── Logo + name + address + stats ──
          if (contentOpacity > 0)
            Positioned(
              top: coverHeight - topOverlap + 10,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: contentOpacity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LogoNameRow(
                        name: clinic.name,
                        address: clinic.address ?? '',
                        logoImageUrl: clinic.logoImageUrl,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        avatarSize: avatarSize,
                      ),
                      AppDimens.verticalSmall,
                      _StatsRow(
                        reviewsLabel: clinic.reviewsLabel,
                        followersLabel: clinic.followersLabel,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Cover image with optional network source and
/// solid fallback color.
class _CoverImage extends StatelessWidget {
  const _CoverImage({this.imageUrl, required this.fallbackColor});

  final String? imageUrl;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return NetworkImageAuto(imageUrl: imageUrl!, fit: BoxFit.cover);
    }
    return Container(color: fallbackColor);
  }
}

/// Logo avatar overlapping the cover, plus clinic
/// name, verified badge, and address row.
class _LogoNameRow extends StatelessWidget {
  const _LogoNameRow({
    required this.name,
    required this.address,
    this.logoImageUrl,
    required this.colorScheme,
    required this.textTheme,
    required this.avatarSize,
  });

  final String name;
  final String address;
  final String? logoImageUrl;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Avatar with white border
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.surface,
              width: AppDimens.spaceXs,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: AppDimens.spaceSm,
              ),
            ],
          ),
          child: AvatarImage(
            name: name,
            imageUrl: logoImageUrl,
            radius: (avatarSize - AppDimens.spaceXs * 2) / 2,
          ),
        ),
        AppDimens.horizontalMediumSmall,
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppDimens.spaceXs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + verified
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppDimens.horizontalExtraSmall,
                    Icon(
                      Icons.verified,
                      size: AppDimens.iconSmMd,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
                AppDimens.spaceXxs.verticalSpace,
                // Address
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: AppDimens.iconXs,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    AppDimens.spaceXxs.horizontalSpace,
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Rating, reviews, followers row with Follow and
/// Chat action buttons.
class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.reviewsLabel,
    required this.followersLabel,
    required this.colorScheme,
    required this.textTheme,
  });

  final String reviewsLabel;
  final String followersLabel;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimens.spaceXs),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: reviewsLabel,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' Reviews • ',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextSpan(
                    text: followersLabel,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' Followers',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _CompactFollowButton(colorScheme: colorScheme, textTheme: textTheme),
          AppDimens.horizontalSmall,
          _CompactChatButton(colorScheme: colorScheme, textTheme: textTheme),
        ],
      ),
    );
  }
}

/// Compact Follow button for the collapsing header.
class _CompactFollowButton extends StatelessWidget {
  const _CompactFollowButton({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSm,
        ),

        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: const Text('Follow'),
    );
  }
}

/// Compact Chat button for the collapsing header.
class _CompactChatButton extends StatelessWidget {
  const _CompactChatButton({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSm,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: colorScheme.primary),
        textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      icon: Icon(
        Icons.chat_bubble_outline,
        size: AppDimens.iconXs,
        color: colorScheme.primary,
      ),
      label: Text(
        'Chat',
        style: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
