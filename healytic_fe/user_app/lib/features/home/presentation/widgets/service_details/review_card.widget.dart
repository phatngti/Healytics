import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Individual review card with avatar, metadata, text, and
/// optional image attachments.
///
/// Shared between [ReviewsSection] (preview) and the full
/// reviews page.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + name + date ──
          _ReviewHeader(
            review: review,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
          AppDimens.verticalMediumSmall,

          // ── Review text ──
          Text(
            'Review: Good, ${review.text}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          // ── Attached images ──
          if (review.imageUrls.isNotEmpty) ...[
            AppDimens.verticalMediumSmall,
            _ReviewImages(imageUrls: review.imageUrls),
          ],
        ],
      ),
    );
  }
}

/// Avatar + reviewer name/status/stars on the left, date on
/// the right.
class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        ClipOval(
          child: SizedBox(
            width: AppDimens.ctaButtonMd,
            height: AppDimens.ctaButtonMd,
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

        // Name + status + stars
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
              AppDimens.verticalExtraSmall,
              Row(
                children: [
                  _StatusBadge(
                    status: review.status,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  AppDimens.horizontalSmall,
                  _StarRow(rating: review.rating),
                ],
              ),
            ],
          ),
        ),

        // Date
        Text(
          _formatDate(review.date),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('hh:mm a MM/dd/yyyy').format(date);
  }
}

/// Small green badge showing the review status.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.colorScheme,
    required this.textTheme,
  });

  final String status;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  /// Light-theme background for the badge.
  static const _bgColor = Color(0xFFDCFCE7);

  /// Foreground green for light theme text.
  static const _fgColor = Color(0xFF15803D);

  /// Dark-theme text color.
  static const _fgColorDark = Color(0xFF4ADE80);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXs + 2,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: isDark ? _fgColor.withValues(alpha: 0.15) : _bgColor,
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Text(
        status,
        style: textTheme.labelSmall?.copyWith(
          color: isDark ? _fgColorDark : _fgColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Horizontal row of filled star icons capped at 5.
class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rating.clamp(0, 5),
        (_) => const Icon(Icons.star, color: Color(0xFFFBBF24), size: 12),
      ),
    );
  }
}

/// Horizontal scrollable row of attached review images.
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
