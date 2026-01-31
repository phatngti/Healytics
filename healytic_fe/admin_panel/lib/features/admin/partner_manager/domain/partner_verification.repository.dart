import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
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

  /// Get detailed partner verification information for review page
  Future<PartnerVerificationDetailEntity> getPartnerDetailById(
    PartnerVerificationId id,
  );

  /// Approve a partner verification request
  Future<void> approvePartner(PartnerVerificationId id);

  /// Reject a partner verification request
  Future<void> rejectPartner(PartnerVerificationId id, {String? reason});

  /// Submit a review decision for a partner with optional field-level feedback.
  ///
  /// [id] - The partner ID to review.
  /// [decision] - The review decision: 'APPROVED', 'CHANGES_REQUIRED', or 'REJECTED'.
  /// [generalComment] - Optional general comment/note for the review.
  /// [fieldFeedback] - Map of fieldKey to feedback note for fields requiring revision.
  Future<void> reviewPartner(
    PartnerVerificationId id, {
    required String decision,
    String? generalComment,
    Map<String, String?>? fieldFeedback,
  });

  /// Get dashboard statistics
  Future<PartnerVerificationStats> getStats();
}
