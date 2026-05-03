import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Gallery section with image grid, reordering
/// arrows, and upload/remove actions.
class GallerySectionWidget extends StatelessWidget {
  const GallerySectionWidget({
    required this.gallery,
    required this.isUploadingGallery,
    required this.showValidationErrors,
    required this.isGalleryValid,
    required this.minImages,
    required this.maxImages,
    required this.onAddImages,
    required this.onRemoveImage,
    required this.onMoveImage,
    super.key,
  });

  final List<String> gallery;
  final bool isUploadingGallery;
  final bool showValidationErrors;
  final bool isGalleryValid;
  final int minImages;
  final int maxImages;
  final VoidCallback onAddImages;
  final void Function(int index) onRemoveImage;
  final void Function(int index, int direction) onMoveImage;

  /// Spinner size for the uploading state.
  static const double _spinnerSize = 16;

  /// Spinner stroke width.
  static const double _spinnerStroke = 2;

  /// Gallery tile width.
  static const double _tileWidth = 180;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final galleryError = showValidationErrors && !isGalleryValid;

    return SectionCardWidget(
      title: 'Clinic gallery',
      subtitle:
          'Add between $minImages and $maxImages '
          'images that highlight the exterior, '
          'treatment rooms, equipment, and '
          'patient-facing environment.',
      trailing: FilledButton.icon(
        onPressed: isUploadingGallery ? null : onAddImages,
        icon: isUploadingGallery
            ? SizedBox(
                width: _spinnerSize,
                height: _spinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: _spinnerStroke,
                  color: colorScheme.onPrimary,
                ),
              )
            : const Icon(Icons.add_photo_alternate_rounded),
        label: Text(isUploadingGallery ? 'Uploading...' : 'Add images'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppDimens.spaceLg,
            runSpacing: AppDimens.spaceLg,
            children: [
              for (var i = 0; i < gallery.length; i++)
                _GalleryTile(
                  imageUrl: gallery[i],
                  index: i,
                  total: gallery.length,
                  onMoveLeft: i == 0 ? null : () => onMoveImage(i, -1),
                  onMoveRight: i == gallery.length - 1
                      ? null
                      : () => onMoveImage(i, 1),
                  onRemove: () => onRemoveImage(i),
                ),
              if (gallery.isEmpty) _EmptyGalleryPlaceholder(),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMdLg),
          Text(
            '$minImages minimum, $maxImages '
            'maximum. Use the arrow buttons to '
            'choose the display order.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (galleryError) ...[
            AppDimens.verticalSmall,
            Text(
              'Upload at least $minImages images '
              'before completing the profile.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyGalleryPlaceholder extends StatelessWidget {
  /// Large placeholder icon size.
  static const double _placeholderIconSize = 40;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: _placeholderIconSize,
            color: colorScheme.onSurfaceVariant,
          ),
          AppDimens.verticalMediumSmall,
          Text(
            'No gallery images uploaded yet',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.imageUrl,
    required this.index,
    required this.total,
    required this.onRemove,
    this.onMoveLeft,
    this.onMoveRight,
  });

  final String imageUrl;
  final int index;
  final int total;
  final VoidCallback onRemove;
  final VoidCallback? onMoveLeft;
  final VoidCallback? onMoveRight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: GallerySectionWidget._tileWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.spaceLg + AppDimens.spaceXxs),
                ),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          ),
          AppDimens.verticalMediumSmall,
          Text(
            'Image ${index + 1} of $total',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppDimens.verticalSmall,
          Wrap(
            spacing: AppDimens.spaceSm,
            runSpacing: AppDimens.spaceSm,
            children: [
              IconButton.outlined(
                onPressed: onMoveLeft,
                tooltip: 'Move left',
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              IconButton.outlined(
                onPressed: onMoveRight,
                tooltip: 'Move right',
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
              IconButton.filledTonal(
                onPressed: onRemove,
                tooltip: 'Remove image',
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
