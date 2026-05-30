import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.entity.freezed.dart';
part 'category.entity.g.dart';

@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
    @Default(true) bool isActive,
    String? parentId,
    String? parentName,
    @Default(true) bool isRoot,
  }) = _CategoryEntity;

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);
}
