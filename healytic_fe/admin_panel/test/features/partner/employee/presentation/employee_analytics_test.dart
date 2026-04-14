import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/employee/data/employee_analytics_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/data/employee_analytics_remote.datasource.dart';
import 'package:admin_panel/features/partner/employee/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_analytics.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_analytics/employee_detail_analytics.widget.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_analytics/employee_overview_analytics.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('Employee analytics providers', () {
    late ProviderContainer container;

    setUp(() {
      final repository = EmployeeAnalyticsRepositoryImpl(
        remoteDataSource: EmployeeAnalyticsRemoteDataSourceMock(),
      );

      container = ProviderContainer(
        overrides: [
          employeeAnalyticsRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    test('loads overview analytics and switches period', () async {
      final subscription = container.listen(
        employeeOverviewAnalyticsProvider,
        (_, __) {},
      );
      addTearDown(subscription.close);

      final initial = await container.read(
        employeeOverviewAnalyticsProvider.future,
      );

      expect(initial, isNotNull);
      expect(initial.analytics.totalEmployees, greaterThan(0));
      expect(initial.selectedPeriod, DashboardTimePeriod.thisMonth);

      await container
          .read(employeeOverviewAnalyticsProvider.notifier)
          .setTimePeriod(DashboardTimePeriod.thisYear);

      final updated = await container.read(
        employeeOverviewAnalyticsProvider.future,
      );

      expect(updated, isNotNull);
      expect(updated!.selectedPeriod, DashboardTimePeriod.thisYear);
      expect(
        updated.analytics.utilizationRate,
        greaterThanOrEqualTo(initial.analytics.utilizationRate),
      );
    });
  });

  group('Employee analytics widgets', () {
    testWidgets('renders overview analytics section', (tester) async {
      final repository = EmployeeAnalyticsRepositoryImpl(
        remoteDataSource: EmployeeAnalyticsRemoteDataSourceMock(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            employeeAnalyticsRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: EmployeeOverviewAnalyticsSection(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Team Performance'), findsOneWidget);
      expect(find.text('Role distribution'), findsOneWidget);
      expect(find.text('Compliance posture'), findsOneWidget);
    });

    testWidgets('renders detail analytics section', (tester) async {
      final repository = EmployeeAnalyticsRepositoryImpl(
        remoteDataSource: EmployeeAnalyticsRemoteDataSourceMock(),
      );
      final employee = createMockDoctor(const EmployeeId('mock-doc-test'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            employeeAnalyticsRepositoryProvider.overrideWithValue(repository),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: EmployeeDetailAnalyticsSection(employee: employee),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Doctor analytics'), findsOneWidget);
      expect(find.text('Quality and compliance'), findsOneWidget);
    });
  });
}
