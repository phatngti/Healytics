import 'package:admin_panel/features/admin/dashboard/datasource/data/admin_dashboard_mock_data.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminDashboardMockData integrity', () {
    for (final period in AdminDashboardPeriod.values) {
      test('${period.name} booking outcomes reconcile with totals', () {
        final outcomes = AdminDashboardMockData.bookingOutcomes(period);
        final total =
            outcomes.success.count +
            outcomes.failed.count +
            outcomes.canceled.count;
        final combinedRate =
            outcomes.success.rate +
            outcomes.failed.rate +
            outcomes.canceled.rate;

        expect(total, outcomes.totalBookings);
        expect(combinedRate, closeTo(100, 0.2));
      });

      test('${period.name} transaction health reconciles with totals', () {
        final health = AdminDashboardMockData.transactionHealth(period);
        final total =
            health.paid +
            health.pending +
            health.refunded +
            health.failed +
            health.canceled;

        expect(total, health.totalTransactions);
      });

      test('${period.name} rankings fit inside overview revenue envelope', () {
        final overview = AdminDashboardMockData.overview(period);
        final partnerRevenue = AdminDashboardMockData.topPartners(
          period,
        ).fold<double>(0, (sum, item) => sum + item.grossRevenue);
        final serviceRevenue = AdminDashboardMockData.topServices(
          period,
        ).fold<double>(0, (sum, item) => sum + item.grossRevenue);

        expect(partnerRevenue, lessThan(overview.grossRevenue));
        expect(serviceRevenue, lessThan(overview.grossRevenue));
      });
    }
  });
}
