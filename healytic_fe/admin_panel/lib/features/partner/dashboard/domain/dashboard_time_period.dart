/// Time period filter for dashboard data.
///
/// Controls the date range for revenue charts
/// and KPI aggregation.
enum DashboardTimePeriod {
  /// Current day.
  today,

  /// Current calendar week.
  thisWeek,

  /// Current calendar month.
  thisMonth,

  /// Current calendar quarter.
  thisQuarter,

  /// Current calendar year.
  thisYear;

  /// API query parameter value.
  String get value => switch (this) {
    today => 'today',
    thisWeek => 'this_week',
    thisMonth => 'this_month',
    thisQuarter => 'this_quarter',
    thisYear => 'this_year',
  };

  /// User-friendly display label.
  String get displayName => switch (this) {
    today => 'Today',
    thisWeek => 'This Week',
    thisMonth => 'This Month',
    thisQuarter => 'This Quarter',
    thisYear => 'This Year',
  };

  /// Parses an API value string back to enum.
  ///
  /// Falls back to [thisMonth] for unknown values.
  static DashboardTimePeriod fromValue(
    String v,
  ) =>
      switch (v) {
        'today' => today,
        'this_week' => thisWeek,
        'this_month' => thisMonth,
        'this_quarter' => thisQuarter,
        'this_year' => thisYear,
        _ => thisMonth,
      };
}
