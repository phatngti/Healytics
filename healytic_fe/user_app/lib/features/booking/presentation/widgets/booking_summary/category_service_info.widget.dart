import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Info card showing the selected category and
/// service details with an optional service image
/// and a category tag chip.
class CategoryServiceInfo extends StatelessWidget {
  const CategoryServiceInfo({
    super.key,
    required this.categoryName,
    required this.serviceTitle,
    this.subCategoryName,
    this.serviceSubtitle,
    this.serviceImageUrl,
  });

  /// Selected category name.
  final String categoryName;

  final String? subCategoryName;

  /// Selected service title.
  final String serviceTitle;

  /// Optional subtitle (e.g. duration + price).
  final String? serviceSubtitle;

  /// Optional service image URL.
  final String? serviceImageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad =
        AppDimens.cardPadding(context);

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
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Symbols.category,
            label: 'Category & Service',
          ),
          SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Service image
              _ServiceImage(
                imageUrl: serviceImageUrl,
              ),
              SizedBox(width: AppDimens.spaceMd),

              // Text info
              Expanded(
                child: _ServiceTextInfo(
                  categoryName: categoryName,
                  subCategoryName: subCategoryName,
                  serviceTitle: serviceTitle,
                  serviceSubtitle:
                      serviceSubtitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Rounded service image or fallback icon.
class _ServiceImage extends StatelessWidget {
  const _ServiceImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const size = 64.0;
    final radius = BorderRadius.circular(
      AppDimens.spaceSmMd,
    );

    if (imageUrl != null &&
        imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _Placeholder(size: size),
        ),
      );
    }

    return _Placeholder(size: size);
  }
}

/// Fallback placeholder when no image available.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(
          AppDimens.spaceSmMd,
        ),
      ),
      child: Icon(
        Symbols.health_and_safety,
        size: AppDimens.iconLg,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Text column: category tag + service title +
/// subtitle.
class _ServiceTextInfo extends StatelessWidget {
  const _ServiceTextInfo({
    required this.categoryName,
    required this.serviceTitle,
    this.subCategoryName,
    this.serviceSubtitle,
  });

  final String categoryName;
  final String? subCategoryName;
  final String serviceTitle;
  final String? serviceSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimens.spaceXs,
          runSpacing: AppDimens.spaceXs,
          children: [
            _CategoryTag(name: categoryName),
            if (subCategoryName != null && subCategoryName!.isNotEmpty)
              _CategoryTag(name: subCategoryName!),
          ],
        ),
        SizedBox(height: AppDimens.spaceSm),

        // Service title
        Text(
          serviceTitle,
          style: theme.textTheme.titleSmall
              ?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle (duration + price)
        if (serviceSubtitle != null) ...[
          SizedBox(height: AppDimens.spaceXxs),
          Text(
            serviceSubtitle!,
            style: theme.textTheme.bodySmall
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Small pill-shaped category tag.
class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        name,
        style:
            theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

/// Uppercase section header with icon.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
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
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall
              ?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
