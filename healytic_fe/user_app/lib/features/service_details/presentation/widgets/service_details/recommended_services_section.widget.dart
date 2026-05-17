import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_app/features/service_details/presentation/providers/service_details.provider.dart';
import 'package:user_app/router/routes.dart';

/// Horizontally-scrollable "Recommended Services" carousel.
///
/// Watches [recommendedServicesProvider] for the given
/// [serviceId] and renders nothing when the list is empty.
/// Tapping a card navigates to the service detail screen.
class RecommendedServicesSection extends ConsumerWidget {
  const RecommendedServicesSection({
    super.key,
    required this.serviceId,
    this.onViewAll,
  });

  /// Identifier used to fetch recommended services.
  final String serviceId;

  /// Called when the user taps the "View all" link.
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncServices = ref.watch(
      recommendedServicesProvider(serviceId: serviceId),
    );

    return asyncServices.when(
      loading: SizedBox.shrink,
      error: (_, __) => const SizedBox.shrink(),
      data: (services) {
        if (services.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(onViewAll: onViewAll),
            AppDimens.verticalMedium,
            SizedBox(
              height: _ServiceCard.cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: services.length,
                separatorBuilder: (_, __) =>
                    AppDimens.horizontalMedium,
                itemBuilder: (_, index) {
                  final service = services[index];
                  return _ServiceCard(
                    service: service,
                    onTap: () => ServiceDetailsRoute(
                      serviceId: service.id,
                    ).push(context),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Header row: "Recommended Services" title + "View all".
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({this.onViewAll});

  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Recommended Services',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onViewAll,
          child: Text(
            'View all',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual recommended service card (220 dp wide).
///
/// Layout: rounded image → title → rating row →
/// booked-count + price row.
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, this.onTap});

  final RecommendedServiceEntity service;
  final VoidCallback? onTap;

  /// Fixed card width matching design spec (220 dp).
  static const double cardWidth = 220;

  /// Image height inside the card.
  static const double _imageHeight = 128;

  /// Total card height (image + text rows + padding).
  static const double cardHeight = 250;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusLarge,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            _CoverImage(imageUrl: service.imageUrl, height: _imageHeight),
            const SizedBox(height: AppDimens.spaceMd),

            // Title
            Text(
              service.title,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimens.spaceXs),

            // Rating row
            _RatingRow(
              rating: service.rating,
              reviewLabel: service.reviewLabel,
            ),
            const SizedBox(height: AppDimens.spaceSm),

            // Booked count + price
            _BookedPriceRow(
              bookedLabel: service.bookedLabel,
              price: service.price,
            ),
          ],
        ),
      ),
    );
  }
}

/// Rounded cover image with error fallback.
class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.imageUrl, required this.height});

  final String imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(child: Icon(Icons.broken_image_outlined)),
          ),
        ),
      ),
    );
  }
}

/// Star icon + rating value + review label.
class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewLabel});

  final double rating;
  final String reviewLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const Icon(
          Icons.star,
          size: AppDimens.iconXs,
          color: Color(0xFFFBBF24), // amber-400
        ),
        const SizedBox(width: AppDimens.spaceXxs),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppDimens.spaceXxs),
        Flexible(
          child: Text(
            reviewLabel,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
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

/// Booked count on the left, price on the right.
class _BookedPriceRow extends StatelessWidget {
  const _BookedPriceRow({required this.bookedLabel, required this.price});

  final String bookedLabel;
  final String price;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_added,
              size: 12,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 2),
            Text(
              bookedLabel,
              style: textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Text(
          price,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
