import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_remote.datasource.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.repository.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_verification_impl.repository.g.dart';

/// Implementation of [PartnerVerificationRepository]
/// delegating to the remote data source.
class PartnerVerificationRepositoryImpl
    implements PartnerVerificationRepository {
  final PartnerVerificationRemoteDataSource dataSource;

  PartnerVerificationRepositoryImpl({required this.dataSource});

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) => dataSource.getPartnerVerifications(
    startingAt: startingAt,
    count: count,
    scope: scope,
    searchQuery: searchQuery,
    sortedBy: sortedBy,
    sortedAsc: sortedAsc,
    statusFilter: statusFilter,
  );

  @override
  Future<PartnerVerificationPageEntity> getPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) => dataSource.getPartnerVerificationPage(
    startingAt: startingAt,
    count: count,
    scope: scope,
    searchQuery: searchQuery,
    sortedBy: sortedBy,
    sortedAsc: sortedAsc,
    statusFilter: statusFilter,
  );

  @override
  Future<int> getTotalRows({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
  }) => dataSource.getTotalRows(
    scope: scope,
    searchQuery: searchQuery,
    statusFilter: statusFilter,
  );

  @override
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  ) => dataSource.getPartnerDetailById(id);

  @override
  Future<void> approvePartner(PartnerVerificationId id) =>
      dataSource.approvePartner(id);

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) =>
      dataSource.rejectPartner(id, reason: reason);

  @override
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  }) => dataSource.reviewPartner(
    id,
    decision: decision,
    generalComment: generalComment,
    fieldFeedback: fieldFeedback,
  );

  @override
  Future<PartnerVerificationStats> getStats({
    PartnerManagerScope scope = PartnerManagerScope.verificationQueue,
    String? searchQuery,
  }) => dataSource.getStats(scope: scope, searchQuery: searchQuery);
}

@riverpod
PartnerVerificationRepository partnerVerificationRepository(Ref ref) {
  final dataSource = ref.read(partnerVerificationRemoteDataSourceProvider);
  return PartnerVerificationRepositoryImpl(dataSource: dataSource);
}
