import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Type alias for backward compatibility.
typedef FacilityImage = FacilityImageEntity;

/// Facility tour section: title + horizontal scrollable image cards
/// with gradient overlay and caption.
class FacilityTourSection extends StatelessWidget {
  const FacilityTourSection({
    super.key,
    required this.images,
    this.title = 'Facility Tour',
  });

  final List<FacilityImage> images;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth * 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppDimens.verticalMedium,
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: images.length,
            separatorBuilder: (_, __) => AppDimens.horizontalMedium,
            itemBuilder: (context, index) =>
                _FacilityCard(image: images[index], width: cardWidth),
          ),
        ),
      ],
    );
  }
}

/// Individual facility image card with gradient overlay and label.
class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.image, required this.width});

  final FacilityImage image;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: SizedBox(
        width: width,
        height: 128,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
            // Gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0x80000000), Colors.transparent],
                ),
              ),
              child: SizedBox.expand(),
            ),
            // Label
            Positioned(
              bottom: AppDimens.spaceSm,
              left: AppDimens.spaceMd,
              child: Text(
                image.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
