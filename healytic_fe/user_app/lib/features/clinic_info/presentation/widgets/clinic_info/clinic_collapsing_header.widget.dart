import 'dart:math' as math;

import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Shared measurements for the collapsing clinic header.
///
/// [SliverAppBar.expandedHeight] excludes the top safe-area inset, while its
/// flexible space receives a max height that includes it. Keeping both values
/// here prevents the header body from being clipped differently per device.
class ClinicCollapsingHeaderLayout {
  const ClinicCollapsingHeaderLayout({
    required this.coverHeight,
    required this.avatarSize,
    required this.contentTop,
    required this.expandedHeight,
    required this.blurThreshold,
  });

  static const _coverAspectRatio = 9 / 21;
  static const _floatingButtonSize = 36.0;
  static const _statsRowHeight = 40.0;
  static const _minExpandedHeight = kToolbarHeight + 120;

  final double coverHeight;
  final double avatarSize;
  final double contentTop;
  final double expandedHeight;
  final double blurThreshold;

  static ClinicCollapsingHeaderLayout of(
    BuildContext context, {
    String name = '',
    String address = '',
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final topInset = mediaQuery.padding.top;
    final textTheme = Theme.of(context).textTheme;
    final nameStyle = _nameTextStyle(context, textTheme);
    final addressStyle = _addressTextStyle(context, textTheme);
    final avatarSize = AppDimens.adaptive(
      context,
      small: 64.0,
      medium: 76.0,
      large: 84.0,
    );
    final profileTopGap = _profileTopGap(context);
    final textTopInset = _textTopInset(
      context,
      avatarSize: avatarSize,
      profileTopGap: profileTopGap,
    );
    final avatarTextGap = _avatarTextGap(context);
    final avatarTopOverlap = avatarSize / 2;
    final coverHeight = math.max(
      screenWidth * _coverAspectRatio,
      topInset + _floatingButtonSize + AppDimens.spaceXxl,
    );
    final hPad = AppDimens.horizontalPadding(context);
    final textColumnWidth = math.max(
      0.0,
      screenWidth - hPad * 2 - avatarSize - avatarTextGap,
    );
    final addressTextWidth = math.max(
      0.0,
      textColumnWidth - AppDimens.iconXs - AppDimens.spaceXxs,
    );
    final textScaler = mediaQuery.textScaler;
    final nameHeight = _measureTextHeight(
      name,
      style: nameStyle,
      maxWidth: textColumnWidth,
      textScaler: textScaler,
      maxLines: 1,
    );
    final addressHeight = _measureTextHeight(
      address,
      style: addressStyle,
      maxWidth: addressTextWidth,
      textScaler: textScaler,
    );
    final profileRowHeight = math.max(
      avatarSize,
      textTopInset + nameHeight + AppDimens.spaceXxs + addressHeight,
    );
    final contentTop = coverHeight - avatarTopOverlap + profileTopGap;
    final paintedHeight =
        contentTop +
        profileRowHeight +
        AppDimens.spaceSm +
        _statsRowHeight +
        AppDimens.spaceMd;

    return ClinicCollapsingHeaderLayout(
      coverHeight: coverHeight,
      avatarSize: avatarSize,
      contentTop: contentTop,
      expandedHeight: (paintedHeight - topInset)
          .clamp(_minExpandedHeight, double.infinity)
          .toDouble(),
      blurThreshold: coverHeight * 0.5,
    );
  }

  static double _measureTextHeight(
    String text, {
    required TextStyle? style,
    required double maxWidth,
    required TextScaler textScaler,
    int? maxLines,
  }) {
    if (maxWidth <= 0) return 0;
    final painter = TextPainter(
      text: TextSpan(text: text.isEmpty ? ' ' : text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);
    return painter.height;
  }

  static double _avatarTextGap(BuildContext context) {
    return AppDimens.adaptive(context, small: 10.0, medium: 12.0, large: 14.0);
  }

  static double _textTopInset(
    BuildContext context, {
    required double avatarSize,
    required double profileTopGap,
  }) {
    final belowCoverGap = AppDimens.adaptive(
      context,
      small: 4.0,
      medium: 6.0,
      large: 8.0,
    );
    return math.max(0.0, avatarSize / 2 - profileTopGap + belowCoverGap);
  }

  static double _profileTopGap(BuildContext context) {
    return AppDimens.adaptive(context, small: 14.0, medium: 18.0, large: 22.0);
  }

  static TextStyle? _nameTextStyle(BuildContext context, TextTheme textTheme) {
    return textTheme.titleMedium?.copyWith(
      fontSize: AppDimens.adaptive(
        context,
        small: 15.0,
        medium: 16.0,
        large: 18.0,
      ),
      height: 1.15,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle? _addressTextStyle(
    BuildContext context,
    TextTheme textTheme,
  ) {
    return textTheme.labelSmall?.copyWith(
      fontSize: AppDimens.adaptive(
        context,
        small: 11.0,
        medium: 12.0,
        large: 13.0,
      ),
      height: 1.25,
    );
  }
}

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
    this.onFollow,
    this.onChat,
  });

  /// Full clinic entity for display data.
  final ClinicInfoEntity clinic;

  /// 0.0 = fully expanded, 1.0 = fully collapsed.
  final double collapseProgress;

  final VoidCallback? onFollow;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);
    final headerLayout = ClinicCollapsingHeaderLayout.of(
      context,
      name: clinic.name,
      address: clinic.address ?? '',
    );

    // Content fades out faster than the cover image
    // so text disappears before the image is gone.
    final contentOpacity = (1.0 - collapseProgress * 2.5).clamp(0.0, 1.0);

    // Parallax offset: image scrolls at 40% speed.
    final parallaxOffset = collapseProgress * headerLayout.coverHeight * 0.4;

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
            height: headerLayout.coverHeight,
            child: _CoverImage(
              imageUrl: clinic.coverImageUrl,
              fallbackColor: colorScheme.surfaceContainerHighest,
            ),
          ),

          // ── Logo + name + address + stats ──
          if (contentOpacity > 0)
            Positioned(
              top: headerLayout.contentTop,
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
                        avatarSize: headerLayout.avatarSize,
                      ),
                      AppDimens.verticalSmall,
                      _StatsRow(
                        reviewsLabel: clinic.reviewsLabel,
                        followersLabel: clinic.followersLabel,
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        isFollowing: clinic.isFollowing,
                        onFollow: onFollow,
                        onChat: onChat,
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
    final nameStyle = ClinicCollapsingHeaderLayout._nameTextStyle(
      context,
      textTheme,
    );
    final addressStyle = ClinicCollapsingHeaderLayout._addressTextStyle(
      context,
      textTheme,
    );
    final avatarTextGap = ClinicCollapsingHeaderLayout._avatarTextGap(context);
    final textTopInset = ClinicCollapsingHeaderLayout._textTopInset(
      context,
      avatarSize: avatarSize,
      profileTopGap: ClinicCollapsingHeaderLayout._profileTopGap(context),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(width: avatarTextGap),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: textTopInset),
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
                        style: nameStyle,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        softWrap: true,
                        style: addressStyle?.copyWith(
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
    required this.isFollowing,
    this.onFollow,
    this.onChat,
  });

  final String reviewsLabel;
  final String followersLabel;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onChat;

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _CompactFollowButton(
            colorScheme: colorScheme,
            textTheme: textTheme,
            isFollowing: isFollowing,
            onPressed: onFollow,
          ),
          AppDimens.horizontalSmall,
          _CompactChatButton(
            colorScheme: colorScheme,
            textTheme: textTheme,
            onPressed: onChat,
          ),
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
    required this.isFollowing,
    this.onPressed,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isFollowing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSm,
        ),

        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: Text(isFollowing ? 'Following' : 'Follow'),
    );
  }
}

/// Compact Chat button for the collapsing header.
class _CompactChatButton extends StatelessWidget {
  const _CompactChatButton({
    required this.colorScheme,
    required this.textTheme,
    this.onPressed,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
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
