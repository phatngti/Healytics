import 'package:admin_panel/features/partner/products/presentation/widgets/product_analytics/product_overview_analytics.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

class ProductHomeDesktop extends StatelessWidget {
  const ProductHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final clampedHeight = viewportHeight.clamp(720.0, 980.0).toDouble();
    final isCompactDesktop = viewportWidth < 1520;
    final pagePadding = isCompactDesktop
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
        : AppDimens.paddingAllLarge;
    final tableHeight = (clampedHeight * (isCompactDesktop ? 0.5 : 0.56))
        .clamp(420.0, 560.0)
        .toDouble();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: pagePadding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProductHomeHero(),
              const SizedBox(height: 20),
              const ProductOverviewAnalyticsSection(),
              const SizedBox(height: 20),
              _ProductManagementSection(tableHeight: tableHeight),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductHomeHero extends StatelessWidget {
  const _ProductHomeHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1080;

          if (!isWide) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_HeroCopy()],
            );
          }

          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: _HeroCopy())],
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: AppDimens.fontWeightBold,
          ),
        ),
        AppDimens.verticalMedium,
        Text(
          'Manage, search, edit, and review the full product catalog from a stable desktop table layout.',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppDimens.fontWeightRegular,
          ),
        ),
      ],
    );
  }
}

class _ProductManagementSection extends StatelessWidget {
  const _ProductManagementSection({required this.tableHeight});

  final double tableHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1080;

              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ManagementCopy(theme: theme, colorScheme: colorScheme),
                    AppDimens.verticalMedium,
                    _SectionPill(colorScheme: colorScheme),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ManagementCopy(
                      theme: theme,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 20),
                  _SectionPill(colorScheme: colorScheme),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ProductTable(height: tableHeight),
        ],
      ),
    );
  }
}

class _ManagementCopy extends StatelessWidget {
  const _ManagementCopy({required this.theme, required this.colorScheme});

  final ThemeData theme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Management',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: AppDimens.fontWeightBold,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          'Manage, search, edit, and review the full product catalog from a '
          'stable desktop table layout.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionPill extends StatelessWidget {
  const _SectionPill({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.paddingHorizontalMedium.add(
        AppDimens.paddingVerticalSmall,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: AppDimens.radiusPill,
      ),
      child: Text(
        'Website Layout',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: AppDimens.fontWeightSemiBold,
        ),
      ),
    );
  }
}
