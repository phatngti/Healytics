import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesTrendsByCategory extends StatelessWidget {
  const SalesTrendsByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        padding: AppDimens.paddingAllLarge,
        margin: AppDimens.paddingAllMedium,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusMediumSmall,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // AspectRatio ensures the chart doesn't squish weirdly
        child: AspectRatio(
          aspectRatio: 1.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sales Trends by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  _buildDropdownMock(context),
                ],
              ),
              AppDimens.verticalLargeExtra,

              // --- Chart Section ---
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 12500, // Slightly higher than max value for headroom
                    // Disable the chart border
                    borderData: FlBorderData(show: false),
                    // Grid configuration
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: colorScheme.outlineVariant,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    // Axis Titles configuration
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      // Y-Axis (Left)
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          interval: 2000,
                          getTitlesWidget: (value, meta) {
                            // Don't show the 0 label if it overlaps too much or looks bad
                            // but in the image it is shown.
                            return Text(
                              _formatNumber(value),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            );
                          },
                        ),
                      ),
                      // X-Axis (Bottom)
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: AppDimens.paddingTopSmall,
                              child: Text(
                                _getCategoryName(value.toInt()),
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // The Bar Data
                    barGroups: [
                      _makeGroupData(0, 12000, colorScheme), // Electronics
                      _makeGroupData(1, 9500, colorScheme), // Peripherals
                      _makeGroupData(2, 7800, colorScheme), // Accessories
                      _makeGroupData(3, 6200, colorScheme), // Monitors
                      _makeGroupData(4, 4200, colorScheme), // Audio
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create the Bar Data
  BarChartGroupData _makeGroupData(int x, double y, ColorScheme colorScheme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: colorScheme.primary,
          width: 40, // Thickness of the bar
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          backDrawRodData: BackgroundBarChartRodData(show: false),
        ),
      ],
    );
  }

  // Helper to mock the dropdown button
  Widget _buildDropdownMock(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppDimens.paddingHorizontalSmall.add(
        AppDimens.paddingVerticalExtraSmall,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: AppDimens.radiusExtraSmall,
      ),
      child: Row(
        children: [
          Text(
            "Last 30 days",
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          AppDimens.horizontalSmall,
          Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  // Helper to format numbers (12000 -> 12,000)
  String _formatNumber(double value) {
    if (value == 0) return '0';
    return value.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // Helper to map index to category name
  String _getCategoryName(int index) {
    switch (index) {
      case 0:
        return 'Electronics';
      case 1:
        return 'Peripherals';
      case 2:
        return 'Accessories';
      case 3:
        return 'Monitors';
      case 4:
        return 'Audio';
      default:
        return '';
    }
  }
}
