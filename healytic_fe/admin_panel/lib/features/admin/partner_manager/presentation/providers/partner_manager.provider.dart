import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_impl.repository.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ────────────────────────────────────────────────────
// Workspace Notifier
// ────────────────────────────────────────────────────

/// Notifier managing the partner manager workspace
/// state: tab scope, search, filters, sort, and
/// reload token.
class PartnerManagerWorkspaceNotifier
    extends Notifier<PartnerManagerState> {
  @override
  PartnerManagerState build() {
    return const PartnerManagerState();
  }

  /// Switches the active tab scope and resets filters.
  void setScope(PartnerManagerScope scope) {
    state = state.copyWith(
      scope: scope,
      clearStatusFilter: true,
      searchQuery: '',
      reloadToken: state.reloadToken + 1,
    );
  }

  /// Updates the search query and bumps reload.
  void setSearchQuery(String value) {
    state = state.copyWith(
      searchQuery: value,
      reloadToken: state.reloadToken + 1,
    );
  }

  /// Sets an explicit status filter.
  void setStatusFilter(
    PartnerVerificationStatus? value,
  ) {
    state = state.copyWith(
      statusFilter: value,
      clearStatusFilter: value == null,
      reloadToken: state.reloadToken + 1,
    );
  }

  /// Updates the sort column and direction.
  void setSort(String sortBy, bool sortAsc) {
    state = state.copyWith(
      sortBy: sortBy,
      sortAsc: sortAsc,
      reloadToken: state.reloadToken + 1,
    );
  }

  /// Forces a data refresh without changing filters.
  void bumpReload() {
    state = state.copyWith(
      reloadToken: state.reloadToken + 1,
    );
  }

  /// Resets all filters to defaults, keeping the
  /// current tab scope.
  void resetFilters() {
    state = PartnerManagerState(
      scope: state.scope,
      reloadToken: state.reloadToken + 1,
    );
  }
}

final partnerManagerWorkspaceProvider =
    NotifierProvider<
      PartnerManagerWorkspaceNotifier,
      PartnerManagerState
    >(PartnerManagerWorkspaceNotifier.new);

// ────────────────────────────────────────────────────
// Async Data Providers
// ────────────────────────────────────────────────────

/// Dashboard statistics provider. Rebuilds whenever
/// the workspace state changes.
final partnerVerificationStatsProvider =
    FutureProvider<PartnerVerificationStats>(
  (ref) async {
    final ws = ref.watch(partnerManagerWorkspaceProvider);
    return ref
        .read(partnerVerificationRepositoryProvider)
        .getStats(
          scope: ws.scope,
          searchQuery: ws.searchQuery.isNotEmpty
              ? ws.searchQuery
              : null,
        );
  },
);
