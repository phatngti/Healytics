import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/loading.dart';
import 'package:common/widgets/staggered_grid_view/staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/home/domain/entities/filter_sort.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/presentation/providers/list_filter.provider.dart';
import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'filter_sort_controls.widget.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/features/home/presentation/widgets/treatment_card.widget.dart';

/// Full premium treatments grid from the home page.
class HomePremiumTreatmentsScreen extends ConsumerWidget {
  const HomePremiumTreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeListScreenLayout(
      title: 'Premium Treatments',
      body: const _PremiumTreatmentsBody(),
    );
  }
}

class _PremiumTreatmentsBody extends StatelessWidget {
  const _PremiumTreatmentsBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppDimens.verticalMedium,
        _PremiumFilterBar(),
        Expanded(child: _PremiumTreatmentList()),
      ],
    );
  }
}

class _PremiumFilterBar extends ConsumerWidget {
  const _PremiumFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(premiumTreatmentFilterProvider);

    return FilterSortBar<ServiceListSort>(
      options: ServiceListSort.values
          .map((sort) => SortOption(value: sort, label: sort.label))
          .toList(),
      selected: filter.sort,
      filtersActive: filter.hasFilters,
      onFilterTap: () async {
        final next = await showServiceFilterSheet(
          context,
          filter,
          includeCategory: true,
        );
        if (next != null) {
          ref.read(premiumTreatmentFilterProvider.notifier).state = next;
        }
      },
      onSelected: (sort) {
        ref.read(premiumTreatmentFilterProvider.notifier).state = filter
            .withSort(sort);
      },
    );
  }
}

class _PremiumTreatmentList extends ConsumerWidget {
  const _PremiumTreatmentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatmentsAsync = ref.watch(premiumTreatmentsProvider);
    final filterActive = ref.watch(
      premiumTreatmentFilterProvider.select((value) => value.isActive),
    );
    final products = treatmentsAsync.value;

    if (products != null) {
      return _RefreshingStack(
        isRefreshing: treatmentsAsync.isLoading,
        child: _TreatmentGrid(
          products: products,
          filtersActive: filterActive,
          onReset: () {
            ref.read(premiumTreatmentFilterProvider.notifier).state =
                const ServiceListFilter();
          },
        ),
      );
    }

    if (treatmentsAsync.hasError) {
      return Center(
        child: Padding(
          padding: AppDimens.paddingAllMedium,
          child: ErrorCard(
            title: 'Could not load premium treatments',
            error: treatmentsAsync.error!,
            stackTrace: treatmentsAsync.stackTrace,
            onRetry: () => ref.invalidate(premiumTreatmentsProvider),
          ),
        ),
      );
    }

    return const LoadingWidget();
  }
}

class _TreatmentGrid extends StatelessWidget {
  const _TreatmentGrid({
    required this.products,
    required this.filtersActive,
    required this.onReset,
  });

  final List<HomeProduct> products;
  final bool filtersActive;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _EmptyState(filtersActive: filtersActive, onReset: onReset);
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
  const _EmptyState({required this.filtersActive, required this.onReset});

  final bool filtersActive;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filtersActive
                  ? 'No treatments match these filters'
                  : 'No premium treatments yet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (filtersActive) ...[
              AppDimens.verticalSmall,
              TextButton(
                onPressed: onReset,
                child: const Text('Reset filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RefreshingStack extends StatelessWidget {
  const _RefreshingStack({required this.isRefreshing, required this.child});

  final bool isRefreshing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}
