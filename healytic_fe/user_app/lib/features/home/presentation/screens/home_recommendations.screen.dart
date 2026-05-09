import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/home/domain/entities/'
    'ai_recommendation.entity.dart';
import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_list_screen_layout.widget.dart';
import 'package:user_app/router/routes.dart';

/// Full list of AI recommendations from the home page.
class HomeRecommendationsScreen extends ConsumerWidget {
  const HomeRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(allRecommendedProductsProvider);

    return HomeListScreenLayout(
      title: 'Recommendations',
      body: switch (recommendationsAsync) {
        AsyncData(:final value) => _RecommendationList(items: value),
        AsyncError(:final error, :final stackTrace) => Center(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: ErrorCard(
              title: 'Could not load recommendations',
              error: error,
              stackTrace: stackTrace,
              onRetry: () => ref.invalidate(allRecommendedProductsProvider),
            ),
          ),
        ),
        _ => const LoadingWidget(),
      },
    );
  }
}

class _RecommendationList extends StatelessWidget {
  const _RecommendationList({required this.items});

  final List<AiRecommendation> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _EmptyState();
    }

    final hPad = AppDimens.horizontalPadding(context);
    final gap = AppDimens.contentPadding(context);

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        hPad,
        AppDimens.spaceLg,
        hPad,
        AppDimens.bottomScrollPadding(context),
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: gap),
      itemBuilder: (context, index) {
        return _RecommendationCard(item: items[index]);
      },
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item});

  final AiRecommendation item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardRad = AppDimens.cardRadius(context);
    final contentPad = AppDimens.contentPadding(context);
    final imageSize = AppDimens.adaptive(
      context,
      small: AppDimens.avatarLg + AppDimens.spaceXxl,
      medium: AppDimens.avatarLg + AppDimens.spaceXxxl,
      large: AppDimens.avatarLg + AppDimens.spaceXxxl,
    );

    return Semantics(
      button: true,
      label: item.name,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(cardRad),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ServiceDetailsRoute(serviceId: item.serviceId).push(context);
          },
          child: Container(
            padding: EdgeInsets.all(contentPad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardRad),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                _Thumbnail(imageUrl: item.imageUrl, size: imageSize),
                AppDimens.horizontalMedium,
                Expanded(child: _CardDetails(item: item)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: SizedBox.square(
        dimension: size,
        child: imageUrl.isEmpty
            ? _ImageFallback(colorScheme: colorScheme)
            : NetworkImageAuto(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_) => _ImageFallback(colorScheme: colorScheme),
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Symbols.image,
        color: colorScheme.onSurfaceVariant,
        size: AppDimens.iconXxl,
      ),
    );
  }
}

class _CardDetails extends StatelessWidget {
  const _CardDetails({required this.item});

  final AiRecommendation item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalSmall,
        _MetaRow(
          icon: Symbols.star,
          text: item.rating.toStringAsFixed(1),
          color: colorScheme.primary,
        ),
        if (item.location.isNotEmpty) ...[
          AppDimens.verticalExtraSmall,
          _MetaRow(icon: Symbols.location_on, text: item.location),
        ],
        AppDimens.verticalSmall,
        Text(
          item.price.isEmpty ? 'View details' : item.price,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: AppDimens.fontWeightBold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconSm, color: iconColor),
        AppDimens.horizontalExtraSmall,
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
          'No recommendations yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
