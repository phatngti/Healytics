import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_completion.entity.freezed.dart';

/// Represents the full profile completion state
/// returned by the backend, including clinic identity,
/// editable fields, and the derived checklist.
@freezed
abstract class PartnerProfileCompletionEntity
    with _$PartnerProfileCompletionEntity {
  const factory PartnerProfileCompletionEntity({
    required String id,
    required ClinicIdentity clinicIdentity,
    String? coverImageUrl,
    String? logoImageUrl,
    String? description,
    @Default([]) List<String> gallery,
    @Default([]) List<PartnerCertificationItem> certifications,
    @Default([]) List<CompletionChecklistItem> checklist,
    @Default(0) int completionPercent,
    @Default(false) bool isCompleted,
  }) = _PartnerProfileCompletionEntity;
}

/// Read-only verified business identity that
/// provides context on the clinic profile page.
@freezed
abstract class ClinicIdentity with _$ClinicIdentity {
  const factory ClinicIdentity({
    required String brandName,
    required String legalName,
    @Default([]) List<String> businessType,
    String? phoneNumber,
    String? address,
  }) = _ClinicIdentity;
}

/// A single trust badge or certification displayed
/// on the public clinic profile.
@freezed
abstract class PartnerCertificationItem with _$PartnerCertificationItem {
  const factory PartnerCertificationItem({
    String? id,
    required String title,
    String? subtitle,
    required String iconName,
    @Default(0) int sortOrder,
  }) = _PartnerCertificationItem;
}

/// A single item in the server-derived completion
/// checklist indicating whether a profile section
/// has been filled in.
@freezed
abstract class CompletionChecklistItem with _$CompletionChecklistItem {
  const factory CompletionChecklistItem({
    required String key,
    required String label,
    @Default(false) bool isRequired,
    @Default(false) bool completed,
  }) = _CompletionChecklistItem;
}

/// Request payload for updating partner profile
/// completion fields. Null fields are omitted
/// (meaning "don't change").
@freezed
abstract class PartnerProfileCompletionUpdateRequest
    with _$PartnerProfileCompletionUpdateRequest {
  const factory PartnerProfileCompletionUpdateRequest({
    String? coverImageUrl,
    String? logoImageUrl,
    String? description,
    List<String>? gallery,
    List<PartnerCertificationItem>? certifications,
  }) = _PartnerProfileCompletionUpdateRequest;
}
