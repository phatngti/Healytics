import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';

/// Immutable workspace state for the admin partner
/// manager screen. Tracks active tab, search,
/// filters, sort, and a reload token for data
/// invalidation.
class PartnerManagerState {
  const PartnerManagerState({
    this.scope = PartnerManagerScope.verificationQueue,
    this.searchQuery = '',
    this.statusFilter,
    this.sortBy = 'createdAt',
    this.sortAsc = false,
    this.reloadToken = 0,
  });

  final PartnerManagerScope scope;
  final String searchQuery;
  final PartnerVerificationStatus? statusFilter;
  final String sortBy;
  final bool sortAsc;
  final int reloadToken;

  PartnerManagerState copyWith({
    PartnerManagerScope? scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    bool clearStatusFilter = false,
    String? sortBy,
    bool? sortAsc,
    int? reloadToken,
  }) {
    return PartnerManagerState(
      scope: scope ?? this.scope,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      sortBy: sortBy ?? this.sortBy,
      sortAsc: sortAsc ?? this.sortAsc,
      reloadToken: reloadToken ?? this.reloadToken,
    );
  }
}
