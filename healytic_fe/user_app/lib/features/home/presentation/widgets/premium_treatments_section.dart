import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/home/domain/home.entity.dart';
import 'package:user_app/features/home/presentation/provider/home_provider.dart';
import 'package:user_app/features/home/presentation/service_details.dart';
import 'package:user_app/utils/device.dart';

class PremiumTreatmentsSection extends HookConsumerWidget {
  const PremiumTreatmentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final treatments = homeState.premiumProducts;

    if (homeState.isLoading && treatments.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (treatments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and "See All"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Premium Treatments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to all treatments
              },
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Grid of treatment cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio:
                (DeviceUtils.getScreenWidth(context) - 58) /
                2 /
                (((DeviceUtils.getScreenWidth(context) - 58) / 2) * 0.75 + 155),
          ),
          itemCount: treatments.length,
          itemBuilder: (context, index) {
            final treatment = treatments[index];
            return _TreatmentCard(treatment: treatment);
          },
        ),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final HomeProduct treatment;

  const _TreatmentCard({required this.treatment});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ServiceDetailsScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                treatment.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image, color: colorScheme.onSurface);
                },
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category
                        Text(
                          treatment.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Title
                        Text(
                          treatment.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Duration and Staff Avatars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Duration
                            Row(
                              children: [
                                Icon(
                                  Symbols.schedule,
                                  size: 12,
                                  color: colorScheme.onSurface,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  treatment.duration,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            // Staff Avatars
                            _buildStaffAvatars(context),
                          ],
                        ),
                      ],
                    ),
                    // Price and Add Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          treatment.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14B8A6),
                          ),
                        ),
                        _buildAddButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffAvatars(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Calculate width: first avatar is 20px, each subsequent adds 14px (20px avatar - 6px overlap)
    final width = treatment.staffAvatars.isEmpty
        ? 0.0
        : 20.0 + (treatment.staffAvatars.length - 1) * 14.0;
    return SizedBox(
      width: width,
      height: 20,
      child: Stack(
        children: List.generate(treatment.staffAvatars.length, (index) {
          return Positioned(
            left: index * 14.0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.onSurface, width: 1.5),
              ),
              child: ClipOval(
                child: Image.network(
                  treatment.staffAvatars[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: colorScheme.onSurface,
                      child: Icon(
                        Icons.person,
                        size: 12,
                        color: colorScheme.onSurface,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primaryContainer.withAlpha(51),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(Symbols.add, size: 18, color: colorScheme.onSurface),
    );
  }
}
