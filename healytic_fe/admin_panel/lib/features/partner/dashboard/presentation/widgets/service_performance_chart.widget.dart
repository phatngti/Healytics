import 'package:admin_panel/features/partner/dashboard/domain/service_performance.entity.dart';
import 'package:admin_panel/features/partner/dashboard/presentation/widgets/dashboard_section_header.widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Horizontal bar chart comparing service bookings.
class ServicePerformanceChart extends StatelessWidget {
  const ServicePerformanceChart({
    super.key,
    required this.services,
  });

  final List<ServicePerformance> services;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(
              title: 'Service Performance',
              icon: Icons.bar_chart_rounded,
            ),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment:
                      BarChartAlignment.spaceAround,
                  maxY: _maxBookings * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData:
                        BarTouchTooltipData(
                          getTooltipColor: (_) =>
                              colorScheme
                                  .inverseSurface,
                          getTooltipItem: (
                            group,
                            groupIdx,
                            rod,
                            rodIdx,
                          ) {
                            final svc =
                                services[group.x];
                            return BarTooltipItem(
                              '${svc.serviceName}\n',
                              TextStyle(
                                color: colorScheme
                                    .onInverseSurface,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${svc.bookingCount}'
                                      ' bookings',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: colorScheme
                                        .onInverseSurface,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget:
                            (value, meta) {
                              return Text(
                                value.toInt()
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              );
                            },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget:
                            (value, meta) {
                              final idx =
                                  value.toInt();
                              if (idx < 0 ||
                                  idx >=
                                      services
                                          .length) {
                                return const SizedBox
                                    .shrink();
                              }
                              final name =
                                  services[idx]
                                      .serviceName;
                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                          top: 8,
                                        ),
                                child: Text(
                                  name.length > 10
                                      ? '${name.substring(0, 10)}…'
                                      : name,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  textAlign:
                                      TextAlign
                                          .center,
                                ),
                              );
                            },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine:
                        (value) => FlLine(
                          color: colorScheme
                              .outlineVariant
                              .withValues(
                                alpha: 0.3,
                              ),
                          strokeWidth: 1,
                        ),
                  ),
                  borderData:
                      FlBorderData(show: false),
                  barGroups: services
                      .asMap()
                      .entries
                      .map((entry) {
                        final idx = entry.key;
                        final svc = entry.value;
                        return BarChartGroupData(
                          x: idx,
                          barRods: [
                            BarChartRodData(
                              toY: svc.bookingCount
                                  .toDouble(),
                              color:
                                  colorScheme.primary,
                              width: 20,
                              borderRadius:
                                  const BorderRadius
                                      .only(
                                    topLeft:
                                        Radius
                                            .circular(
                                              4,
                                            ),
                                    topRight:
                                        Radius
                                            .circular(
                                              4,
                                            ),
                                  ),
                            ),
                          ],
                        );
                      })
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _maxBookings {
    final raw = services.fold<double>(
      0,
      (max, s) => s.bookingCount > max
          ? s.bookingCount.toDouble()
          : max,
    );
    // Prevent zero maxY in BarChartData.
    return raw > 0 ? raw : 1.0;
  }
}
