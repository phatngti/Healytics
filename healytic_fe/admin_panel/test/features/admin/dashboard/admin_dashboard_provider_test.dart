import 'package:admin_panel/features/admin/dashboard/datasource/admin_dashboard_impl.repository.dart';
import 'package:admin_panel/features/admin/dashboard/datasource/admin_dashboard_remote.datasource.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard.provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('AdminDashboardNotifier', () {
    late ProviderContainer container;

    setUp(() {
      final repository = AdminDashboardRepositoryImpl(
        dataSource: AdminDashboardRemoteDataSourceMock(),
      );

      container = ProviderContainer(
        overrides: [
          adminDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
    });

    test('loads dashboard data with mock-first defaults', () async {
      final state = await container.read(adminDashboardProvider.future);

      expect(state.selectedPeriod, AdminDashboardPeriod.thirtyDays);
      expect(state.failedSections, isEmpty);
      expect(state.topPartners, isNotEmpty);
      expect(state.alerts, isNotEmpty);
      expect(state.overview.grossRevenue, greaterThan(0));
    });
  });

  group('AdminDashboardRepositoryImpl', () {
    final repository = AdminDashboardRepositoryImpl(
      dataSource: AdminDashboardRemoteDataSourceMock(),
    );

    test('returns distinct snapshots for different periods', () async {
      final sevenDay = await repository.getOverview(
        AdminDashboardPeriod.sevenDays,
      );
      final thirtyDay = await repository.getOverview(
        AdminDashboardPeriod.thirtyDays,
      );

      expect(sevenDay.grossRevenue, isNot(equals(thirtyDay.grossRevenue)));
      expect(
        sevenDay.bookingSuccessRate,
        isNot(equals(thirtyDay.bookingSuccessRate)),
      );
    });
  });
}
