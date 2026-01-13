import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category.request.freezed.dart';
part 'create_category.request.g.dart';

/// Request model for creating a new category
@Freezed(toJson: true)
abstract class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String name,
    @Default('') String description,
    @Default('category') String iconName,
    @Default(0xFF6366F1) int colorValue,
    @Default(true) bool isVisible,
    @Default(0) int sortOrder,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}
