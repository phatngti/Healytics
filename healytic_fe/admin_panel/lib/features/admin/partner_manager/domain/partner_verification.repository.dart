import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';

/// Repository interface for partner verification
/// operations. Clean Architecture boundary — no
/// Flutter or API imports.
abstract class PartnerVerificationRepository {
  /// Get paginated list of partner verification requests.
  Future<List<PartnerVerificationEntity>> getPartnerVerifications({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get one page plus its matching filtered total.
  Future<PartnerVerificationPageEntity> getPartnerVerificationPage({
    required int startingAt,
    required int count,
    required PartnerManagerScope scope,
    String? searchQuery,
    String? sortedBy,
    bool? sortedAsc,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get total count matching current filters.
  Future<int> getTotalRows({
    required PartnerManagerScope scope,
    String? searchQuery,
    PartnerVerificationStatus? statusFilter,
    PartnerManagerQuickFilter? quickFilter,
  });

  /// Get detailed partner verification information
  /// for review page.
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  );

  /// Approve a partner verification request.
  Future<void> approvePartner(PartnerVerificationId id);

  /// Reject a partner verification request.
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

  /// Submit a review decision for a partner with
  /// optional field-level feedback.
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  });

  /// Get dashboard statistics.
  Future<PartnerVerificationStats> getStats({
    PartnerManagerScope scope,
    String? searchQuery,
  });
}
