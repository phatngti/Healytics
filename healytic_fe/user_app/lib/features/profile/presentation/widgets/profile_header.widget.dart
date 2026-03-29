import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Profile identity section: circular avatar with
/// verified badge, user name, email, and edit button.
///
/// Mirrors the "Header Section: Profile Identity"
/// from the HTML design spec.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.displayName,
    this.email,
    this.avatarUrl,
    this.onEditProfile,
  });

  /// User's full display name.
  final String displayName;

  /// Optional email address shown below the name.
  final String? email;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Callback when "Edit Profile" is tapped.
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        _AvatarWithBadge(displayName: displayName, avatarUrl: avatarUrl),
        SizedBox(height: AppDimens.spaceXl),
        Text(
          displayName,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        if (email != null) ...[
          SizedBox(height: AppDimens.spaceXs),
          Text(
            email!,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
        SizedBox(height: AppDimens.spaceXl),
        _EditProfileButton(onPressed: onEditProfile),
      ],
    );
  }
}

// ─── Avatar with Verified Badge ─────────────────

class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({required this.displayName, this.avatarUrl});

  final String displayName;
  final String? avatarUrl;

  static const double _avatarRadius = 56.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: _avatarRadius * 2 + 8,
      height: _avatarRadius * 2 + 8,
      child: Stack(
        children: [
          // Outer ring + avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surfaceContainerLow,
                width: AppDimens.borderWidthThick,
              ),
            ),
            child: AvatarImage(
              name: displayName,
              imageUrl: avatarUrl,
              radius: _avatarRadius,
            ),
          ),
          // Verified badge
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Symbols.verified,
                size: AppDimens.iconSm,
                color: colorScheme.onPrimary,
                fill: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Profile Button ────────────────────────

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: const StadiumBorder(),
      ),
      child: Text(
        'Edit Profile',
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
