import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_manual.entity.freezed.dart';
part 'service_manual.entity.g.dart';

/// Domain entity for a service rule within the manual.
@Freezed(toJson: true)
abstract class ServiceRuleEntity with _$ServiceRuleEntity {
  const factory ServiceRuleEntity({
    required String iconSlug,
    required String title,
    required String description,
  }) = _ServiceRuleEntity;

  factory ServiceRuleEntity.fromJson(Map<String, dynamic> json) =>
      _$ServiceRuleEntityFromJson(json);
}

/// Domain entity for a procedure step within the manual.
@Freezed(toJson: true)
abstract class ProcedureStepEntity with _$ProcedureStepEntity {
  const factory ProcedureStepEntity({
    required int stepNumber,
    required String title,
    required String description,
  }) = _ProcedureStepEntity;

  factory ProcedureStepEntity.fromJson(Map<String, dynamic> json) =>
      _$ProcedureStepEntityFromJson(json);
}

/// Domain entity representing the full service manual.
///
/// Contains pre-service guidelines, service rules,
/// and procedure steps for a health service.
@Freezed(toJson: true)
abstract class ServiceManualEntity with _$ServiceManualEntity {
  const factory ServiceManualEntity({
    @Default([]) List<String> preServiceGuidelines,
    @Default([]) List<ServiceRuleEntity> serviceRules,
    @Default([]) List<ProcedureStepEntity> procedureSteps,
  }) = _ServiceManualEntity;

  factory ServiceManualEntity.fromJson(Map<String, dynamic> json) =>
      _$ServiceManualEntityFromJson(json);
}
