import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

/// Hero section for the specialist review screen.
///
/// Displays the specialist's avatar with a verified
/// badge, their name, and role/title.
class ReviewSpecialistHero extends StatelessWidget {
  /// Display name of the specialist.
  final String name;

  /// Role or title (e.g. "Doctor or Therapist").
  final String role;

  /// Network URL for the specialist's avatar.
  final String? avatarUrl;

  const ReviewSpecialistHero({
    super.key,
    required this.name,
    required this.role,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(colorScheme),
        AppDimens.verticalMedium,
        _buildName(context, colorScheme),
        AppDimens.verticalExtraSmall,
        _buildRole(context, colorScheme),
      ],
    );
  }

  /// Avatar with verification badge overlay.
  Widget _buildAvatar(ColorScheme colorScheme) {
    return SizedBox(
      width: 136,
      height: 136,
      child: Stack(
        children: [
          // Bordered avatar container
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    colorScheme.surfaceContainerLowest,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface
                      .withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AvatarImage(
              name: name,
              imageUrl: avatarUrl,
              radius: 64,
            ),
          ),
          // Verified badge — bottom-right
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.verified,
                size: 16,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Specialist name heading.
  Widget _buildName(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Text(
      name,
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
      textAlign: TextAlign.center,
    );
  }

  /// Specialist role subtitle.
  Widget _buildRole(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Text(
      role,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
      textAlign: TextAlign.center,
    );
  }
}
