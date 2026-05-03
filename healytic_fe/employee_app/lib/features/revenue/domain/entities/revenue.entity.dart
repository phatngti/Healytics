/// Time period for revenue filtering.
enum RevenuePeriod {
  day,
  month,
  year;

  String get displayLabel => switch (this) {
    day => 'Day',
    month => 'Month',
    year => 'Year',
  };
}

/// High-level revenue summary for a period.
class RevenueSummaryEntity {
  final double totalRevenue;
  final double totalCommission;
  final double netEarnings;
  final int completedAppointments;
  final int canceledAppointments;
  final RevenuePeriod period;
  final DateTime periodStart;
  final DateTime periodEnd;

  const RevenueSummaryEntity({
    required this.totalRevenue,
    required this.totalCommission,
    required this.netEarnings,
    required this.completedAppointments,
    required this.canceledAppointments,
    required this.period,
    required this.periodStart,
    required this.periodEnd,
  });
}

/// A single data point in the revenue trend chart.
class RevenueDataPoint {
  final DateTime date;
  final double amount;
  final String label;

  const RevenueDataPoint({
    required this.date,
    required this.amount,
    required this.label,
  });
}

/// Revenue breakdown by service category.
class RevenueBreakdownItem {
  final String serviceName;
  final int count;
  final double totalAmount;

  const RevenueBreakdownItem({
    required this.serviceName,
    required this.count,
    required this.totalAmount,
  });
}
