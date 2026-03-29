import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/employee/domain/entities/employee_preview.entity.dart';

part 'employee_preview_cache.provider.g.dart';

/// In-memory cache of [EmployeePreview] data keyed
/// by employee ID.
///
/// Callers seed this cache before navigating to
/// [EmployeeDetailScreen] so the screen can render
/// an instant partial header while the full detail
/// loads in the background.
@Riverpod(keepAlive: true)
class EmployeePreviewCache extends _$EmployeePreviewCache {
  @override
  Map<String, EmployeePreview> build() => {};

  /// Stores a preview for later retrieval.
  void seed(EmployeePreview preview) {
    state = {...state, preview.id: preview};
  }

  /// Retrieves a cached preview by [id],
  /// or `null` if none was seeded.
  EmployeePreview? get(String id) => state[id];
}
