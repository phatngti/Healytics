import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_remote.datasource.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.repository.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_verification_impl.repository.g.dart';

/// Implementation of [PartnerVerificationRepository] delegating to data source
class PartnerVerificationRepositoryImpl
    implements PartnerVerificationRepository {
  final PartnerVerificationRemoteDataSource dataSource;

  PartnerVerificationRepositoryImpl({required this.dataSource});

  @override
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  }) => dataSource.getPartnerVerifications(
    startingAt: startingAt,
    count: count,
    sortedBy: sortedBy,
    sortedAsc: sortedAsc,
    statusFilter: statusFilter,
  );

  @override
  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter}) =>
      dataSource.getTotalRows(statusFilter: statusFilter);

  @override
  Future<PartnerVerificationEntity> getPartnerById(PartnerVerificationId id) =>
      dataSource.getPartnerById(id);

  @override
  Future<void> approvePartner(PartnerVerificationId id) =>
      dataSource.approvePartner(id);

  @override
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason}) =>
      dataSource.rejectPartner(id, reason: reason);

  @override
  Future<PartnerVerificationStats> getStats() => dataSource.getStats();
}

@riverpod
PartnerVerificationRepository partnerVerificationRepository(Ref ref) {
  final dataSource = ref.read(partnerVerificationRemoteDataSourceProvider);
  return PartnerVerificationRepositoryImpl(dataSource: dataSource);
}
