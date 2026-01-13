import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_service_tag.request.freezed.dart';
part 'create_service_tag.request.g.dart';

/// Request model for creating a new service tag
@Freezed(toJson: true)
abstract class CreateServiceTagRequest with _$CreateServiceTagRequest {
  const factory CreateServiceTagRequest({
    required String name,
    @Default('') String description,
    @Default(0xFF6366F1) int colorValue,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
  }) = _CreateServiceTagRequest;

  factory CreateServiceTagRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateServiceTagRequestFromJson(json);
}
