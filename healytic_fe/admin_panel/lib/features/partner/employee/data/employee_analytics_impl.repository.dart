import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/employee/data/employee_analytics_remote.datasource.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_analytics_impl.repository.g.dart';

class EmployeeAnalyticsRepositoryImpl implements EmployeeAnalyticsRepository {
  EmployeeAnalyticsRepositoryImpl({required this.remoteDataSource});

  final EmployeeAnalyticsRemoteDataSource remoteDataSource;

  @override
  Future<EmployeeOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) {
    return remoteDataSource.getOverviewAnalytics(period: period);
  }

  @override
  Future<EmployeeDetailAnalytics> getDetailAnalytics({
    required EmployeeId employeeId,
    required DashboardTimePeriod period,
  }) {
    return remoteDataSource.getDetailAnalytics(
      employeeId: employeeId,
      period: period,
    );
  }
}

@riverpod
EmployeeAnalyticsRepository employeeAnalyticsRepository(Ref ref) {
  final remoteDataSource = ref.read(employeeAnalyticsRemoteDataSourceProvider);
  return EmployeeAnalyticsRepositoryImpl(remoteDataSource: remoteDataSource);
}
