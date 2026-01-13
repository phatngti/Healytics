import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductDetailsPerformanceCard extends StatelessWidget {
  final Product product;

  const ProductDetailsPerformanceCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.query_stats,
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.success,
                    ), // accent-green
                    AppDimens.horizontalSmall,
                    Text(
                      'Performance Insights',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: AppDimens.radiusSmall,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Text('Last 30 Days', style: theme.textTheme.labelSmall),
                      AppDimens.horizontalExtraSmall,
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),

          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Total appointments',
                        'Bookings',
                        '1,248',
                        '+12%',
                        Theme.of(context).extension<SemanticColors>()!.success!,
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Gross earnings',
                        'Revenue',
                        '\$149.8k',
                        '+5.4%',
                        Theme.of(context).extension<SemanticColors>()!.success!,
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Based on 85 reviews',
                        'Rating',
                        '4.9',
                        '/5',
                        Theme.of(context).extension<SemanticColors>()!.warning!,
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalExtraLarge,

                // Chart Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Booking Trends',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AppDimens.verticalMedium,
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.colorScheme.outlineVariant,
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const titles = [
                                'Jan',
                                'Feb',
                                'Mar',
                                'Apr',
                                'May',
                                'Jun',
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < titles.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    titles[value.toInt()],
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 5,
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 20),
                            FlSpot(1, 45),
                            FlSpot(2, 60),
                            FlSpot(3, 40),
                            FlSpot(4, 75),
                            FlSpot(5, 85),
                          ],
                          isCurved: true,
                          color: Theme.of(
                            context,
                          ).extension<SemanticColors>()!.success!,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: theme.colorScheme.surface,
                                strokeWidth: 2,
                                strokeColor: Theme.of(
                                  context,
                                ).extension<SemanticColors>()!.success!,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .extension<SemanticColors>()!
                                    .success!
                                    .withValues(alpha: 0.2),
                                Theme.of(context)
                                    .extension<SemanticColors>()!
                                    .success!
                                    .withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
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
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String subtitle,
    String label,
    String value,
    String badge,
    Color badgeColor,
  ) {
    final theme = Theme.of(context);
    final isRating = label == 'Rating';

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (!isRating)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.star,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).extension<SemanticColors>()!.warning!,
                ),
            ],
          ),
          AppDimens.verticalSmall,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRating) ...[
                const SizedBox(width: 2),
                Text(
                  '/5',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          AppDimens.verticalExtraSmall,
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
