import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/loading.dart';
import 'package:common/widgets/staggered_grid_view/staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/features/home/presentation/widgets/treatment_card.widget.dart';

/// Full premium treatments grid from the home page.
class HomePremiumTreatmentsScreen extends ConsumerWidget {
  const HomePremiumTreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatmentsAsync = ref.watch(premiumTreatmentsProvider);

    return HomeListScreenLayout(
      title: 'Premium Treatments',
      body: switch (treatmentsAsync) {
        AsyncData(:final value) => _TreatmentGrid(products: value),
        AsyncError(:final error, :final stackTrace) => Center(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: ErrorCard(
              title: 'Could not load premium treatments',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(premiumTreatmentsProvider),
            ),
          ),
        ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _TreatmentGrid extends StatelessWidget {
  const _TreatmentGrid({required this.products});

  final List<HomeProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyState();
    }

    final hPad = AppDimens.horizontalPadding(context);
    final gap = AppDimens.contentPadding(context);
    final columns = AppDimens.responsiveValue<int>(
      context,
      mobile: 2,
      tablet: 3,
      web: 4,
    );

    return MasonryGridView.count(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceLg,
        hPad,
        AppDimens.bottomScrollPadding(context),
      ),
      crossAxisCount: columns,
      mainAxisSpacing: gap,
      crossAxisSpacing: gap,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return TreatmentCard(product: products[index]);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Text(
          'No premium treatments yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
