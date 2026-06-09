import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/staggered_grid_view/'
    'staggered_grid_view.dart';

import 'package:user_app/features/home/domain/entities/'
    'home.entity.dart';
import 'package:user_app/features/home/presentation/'
    'providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_section_header.widget.dart';
import 'package:user_app/features/home/presentation/'
    'widgets/treatment_card.widget.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/router/routes.dart';

const _previewProductCount = 4;

/// Displays a 2-column grid of premium treatment cards
/// fetched via [productsProvider].
class PremiumTreatmentsSection extends ConsumerWidget {
  const PremiumTreatmentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleGap = AppDimens.titleGap(context);
    final contentPad = AppDimens.contentPadding(context);
    final productsAsync = ref.watch(premiumTreatmentPreviewProvider);

    return Column(
      children: [
        HomeSectionHeader(
          title: 'Premium Treatments',
          actionKey: keys.homePage.premiumTreatmentsViewAll,
          onViewAll: () {
            const HomePremiumTreatmentsRoute().push(context);
          },
        ),
        SizedBox(height: titleGap),
        productsAsync.when(
          loading: () => _LoadingGrid(contentPad: contentPad),
          error: (error, stackTrace) => Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
            child: ErrorCard(
              title: 'Could not load premium treatments',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(premiumTreatmentPreviewProvider),
            ),
          ),
          data: (products) {
            final previewProducts = products
                .take(_previewProductCount)
                .toList(growable: false);
            if (previewProducts.isEmpty) {
              return const _EmptyState();
            }
            return _ProductGrid(
              products: previewProducts,
              contentPad: contentPad,
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// 2-column product grid
// ─────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<HomeProduct> products;
  final double contentPad;

  const _ProductGrid({required this.products, required this.contentPad});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: contentPad,
      crossAxisSpacing: contentPad,
      padding: EdgeInsets.zero,
      itemCount: products.length,
      itemBuilder: (context, index) => TreatmentCard(product: products[index]),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shimmer-style loading placeholders (2×2 grid)
// ─────────────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  final double contentPad;

  const _LoadingGrid({required this.contentPad});

  @override
  Widget build(BuildContext context) {
    final cardRad = AppDimens.cardRadius(context);

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: contentPad,
      crossAxisSpacing: contentPad,
      padding: EdgeInsets.zero,
      itemCount: 4,
      itemBuilder: (_, __) =>
          _LoadingPlaceholder(cardRad: cardRad, contentPad: contentPad),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final double cardRad;
  final double contentPad;

  const _LoadingPlaceholder({required this.cardRad, required this.contentPad});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(cardRad),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(contentPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: AppDimens.spaceLg,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimens.radiusExtraSmall,
                  ),
                ),
                SizedBox(height: AppDimens.spaceSm),
                Container(
                  height: AppDimens.spaceMd,
                  width: AppDimens.avatarLg,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimens.radiusExtraSmall,
                  ),
                ),
                SizedBox(height: AppDimens.spaceSm),
                Container(
                  height: AppDimens.spaceMd,
                  width: AppDimens.avatarMd,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppDimens.radiusExtraSmall,
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

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.spaceXxl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.spa,
              size: AppDimens.avatarMd,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceSm),
            Text(
              'No premium treatments yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
