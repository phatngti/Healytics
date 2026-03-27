import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Flat review card matching Airbnb-style design.
///
/// Shows avatar + name/location, star/date/service
/// metadata, review text, and optional images.
///
/// Shared between [ReviewsSection] and the full
/// reviews page.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Avatar + name + location ──
        _ReviewerInfo(
          review: review,
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        AppDimens.verticalMediumSmall,

        // ── Stars + date + service ──
        _MetadataRow(
          review: review,
          textTheme: textTheme,
          colorScheme: colorScheme,
        ),
        AppDimens.verticalSmall,

        // ── Review text ──
        Text(
          review.text,
          style: textTheme.bodyMedium?.copyWith(height: 1.6),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),

        // ── Optional images ──
        if (review.imageUrls.isNotEmpty) ...[
          AppDimens.verticalMediumSmall,
          _ReviewImages(imageUrls: review.imageUrls),
        ],
      ],
    );
  }
}

/// Avatar circle + reviewer name + location.
class _ReviewerInfo extends StatelessWidget {
  const _ReviewerInfo({
    required this.review,
    required this.textTheme,
    required this.colorScheme,
  });

  final ReviewEntity review;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        ClipOval(
          child: SizedBox(
            width: AppDimens.avatarMd,
            height: AppDimens.avatarMd,
            child: Image.network(
              review.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ),
        AppDimens.horizontalMediumSmall,

        // Name + location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.reviewerName,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (review.location.isNotEmpty) ...[
                AppDimens.verticalExtraSmall,
                Text(
                  review.location,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Stars + dot + date + dot + service name.
class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.review,
    required this.textTheme,
    required this.colorScheme,
  });

  final ReviewEntity review;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stars
        _StarRow(rating: review.rating),

        // Dot separator
        _dot(),

        // Date
        Text(
          _formatDate(review.date),
          style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
        ),

        // Service name
        if (review.serviceName.isNotEmpty) ...[
          _dot(),
          Flexible(
            child: Text(
              review.serviceName,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      child: Text(
        '•',
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.outlineVariant,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }
}

/// Horizontal row of filled star icons (1–5).
class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rating.clamp(0, 5),
        (_) => Icon(Icons.star, color: color, size: AppDimens.iconXs),
      ),
    );
  }
}

/// Horizontal scrollable row of attached images.
class _ReviewImages extends StatelessWidget {
  const _ReviewImages({required this.imageUrls});

  final List<String> imageUrls;

  static const double _imageSize = 96;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _imageSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => AppDimens.horizontalMediumSmall,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: AppDimens.radiusMediumSmall,
            child: SizedBox(
              width: _imageSize,
              height: _imageSize,
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.broken_image_outlined)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
