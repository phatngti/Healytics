import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';
import 'package:user_app/theme/app_theme.dart';

/// A single review card displaying the reviewer's
/// avatar, name, rating, service badge, review text,
/// optional media grid, and optional clinic response.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final ClinicReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.horizontalPadding(context),
        vertical: AppDimens.spaceLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──
          _ReviewerAvatar(
            initial: review.reviewerInitial,
            hasBadge: review.memberBadge != null,
          ),
          const SizedBox(width: AppDimens.spaceMd),
          // ── Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ReviewerHeader(review: review),
                if (review.serviceName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                    child: _ServiceBadge(
                      serviceName: review.serviceName!,
                      iconName: review.serviceIcon,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                  child: _ReviewBody(text: review.reviewText),
                ),
                if (review.hasMedia)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.spaceMd),
                    child: _ReviewMediaGrid(urls: review.mediaUrls),
                  ),
                if (review.clinicResponse != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimens.spaceLg),
                    child: _ClinicResponseBlock(
                      response: review.clinicResponse!,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular avatar with the reviewer's initial letter.
class _ReviewerAvatar extends StatelessWidget {
  const _ReviewerAvatar({required this.initial, required this.hasBadge});

  final String initial;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: AppDimens.ctaButtonMd,
      height: AppDimens.ctaButtonMd,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: hasBadge ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Header row: name + badge + date on the left,
/// stars on the right.
class _ReviewerHeader extends StatelessWidget {
  const _ReviewerHeader({required this.review});

  final ClinicReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Name + Badge + Date ──
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.reviewerName,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXxs),
              Row(
                children: [
                  if (review.memberBadge != null) ...[
                    _MemberBadge(label: review.memberBadge!),
                    const SizedBox(
                      width: AppDimens.spaceXs + AppDimens.spaceXxs,
                    ),
                  ],
                  Text(
                    review.dateLabel,
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ── Stars ──
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final isFilled = index < review.starCount;
            return Icon(
              Symbols.star,
              size: AppDimens.iconXs - 2,
              color: isFilled
                  ? (semanticColors?.warning ?? colorScheme.tertiary)
                  : colorScheme.outlineVariant,
              fill: isFilled ? 1 : 0,
            );
          }),
        ),
      ],
    );
  }
}

/// Membership tier badge (GOLD MEMBER, MEMBER).
class _MemberBadge extends StatelessWidget {
  const _MemberBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isGold = label.toUpperCase().contains('GOLD');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXs,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: isGold
            ? colorScheme.tertiaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.spaceXxs),
        ),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.2,
          color: isGold
              ? colorScheme.onTertiaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Service tag showing what was reviewed.
class _ServiceBadge extends StatelessWidget {
  const _ServiceBadge({required this.serviceName, this.iconName});

  final String serviceName;
  final String? iconName;

  /// Maps icon name strings to Material Symbols.
  IconData _resolveIcon() {
    return switch (iconName) {
      'spa' => Symbols.spa,
      'face' => Symbols.face,
      _ => Symbols.medical_services,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXs + AppDimens.spaceXxs,
        vertical: AppDimens.spaceXs + AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.spaceXxs),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: AppDimens.borderWidth,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _resolveIcon(),
            size: AppDimens.iconXs,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppDimens.spaceXs),
          Flexible(
            child: Text(
              'Service: $serviceName',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// The main review text body.
class _ReviewBody extends StatelessWidget {
  const _ReviewBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }
}

/// 3-column grid of review media images.
class _ReviewMediaGrid extends StatelessWidget {
  const _ReviewMediaGrid({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      mainAxisSpacing: AppDimens.spaceXs + AppDimens.spaceXxs,
      crossAxisSpacing: AppDimens.spaceXs + AppDimens.spaceXxs,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: urls.map((url) {
        return ClipRRect(
          borderRadius: AppDimens.radiusExtraSmall,
          child: AspectRatio(
            aspectRatio: 1,
            child: NetworkImageAuto(imageUrl: url, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}

/// Left-bordered block showing the clinic's reply.
class _ClinicResponseBlock extends StatelessWidget {
  const _ClinicResponseBlock({required this.response});

  final ClinicReviewResponse response;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          left: BorderSide(
            color: colorScheme.primary,
            width: AppDimens.borderWidthThick,
          ),
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppDimens.spaceXxs),
          bottomRight: Radius.circular(AppDimens.spaceXxs),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clinic Response:',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            response.responseText,
            style: textTheme.labelSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
