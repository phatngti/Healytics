import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';

/// Repository interface for partner verification operations
abstract class PartnerVerificationRepository {
  /// Get paginated list of partner verification requests
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
  });

  /// Get total count of partner verification requests
  Future<int> getTotalRows({PartnerVerificationStatus? statusFilter});

  /// Get a single partner verification by ID
  Future<PartnerVerificationEntity> getPartnerById(PartnerVerificationId id);

  /// Approve a partner verification request
  Future<void> approvePartner(PartnerVerificationId id);

  /// Reject a partner verification request
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

  /// Get dashboard statistics
  Future<PartnerVerificationStats> getStats();
}
