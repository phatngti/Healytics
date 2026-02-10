import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/features/home/domain/entities/home.entity.dart';
import 'package:user_app/features/home/presentation/providers/home.provider.dart';
import 'package:user_app/theme/app_theme.dart';

class ExploreServicesSection extends ConsumerWidget {
  const ExploreServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final titleGap = AppDimens.titleGap(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Services',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: titleGap),
        categoriesAsync.when(
          data: (categories) => _buildGrid(context, categories),
          loading: () => _buildLoadingGrid(context),
          error: (_, __) => _buildGrid(context, []),
        ),
      ],
    );
  }

  /// Fixed 3-column grid for compact service items.
  Widget _buildGrid(BuildContext context, List<HomeCategory> categories) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      crossAxisSpacing: 0, // Removes horizontal gaps
      mainAxisSpacing: 0, // Removes vertical gaps between rows
      padding: EdgeInsets.zero, // IMPORTANT: Removes top/bottom gaps

      children: categories
          .map(
            (category) => _ServiceItem(
              icon: category.icon,
              label: category.name,
              color: _getColorForCategoryType(context, category.categoryType),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(
        6,
        (_) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: AppDimens.avatarLg,
              width: AppDimens.avatarLg,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: AppDimens.spaceSm),
            Container(
              height: AppDimens.spaceMd,
              width: AppDimens.avatarMd,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: AppDimens.radiusExtraSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCategoryType(BuildContext context, String categoryType) {
    final theme = Theme.of(context);
    final semanticColors = theme.extension<SemanticColors>()!;

    switch (categoryType) {
      case 'primary':
        return theme.colorScheme.primary;
      case 'secondary':
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'error':
        return semanticColors.warning!;
      case 'success':
        return semanticColors.success!;
      case 'info':
        return semanticColors.info!;
      default:
        return theme.colorScheme.primary;
    }
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: AppDimens.avatarLg,
          width: AppDimens.avatarLg,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.02),
                blurRadius: AppDimens.spaceXs,
                offset: Offset(0, AppDimens.spaceXxs),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: AppDimens.iconXl),
        ),
        SizedBox(height: AppDimens.spaceSm),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
