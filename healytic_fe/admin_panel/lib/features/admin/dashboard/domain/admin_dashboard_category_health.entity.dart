import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_category_health.entity.freezed.dart';
part 'admin_dashboard_category_health.entity.g.dart';

@freezed
abstract class AdminCategorySnapshot with _$AdminCategorySnapshot {
  const factory AdminCategorySnapshot({
    required String id,
    required String name,
    @Default(0) int serviceCount,
    @Default(true) bool isActive,
  }) = _AdminCategorySnapshot;

  factory AdminCategorySnapshot.fromJson(Map<String, dynamic> json) =>
      _$AdminCategorySnapshotFromJson(json);
}

@freezed
abstract class AdminCategoryHealth with _$AdminCategoryHealth {
  const factory AdminCategoryHealth({
    @Default(0) int totalCategories,
    @Default(0) int activeCategories,
    @Default(0) int inactiveCategories,
    @Default(0) int emptyCategories,
    @Default(0) int totalMappedServices,
    @Default([]) List<AdminCategorySnapshot> topCategories,
  }) = _AdminCategoryHealth;

  factory AdminCategoryHealth.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryHealthFromJson(json);
}
