import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/data/provider/appointment.provider.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

part 'appointment.provider.g.dart';

// ─── Tab indices ───────────────────────────────────
/// 0 = Upcoming, 1 = Completed, 2 = Canceled
const kTabUpcoming = 0;
const kTabCompleted = 1;
const kTabCanceled = 2;

const _statusByTab = ['upcoming', 'completed', 'canceled'];

// ─── Data providers ────────────────────────────────

/// Fetches all appointments from the repository.
@riverpod
Future<List<AppointmentEntity>> appointments(Ref ref) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getAppointments();
}

/// Fetches appointment category filters.
@riverpod
Future<List<AppointmentCategory>> appointmentCategories(Ref ref) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getCategories();
}

/// Fetches recommended services.
@riverpod
Future<List<RecommendedServiceEntity>> appointmentRecommendations(
  Ref ref,
) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getRecommendations();
}

// ─── Filter state ──────────────────────────────────

/// Holds the currently selected tab index.
@riverpod
class SelectedTabNotifier extends _$SelectedTabNotifier {
  @override
  int build() => kTabUpcoming;

  /// Updates the active tab.
  void select(int index) => state = index;
}

/// Holds the currently selected category id.
@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  @override
  String build() => 'cat-all';

  /// Updates the active category.
  void select(String categoryId) => state = categoryId;
}

/// Derived provider that filters appointments by
/// the current tab and category selection.
@riverpod
Future<List<AppointmentEntity>> filteredAppointments(Ref ref) async {
  final all = await ref.watch(appointmentsProvider.future);
  final tab = ref.watch(selectedTabProvider);
  final categoryId = ref.watch(selectedCategoryProvider);

  final statusFilter = _statusByTab[tab];

  return all.where((apt) {
    final matchesStatus = apt.status == statusFilter;
    final matchesCategory =
        categoryId == 'cat-all' ||
        apt.category == categoryId.replaceFirst('cat-', '');
    return matchesStatus && matchesCategory;
  }).toList();
}

/// Fetches a single appointment by its [id].
@riverpod
Future<AppointmentEntity?> appointmentById(Ref ref, String id) async {
  final repo = ref.read(appointmentRepositoryProvider);
  return repo.getAppointmentById(id);
}
