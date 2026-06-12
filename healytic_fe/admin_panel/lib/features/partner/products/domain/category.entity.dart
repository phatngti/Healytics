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

extension CategoryEntityDisplay on CategoryEntity {
  String get categoryDisplayName {
    final parent = parentName?.trim();
    if (parent != null && parent.isNotEmpty) {
      return parent;
    }

    if (hasParentCategory) {
      return '';
    }

    return name.trim();
  }

  String get subCategoryDisplayName {
    final value = name.trim();
    if (value.isEmpty || !hasParentCategory) {
      return '';
    }

    return value;
  }

  bool get hasParentCategory {
    final parent = parentName?.trim();
    final parentCategoryId = parentId?.trim();
    return !isRoot ||
        (parent != null && parent.isNotEmpty) ||
        (parentCategoryId != null && parentCategoryId.isNotEmpty);
  }
}
