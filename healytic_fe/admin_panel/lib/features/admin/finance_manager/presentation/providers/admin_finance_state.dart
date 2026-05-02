import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';

/// Immutable workspace state for the admin finance
/// manager screen. Tracks active tab, period, filters,
/// and a reload token for data invalidation.
class AdminFinanceWorkspaceState {
  const AdminFinanceWorkspaceState({
    this.activeTab = AdminFinanceWorkspaceTab.overview,
    this.period = AdminFinancePeriod.thirtyDays,
    this.filter = const AdminFinanceFilter(),
    this.reloadToken = 0,
  });

  final AdminFinanceWorkspaceTab activeTab;
  final AdminFinancePeriod period;
  final AdminFinanceFilter filter;
  final int reloadToken;

  AdminFinanceWorkspaceState copyWith({
    AdminFinanceWorkspaceTab? activeTab,
    AdminFinancePeriod? period,
    AdminFinanceFilter? filter,
    int? reloadToken,
  }) {
    return AdminFinanceWorkspaceState(
      activeTab: activeTab ?? this.activeTab,
      period: period ?? this.period,
      filter: filter ?? this.filter,
      reloadToken: reloadToken ?? this.reloadToken,
    );
  }
}
