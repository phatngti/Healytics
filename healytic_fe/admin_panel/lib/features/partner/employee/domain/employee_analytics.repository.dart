import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';

/// Repository for employee analytics read models.
abstract class EmployeeAnalyticsRepository {
  Future<EmployeeOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  });

  Future<EmployeeDetailAnalytics> getDetailAnalytics({
    required EmployeeId employeeId,
    required DashboardTimePeriod period,
  });
}
