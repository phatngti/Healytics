import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';

import 'package:user_app/features/employee/'
    'domain/entities/employee_preview.entity.dart';
import 'package:user_app/features/employee/'
    'presentation/providers/'
    'employee_preview_cache.provider.dart';
import 'package:user_app/features/home/'
    'domain/entities/home.entity.dart';
import 'package:user_app/features/home/'
    'presentation/providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_section_header.widget.dart';
import 'package:user_app/router/routes.dart';

/// Horizontally-scrollable list of featured
/// specialists on the home page.
class SpecialistsSection extends ConsumerWidget {
  const SpecialistsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialistsAsync = ref.watch(featuredSpecialistsProvider);
    final titleGap = AppDimens.titleGap(context);
    final cardWidth = AppDimens.widthFraction(context, fraction: 0.4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'Our Specialists',
          onViewAll: () {
            const HomeSpecialistsRoute().push(context);
          },
        ),
        SizedBox(height: titleGap),

        // Specialist list
        SizedBox(
          height: cardWidth * 1.55,
          child: specialistsAsync.when(
            data: (specialists) =>
                _SpecialistList(specialists: specialists, cardWidth: cardWidth),
            loading: () => _LoadingList(cardWidth: cardWidth),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Horizontal specialist list
// ─────────────────────────────────────────────────────

class _SpecialistList extends StatelessWidget {
  final List<HomeSpecialist> specialists;
  final double cardWidth;

  const _SpecialistList({required this.specialists, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: specialists.length,
      separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceMd),
      itemBuilder: (_, index) =>
          _SpecialistCard(specialist: specialists[index], width: cardWidth),
    );
  }
}

// ─────────────────────────────────────────────────────
// Shimmer-style loading placeholders
// ─────────────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  final double cardWidth;

  const _LoadingList({required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.colorScheme.surfaceContainerHighest;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceMd),
      itemBuilder: (_, __) => Container(
        width: cardWidth,
        padding: EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: AppDimens.borderWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
              ),
            ),
            SizedBox(height: AppDimens.spaceSm),
            // Name placeholder
            Container(
              height: AppDimens.spaceMd,
              width: cardWidth * 0.7,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: AppDimens.radiusExtraSmall,
              ),
            ),
            SizedBox(height: AppDimens.spaceXs),
            // Specialty placeholder
            Container(
              height: AppDimens.spaceSm,
              width: cardWidth * 0.5,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: AppDimens.radiusExtraSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Individual specialist card
// ─────────────────────────────────────────────────────

class _SpecialistCard extends ConsumerWidget {
  final HomeSpecialist specialist;
  final double width;

  const _SpecialistCard({required this.specialist, required this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        ref
            .read(employeePreviewCacheProvider.notifier)
            .seed(
              EmployeePreview(
                id: specialist.id,
                name: specialist.name,
                avatarUrl: specialist.avatarUrl,
                specialty: specialist.specialty,
                rating: specialist.rating,
                reviewCount: specialist.soldCount,
              ),
            );
        EmployeeDetailRoute(employeeId: specialist.id).push<void>(context);
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: colorScheme.outlineVariant,
            width: AppDimens.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: AppDimens.spaceXs,
              offset: Offset(0, AppDimens.spaceXxs),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar image / fallback
            AspectRatio(
              aspectRatio: 1,
              child: _SpecialistAvatar(avatarUrl: specialist.avatarUrl),
            ),
            SizedBox(height: AppDimens.spaceSm),

            // Name
            Text(
              specialist.name,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppDimens.spaceXxs),

            // Specialty
            Text(
              specialist.specialty,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // Rating + sold row
            _InfoRow(
              icon: Symbols.star,
              iconColor: colorScheme.primary,
              text:
                  '${specialist.rating}'
                  ' · ${specialist.soldCount} sold',
            ),
            SizedBox(height: AppDimens.spaceXxs),

            // Clinic info
            if (specialist.clinicName.isNotEmpty)
              _InfoRow(
                icon: Symbols.location_on,
                iconColor: colorScheme.onSurfaceVariant,
                text: specialist.clinicName,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Avatar with network image support
// ─────────────────────────────────────────────────────

class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasUrl
          ? NetworkImageAuto(
              imageUrl: avatarUrl!,
              fit: BoxFit.cover,
              placeholder: (_) => const _AvatarFallback(),
              errorWidget: (_) => const _AvatarFallback(),
            )
          : const _AvatarFallback(),
    );
  }
}

/// Person icon fallback for specialist avatar.
class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Icon(
        Symbols.person,
        size: AppDimens.iconXxl,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Compact icon + text info row
// ─────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconSm, color: iconColor),
        SizedBox(width: AppDimens.spaceXs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
