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
    final treatmentsAsync = ref.watch(premiumTreatmentsPaginatedProvider);
    final filterActive = ref.watch(
      premiumTreatmentFilterProvider.select((value) => value.isActive),
    );
    final data = treatmentsAsync.value;

    if (data != null) {
      return _RefreshingStack(
        isRefreshing: treatmentsAsync.isLoading,
        child: _TreatmentGrid(
          products: data.products,
          filtersActive: filterActive,
          hasMore: data.hasMore,
          isLoadingMore: data.isLoadingMore,
          loadMoreError: data.loadMoreError,
          onLoadMore: () =>
              ref.read(premiumTreatmentsPaginatedProvider.notifier).loadMore(),
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
            onRetry: () => ref.invalidate(premiumTreatmentsPaginatedProvider),
          ),
        ),
      );
    }

    return const LoadingWidget();
  }
}

const _loadMoreScrollThreshold = 260.0;

class _TreatmentGrid extends StatefulWidget {
  const _TreatmentGrid({
    required this.products,
    required this.filtersActive,
    required this.hasMore,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.onLoadMore,
    required this.onReset,
  });

  final List<HomeProduct> products;
  final bool filtersActive;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final Future<void> Function() onLoadMore;
  final VoidCallback onReset;

  @override
  State<_TreatmentGrid> createState() => _TreatmentGridState();
}

class _TreatmentGridState extends State<_TreatmentGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scheduleLoadAfterLayout();
  }

  @override
  void didUpdateWidget(covariant _TreatmentGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.products.length != widget.products.length ||
        oldWidget.hasMore != widget.hasMore) {
      _scheduleLoadAfterLayout();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _loadIfNearBottom();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      _loadIfNearBottom(notification.metrics);
    }
    return false;
  }

  void _scheduleLoadAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadIfNearBottom();
    });
  }

  void _loadIfNearBottom([ScrollMetrics? metrics]) {
    if (!widget.hasMore || widget.isLoadingMore) {
      return;
    }

    final position =
        metrics ??
        (_scrollController.hasClients ? _scrollController.position : null);
    if (position == null) return;

    final distanceToBottom = position.maxScrollExtent - position.pixels;
    if (distanceToBottom <= _loadMoreScrollThreshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return _EmptyState(
        filtersActive: widget.filtersActive,
        onReset: widget.onReset,
      );
    }

    final hPad = AppDimens.horizontalPadding(context);
    final gap = AppDimens.contentPadding(context);
    final columns = AppDimens.responsiveValue<int>(
      context,
      mobile: 2,
      tablet: 3,
      web: 4,
    );

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: MasonryGridView.count(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
              hPad,
              AppDimens.spaceLg,
              hPad,
              AppDimens.bottomScrollPadding(context),
            ),
            crossAxisCount: columns,
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              return TreatmentCard(product: widget.products[index]);
            },
          ),
        ),
        if (widget.isLoadingMore)
          const Positioned(
            left: 0,
            right: 0,
            bottom: AppDimens.spaceMd,
            child: Center(child: CircularProgressIndicator()),
          ),
        if (!widget.isLoadingMore && widget.loadMoreError != null)
          Positioned(
            left: hPad,
            right: hPad,
            bottom: AppDimens.spaceMd,
            child: _LoadMoreErrorBar(onRetry: widget.onLoadMore),
          ),
      ],
    );
  }
}

class _LoadMoreErrorBar extends StatelessWidget {
  const _LoadMoreErrorBar({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      elevation: 4,
      color: colorScheme.errorContainer,
      borderRadius: AppDimens.radiusSmall,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceXs,
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.onErrorContainer,
              size: AppDimens.iconSm,
            ),
            SizedBox(width: AppDimens.spaceXs),
            Expanded(
              child: Text(
                'Could not load more treatments',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onErrorContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: () => onRetry(),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onErrorContainer,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
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
