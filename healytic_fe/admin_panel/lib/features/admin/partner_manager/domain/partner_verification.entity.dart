import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_verification.entity.freezed.dart';
part 'partner_verification.entity.g.dart';

/// Strongly-typed Partner Verification ID
extension type const PartnerVerificationId(String value) implements String {
  factory PartnerVerificationId.fromJson(dynamic json) =>
      PartnerVerificationId(json as String);
  String toJson() => value;
}

/// Status of the partner verification request
enum PartnerVerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

/// Priority level for partner verification requests
enum PartnerPriority {
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
}

/// Partner verification entity representing a partner's verification request
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
    @Default(false) bool isEmailVerified,
    String? providerId,

    /// Gradient colors for avatar (start and end color values)
    int? avatarColorStart,
    int? avatarColorEnd,
  }) = _PartnerVerificationEntity;

  factory PartnerVerificationEntity.fromJson(Map<String, dynamic> json) =>
      _$PartnerVerificationEntityFromJson(json);
}
