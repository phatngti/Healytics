import 'package:flutter/material.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Hero card showing the selected specialist,
/// their role, date, and time.
///
/// Employee-booking-specific clone — not shared
/// with the standard booking flow.
/// Service details are displayed in a separate
/// [ServiceDetailsCard] below this widget.
class SpecialistServiceCard extends StatelessWidget {
  const SpecialistServiceCard({
    super.key,
    required this.specialistName,
    required this.formattedDate,
    required this.formattedTime,
    this.avatarUrl,
    this.specialty,
  });

  /// Display name (e.g. "Dr. James Wilson").
  final String specialistName;

  /// Pre-formatted date string.
  final String formattedDate;

  /// Pre-formatted time string.
  final String formattedTime;

  /// Optional avatar URL for the specialist.
  final String? avatarUrl;

  /// Role/specialty label (e.g. "Massage Therapist").
  final String? specialty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad = AppDimens.cardPadding(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          AppDimens.cardRadius(context),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _SpecialistRow(
            name: specialistName,
            avatarUrl: avatarUrl,
            specialty: specialty,
          ),
          SizedBox(height: AppDimens.spaceLg),
          _DateTimeGrid(
            formattedDate: formattedDate,
            formattedTime: formattedTime,
          ),
        ],
      ),
    );
  }
}

/// Row with specialist avatar, name, and role.
class _SpecialistRow extends StatelessWidget {
  const _SpecialistRow({
    required this.name,
    this.avatarUrl,
    this.specialty,
  });

  final String name;
  final String? avatarUrl;
  final String? specialty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _AvatarWithBadge(
          avatarUrl: avatarUrl,
          name: name,
        ),
        SizedBox(width: AppDimens.spaceLg),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (specialty != null &&
                  specialty!.isNotEmpty) ...
                [
                  SizedBox(
                    height: AppDimens.spaceXxs,
                  ),
                  Text(
                    specialty!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Circular avatar with a verified badge overlay.
///
/// Handles SVG URLs (e.g. DiceBear) and raster
/// URLs via [NetworkImageAuto].
class _AvatarWithBadge extends StatelessWidget {
  const _AvatarWithBadge({
    this.avatarUrl,
    required this.name,
  });

  final String? avatarUrl;
  final String name;

  Widget _buildFallback(
    ColorScheme colorScheme,
    double size,
  ) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor:
          colorScheme.primaryContainer,
      child: Text(
        name.isNotEmpty
            ? name[0].toUpperCase()
            : '?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    const size = 56.0;
    final hasUrl =
        avatarUrl != null &&
        avatarUrl!.isNotEmpty;

    return SizedBox(
      width: size + 6,
      height: size + 6,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.5),
                width:
                    AppDimens.borderWidthThick,
              ),
            ),
            child: ClipOval(
              child: hasUrl
                  ? NetworkImageAuto(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                      placeholder: (_) =>
                          _buildFallback(
                        colorScheme,
                        size,
                      ),
                      errorWidget: (_) =>
                          _buildFallback(
                        colorScheme,
                        size,
                      ),
                    )
                  : _buildFallback(
                      colorScheme,
                      size,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: AppDimens.iconMd,
              height: AppDimens.iconMd,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width:
                      AppDimens.borderWidthThick,
                ),
              ),
              child: Icon(
                Symbols.verified,
                size: AppDimens.iconXs,
                fill: 1,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2-column grid showing date and time.
class _DateTimeGrid extends StatelessWidget {
  const _DateTimeGrid({
    required this.formattedDate,
    required this.formattedTime,
  });

  final String formattedDate;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: AppDimens.spaceMd,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant
                .withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoChip(
              icon: Symbols.calendar_today,
              label: formattedDate,
            ),
          ),
          SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: _InfoChip(
              icon: Symbols.schedule,
              label: formattedTime,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small icon + label chip for date/time display.
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconMd,
          color: colorScheme.primary,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
