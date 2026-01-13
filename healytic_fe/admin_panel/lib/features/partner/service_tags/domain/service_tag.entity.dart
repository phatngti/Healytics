import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_tag.entity.freezed.dart';
part 'service_tag.entity.g.dart';

/// Strongly-typed Service Tag ID
extension type const ServiceTagId(String value) implements String {
  factory ServiceTagId.fromJson(dynamic json) => ServiceTagId(json as String);
  String toJson() => value;
}

/// Service tag entity representing a tag for categorizing services
@Freezed(toJson: true)
abstract class ServiceTagEntity with _$ServiceTagEntity {
  const factory ServiceTagEntity({
    required ServiceTagId id,
    required String name,
    @Default('') String description,
    @Default(0xFF6366F1) int colorValue,
    @Default(0) int usage,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
    String? createdAt,
    String? updatedAt,
  }) = _ServiceTagEntity;

  factory ServiceTagEntity.fromJson(Map<String, dynamic> json) =>
      _$ServiceTagEntityFromJson(json);
}

/// Extension to get Color from entity
extension ServiceTagEntityX on ServiceTagEntity {
  Color get color => Color(colorValue);
}
