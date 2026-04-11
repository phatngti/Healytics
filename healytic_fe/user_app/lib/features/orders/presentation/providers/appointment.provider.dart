import 'package:collection/collection.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/orders/data/provider/appointment.provider.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

part 'appointment.provider.g.dart';

// ─── Layout view ───────────────────────────────────

/// Supported visual layouts for the appointment
/// list screen.
enum AppointmentViewLayout {
  /// Full-height card with image, details, and
  /// check-in row (default).
  card('Card'),

  /// Compact horizontal row — no hero image.
  calendar('Calendar');

  const AppointmentViewLayout(this.label);

  /// Human-readable label shown in the popup menu.
  final String label;
}

// ─── Tab indices ───────────────────────────────────
/// 0 = Upcoming, 1 = Completed, 2 = Canceled
const kTabUpcoming = 0;
const kTabCompleted = 1;
const kTabCanceled = 2;

const _statusByTab = ['upcoming', 'completed', 'canceled'];

// ─── Data providers ────────────────────────────────

/// Fetches all appointments from the repository
/// and exposes a [silentRefresh] for background
/// reload without redundant re-renders.
@riverpod
class AppointmentsNotifier extends _$AppointmentsNotifier {
  static const _eq = ListEquality<AppointmentEntity>();

  @override
  Future<List<AppointmentEntity>> build() async {
    final repo = ref.watch(appointmentRepositoryProvider);
    return repo.getAppointments();
  }

  /// Re-fetches from the API and updates state
  /// only when the data has actually changed.
  Future<void> silentRefresh() async {
    final repo = ref.read(appointmentRepositoryProvider);
    final fresh = await repo.getAppointments();
    final current = state.value;

    if (current == null || !_eq.equals(current, fresh)) {
      state = AsyncData(fresh);
    }
  }
}

/// Fetches appointment category filters.
@riverpod
Future<List<AppointmentCategory>> appointmentCategories(Ref ref) async {
  final repo = ref.watch(appointmentRepositoryProvider);
  return repo.getCategories();
}

/// Fetches recommended services.
@riverpod
Future<List<RecommendedServiceEntity>> appointmentRecommendations(
  Ref ref,
) async {
  final repo = ref.watch(appointmentRepositoryProvider);
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

/// Holds the currently selected layout view mode.
@riverpod
class SelectedViewLayoutNotifier extends _$SelectedViewLayoutNotifier {
  @override
  AppointmentViewLayout build() => AppointmentViewLayout.card;

  /// Switches the appointment list layout.
  void select(AppointmentViewLayout layout) => state = layout;
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
    final matchesStatus = apt.status.toLowerCase() == statusFilter;
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

// ─── Calendar state ────────────────────────────────

/// Tracks the currently focused (visible) month
/// in calendar view. Updated on page swipe or
/// chevron tap.
@riverpod
class CalendarFocusedDayNotifier extends _$CalendarFocusedDayNotifier {
  @override
  DateTime build() => DateTime.now();

  /// Updates the focused month.
  void update(DateTime day) => state = day;
}

/// Tracks the user-selected day in calendar view.
/// Defaults to today.
@riverpod
class CalendarSelectedDayNotifier extends _$CalendarSelectedDayNotifier {
  @override
  DateTime build() => DateTime.now();

  /// Selects a new day.
  void select(DateTime day) => state = day;
}

/// Groups ALL appointments into a date-keyed map
/// for O(1) lookup by the calendar's [eventLoader].
///
/// Uses [DateUtils.dateOnly] to strip time
/// components for reliable map key matching.
@riverpod
Future<Map<DateTime, List<AppointmentEntity>>> appointmentsByDateMap(
  Ref ref,
) async {
  final all = await ref.watch(appointmentsProvider.future);
  final map = <DateTime, List<AppointmentEntity>>{};
  for (final apt in all) {
    final key = DateUtils.dateOnly(apt.date);
    map.putIfAbsent(key, () => []).add(apt);
  }
  return map;
}

/// Returns appointments for the currently selected
/// calendar day, derived from the date map +
/// selected day provider.
@riverpod
Future<List<AppointmentEntity>> appointmentsForDay(Ref ref) async {
  final map = await ref.watch(appointmentsByDateMapProvider.future);
  final selected = ref.watch(calendarSelectedDayProvider);
  final key = DateUtils.dateOnly(selected);
  return map[key] ?? [];
}
