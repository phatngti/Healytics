import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesTrendsByCategory extends StatelessWidget {
  const SalesTrendsByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                  const Text(
                    'Sales Trends by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B), // Dark slate
                    ),
                  ),
                  _buildDropdownMock(),
                ],
              ),
              const SizedBox(height: 32),

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
                        return const FlLine(
                          color: Color(0xFFE2E8F0), // Light grey grid
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
                              style: const TextStyle(
                                color: Color(0xFF64748B),
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _getCategoryName(value.toInt()),
                                style: const TextStyle(
                                  color: Color(0xFF334155),
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
                      _makeGroupData(0, 12000), // Electronics
                      _makeGroupData(1, 9500), // Peripherals
                      _makeGroupData(2, 7800), // Accessories
                      _makeGroupData(3, 6200), // Monitors
                      _makeGroupData(4, 4200), // Audio
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
  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF5FA5FA), // The specific blue from the image
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
  Widget _buildDropdownMock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: const [
          Text(
            "Last 30 days",
            style: TextStyle(fontSize: 14, color: Color(0xFF334155)),
          ),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
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
