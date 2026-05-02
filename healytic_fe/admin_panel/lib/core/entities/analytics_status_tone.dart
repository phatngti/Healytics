/// Semantic tone for analytics status badges and indicators.
///
/// Used across domain entities, data sources, and presentation
/// widgets to express the severity or sentiment of a metric.
/// This enum is intentionally Flutter-free so it can be used
/// in the domain layer without violating Clean Architecture.
enum AnalyticsStatusTone {
  /// Default / informational tone.
  neutral,

  /// Good / healthy metric.
  positive,

  /// Needs attention but not critical.
  warning,

  /// Requires immediate action.
  critical,
}
