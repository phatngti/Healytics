/// Display status for upcoming appointments.
///
/// Maps from backend [BookingStatus] to
/// user-facing display values.
enum AppointmentDisplayStatus {
  confirmed('confirmed'),
  pending('pending');

  const AppointmentDisplayStatus(this.value);

  /// API response value.
  final String value;
}

/// Notification type categories for dashboard.
///
/// Groups backend [NotificationType] values into
/// dashboard-friendly categories.
enum DashboardNotificationType {
  appointment('appointment'),
  review('review'),
  system('system'),
  alert('alert');

  const DashboardNotificationType(this.value);

  /// API response value.
  final String value;
}

/// Severity level for inventory alerts.
enum AlertSeverity {
  info('info'),
  warning('warning'),
  critical('critical');

  const AlertSeverity(this.value);

  /// API response value.
  final String value;
}
