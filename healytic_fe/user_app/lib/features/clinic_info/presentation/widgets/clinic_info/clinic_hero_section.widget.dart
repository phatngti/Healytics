import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

/// Clinic cover image, gallery count badge, logo, name,
/// verified badge and location row.
class ClinicHeroSection extends StatelessWidget {
  const ClinicHeroSection({
    super.key,
    required this.name,
    required this.address,
    required this.isVerified,
    this.coverImageUrl,
    this.logoImageUrl,
  });

  final String name;
  final String address;
  final bool isVerified;
  final String? coverImageUrl;
  final String? logoImageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover image
        AspectRatio(
          aspectRatio: 21 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (coverImageUrl != null)
                NetworkImageAuto(imageUrl: coverImageUrl!, fit: BoxFit.cover)
              else
                Container(color: colorScheme.surfaceContainerHighest),
            ],
          ),
        ),
        // Logo + name + address
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.horizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(0, -28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: AvatarImage(
                        name: name,
                        imageUrl: logoImageUrl,
                        radius: 32,
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isVerified) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.verified,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: AppDimens.iconXs,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
