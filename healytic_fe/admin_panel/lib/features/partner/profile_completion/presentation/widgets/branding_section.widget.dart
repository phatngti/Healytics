import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Branding section with cover image and logo
/// upload surfaces in a responsive layout.
class BrandingSectionWidget extends StatelessWidget {
  const BrandingSectionWidget({
    required this.coverImageUrl,
    required this.logoImageUrl,
    required this.isUploadingCover,
    required this.isUploadingLogo,
    required this.showValidationErrors,
    required this.hasCoverImage,
    required this.hasLogoImage,
    required this.onUploadCover,
    required this.onUploadLogo,
    required this.onRemoveCover,
    required this.onRemoveLogo,
    super.key,
  });

  final String? coverImageUrl;
  final String? logoImageUrl;
  final bool isUploadingCover;
  final bool isUploadingLogo;
  final bool showValidationErrors;
  final bool hasCoverImage;
  final bool hasLogoImage;
  final VoidCallback onUploadCover;
  final VoidCallback onUploadLogo;
  final VoidCallback? onRemoveCover;
  final VoidCallback? onRemoveLogo;

  /// Breakpoint for side-by-side layout.
  static const double _wideBreakpoint = 840;

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: 'Clinic branding',
      subtitle:
          'Upload a square logo and a 16:9 cover '
          'image so your clinic profile looks '
          'complete across search, booking, and '
          'storefront surfaces.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _wideBreakpoint;

          final coverSurface = ImageUploadSurfaceWidget(
            title: 'Cover image',
            subtitle:
                '16:9 recommended. Displayed '
                'at the top of the clinic '
                'profile.',
            imageUrl: coverImageUrl,
            icon: Icons.landscape_rounded,
            aspectRatio: 16 / 9,
            isUploading: isUploadingCover,
            isRequiredError: showValidationErrors && !hasCoverImage,
            onUpload: onUploadCover,
            onRemove: hasCoverImage ? onRemoveCover : null,
          );

          final logoSurface = ImageUploadSurfaceWidget(
            title: 'Logo image',
            subtitle:
                'Square logo used in cards, '
                'chat, and branded listings.',
            imageUrl: logoImageUrl,
            icon: Icons.local_hospital_rounded,
            aspectRatio: 1,
            isUploading: isUploadingLogo,
            isRequiredError: showValidationErrors && !hasLogoImage,
            onUpload: onUploadLogo,
            onRemove: hasLogoImage ? onRemoveLogo : null,
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: coverSurface),
                AppDimens.horizontalLargeExtra,
                Expanded(child: logoSurface),
              ],
            );
          }

          return Column(
            children: [coverSurface, AppDimens.verticalLargeExtra, logoSurface],
          );
        },
      ),
    );
  }
}

/// Upload surface showing an image preview or
/// placeholder with upload/remove actions.
class ImageUploadSurfaceWidget extends StatelessWidget {
  const ImageUploadSurfaceWidget({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.aspectRatio,
    required this.isUploading,
    required this.isRequiredError,
    required this.onUpload,
    this.imageUrl,
    this.onRemove,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final double aspectRatio;
  final bool isUploading;
  final bool isRequiredError;
  final VoidCallback onUpload;
  final VoidCallback? onRemove;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppDimens.spaceXs + AppDimens.spaceXxs),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppDimens.spaceMdLg),
        AspectRatio(
          aspectRatio: aspectRatio,
          child: _ImagePreviewContainer(
            hasImage: hasImage,
            imageUrl: imageUrl,
            icon: icon,
            title: title,
            isUploading: isUploading,
            isRequiredError: isRequiredError,
            onUpload: onUpload,
            onRemove: onRemove,
          ),
        ),
        if (isRequiredError) ...[
          AppDimens.verticalSmall,
          Text(
            '$title is required.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _ImagePreviewContainer extends StatelessWidget {
  const _ImagePreviewContainer({
    required this.hasImage,
    required this.imageUrl,
    required this.icon,
    required this.title,
    required this.isUploading,
    required this.isRequiredError,
    required this.onUpload,
    this.onRemove,
  });

  final bool hasImage;
  final String? imageUrl;
  final IconData icon;
  final String title;
  final bool isUploading;
  final bool isRequiredError;
  final VoidCallback onUpload;
  final VoidCallback? onRemove;

  /// Error border emphasis width.
  static const double _errorBorderWidth = 1.4;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: AppDimens.radiusMediumLarge,
        border: Border.all(
          color: isRequiredError
              ? colorScheme.error
              : isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.4)
              : colorScheme.outlineVariant,
          width: isRequiredError ? _errorBorderWidth : AppDimens.borderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _ImagePlaceholder(icon: icon, title: title);
              },
            )
          else
            _ImagePlaceholder(icon: icon, title: title),
          if (isUploading)
            Container(
              color: colorScheme.scrim.withValues(alpha: 0.32),
              child: const Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            right: AppDimens.spaceMd,
            top: AppDimens.spaceMd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.tonal(
                  onPressed: isUploading ? null : onUpload,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload_rounded, size: AppDimens.iconSmMd),
                      AppDimens.horizontalSmall,
                      Text(hasImage ? 'Change' : 'Upload'),
                    ],
                  ),
                ),
                if (hasImage && onRemove != null) ...[
                  AppDimens.horizontalSmall,
                  IconButton.filledTonal(
                    onPressed: isUploading ? null : onRemove,
                    tooltip: 'Remove image',
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder shown when no image is uploaded.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.icon, required this.title});

  final IconData icon;
  final String title;

  /// Large placeholder icon size.
  static const double _placeholderIconSize = 36;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: isDark
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
          : null,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppDimens.paddingAllMedium,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: _placeholderIconSize,
                color: isDark
                    ? colorScheme.primary.withValues(alpha: 0.7)
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMdLg),
            Text(
              'Upload $title',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'Click the upload button above',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
