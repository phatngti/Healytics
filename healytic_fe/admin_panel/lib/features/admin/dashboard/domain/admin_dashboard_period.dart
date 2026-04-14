enum AdminDashboardPeriod {
  sevenDays('7d', '7D'),
  thirtyDays('30d', '30D'),
  ninetyDays('90d', '90D');

  const AdminDashboardPeriod(this.apiValue, this.label);

  final String apiValue;
  final String label;
}
