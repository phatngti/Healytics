import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.entity.freezed.dart';
part 'category.entity.g.dart';

/// Strongly-typed Category ID
extension type const CategoryId(String value) implements String {
  factory CategoryId.fromJson(dynamic json) => CategoryId(json as String);
  String toJson() => value;
}

/// Category entity representing a service category
@Freezed(toJson: true)
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required CategoryId id,
    required String name,
    String? parentId,
    String? parentName,
    @Default('') String description,
    @Default('category') String iconName,
    @Default(0xFF6366F1) int colorValue,
    @Default(0) int serviceCount,
    @Default(0) int subCategoryCount,
    @Default(true) bool isRoot,
    @Default(true) bool isVisible,
    @Default(0) int sortOrder,
    String? createdAt,
    String? updatedAt,
  }) = _CategoryEntity;

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);
}

/// Extension to get IconData and Color from entity
extension CategoryEntityX on CategoryEntity {
  IconData get icon {
    // Map common icon names to Material icons
    switch (iconName.toLowerCase()) {
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'plumbing':
        return Icons.plumbing;
      case 'bolt':
        return Icons.bolt;
      case 'format_paint':
        return Icons.format_paint;
      case 'yard':
        return Icons.yard;
      case 'spa':
        return Icons.spa;
      case 'category':
      default:
        return Icons.category;
    }
  }

  Color get color => Color(colorValue);
}
