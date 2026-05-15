import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification.entity.freezed.dart';
part 'partner_verification.entity.g.dart';

/// Strongly-typed Partner Verification ID
extension type const PartnerVerificationId(String value) implements String {
  factory PartnerVerificationId.fromJson(dynamic json) =>
      PartnerVerificationId(json as String);
  String toJson() => value;
}

/// Status of the partner verification request.
/// Matches backend PartnerVerificationStatus enum.
enum PartnerVerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('requiredResubmit')
  requiredResubmit,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

/// Priority level for partner verification requests.
/// Backend has low/normal/high/urgent but frontend
/// folds low→normal and urgent→high for v1 UI.
enum PartnerPriority {
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
}

/// Scope tabs for the partner manager workspace.
enum PartnerManagerScope {
  /// Verification queue: PENDING + REQUIRED_RESUBMIT
  verificationQueue,

  /// All providers: every status
  allProviders,
}

/// Partner verification entity representing
/// a partner's verification request in the list.
@Freezed(toJson: true)
abstract class PartnerVerificationEntity with _$PartnerVerificationEntity {
  const factory PartnerVerificationEntity({
    required PartnerVerificationId id,
    required String name,
    @Default('') String initials,
    @Default([]) List<String> serviceTypes,
    required DateTime submittedAt,
    @Default(PartnerPriority.normal) PartnerPriority priority,
    @Default(PartnerVerificationStatus.pending)
    PartnerVerificationStatus status,
    @Default(false) bool isAccountActive,
    String? providerId,

    /// Gradient colors for avatar
    int? avatarColorStart,
    int? avatarColorEnd,
  }) = _PartnerVerificationEntity;

  factory PartnerVerificationEntity.fromJson(Map<String, dynamic> json) =>
      _$PartnerVerificationEntityFromJson(json);
}

/// Paginated partner verification list response.
class PartnerVerificationPageEntity {
  const PartnerVerificationPageEntity({
    required this.items,
    required this.total,
  });

  final List<PartnerVerificationEntity> items;
  final int total;
}
