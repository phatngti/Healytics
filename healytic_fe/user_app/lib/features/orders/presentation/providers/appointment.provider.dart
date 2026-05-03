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
/// 0 = Pending Payment, 1 = Upcoming,
/// 2 = Completed, 3 = Canceled
const kTabPendingPayment = 0;
const kTabUpcoming = 1;
const kTabCompleted = 2;
const kTabCanceled = 3;

const _statusByTab = [
  'pending_payment',
  'upcoming',
  'completed',
  'canceled',
];

// ─── Data providers ────────────────────────────────

/// Fetches appointments filtered by the current
/// tab (status) and category selection using
/// server-side filtering.
@riverpod
class FilteredAppointmentsNotifier
    extends _$FilteredAppointmentsNotifier {
  @override
  Future<List<AppointmentEntity>> build() async {
    final repo = ref.watch(
      appointmentRepositoryProvider,
    );
    final tab = ref.watch(selectedTabProvider);
    final categoryId = ref.watch(
      selectedCategoryProvider,
    );

    final status = _statusByTab[tab];
    final resolvedCategory =
        categoryId == 'cat-all'
            ? null
            : categoryId.replaceFirst('cat-', '');

    return repo.getAppointments(
      status: status,
      categoryId: resolvedCategory,
    );
  }

  /// Re-fetches from the API and updates state
  /// only when the data has actually changed.
  Future<void> silentRefresh() async {
    final repo = ref.read(
      appointmentRepositoryProvider,
    );
    final tab = ref.read(selectedTabProvider);
    final categoryId = ref.read(
      selectedCategoryProvider,
    );

    final status = _statusByTab[tab];
    final resolvedCategory =
        categoryId == 'cat-all'
            ? null
            : categoryId.replaceFirst('cat-', '');

    final fresh = await repo.getAppointments(
      status: status,
      categoryId: resolvedCategory,
    );
    final current = state.value;

    if (current == null ||
        !_eq.equals(current, fresh)) {
      state = AsyncData(fresh);
    }
  }

  static const _eq =
      ListEquality<AppointmentEntity>();
}

/// Legacy-compatible alias. Widgets that still
/// reference [appointmentsProvider] will get the
/// same filtered data.
@riverpod
Future<List<AppointmentEntity>> appointments(
  Ref ref,
) {
  return ref.watch(
    filteredAppointmentsProvider.future,
  );
}

/// Fetches appointment category filters.
@riverpod
Future<List<AppointmentCategory>>
    appointmentCategories(Ref ref) async {
  final repo = ref.watch(
    appointmentRepositoryProvider,
  );
  return repo.getCategories();
}

/// Fetches recommended services.
@riverpod
Future<List<RecommendedServiceEntity>>
    appointmentRecommendations(Ref ref) async {
  final repo = ref.watch(
    appointmentRepositoryProvider,
  );
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
class SelectedCategoryNotifier
    extends _$SelectedCategoryNotifier {
  @override
  String build() => 'cat-all';

  /// Updates the active category.
  void select(String categoryId) =>
      state = categoryId;
}

/// Holds the currently selected layout view mode.
@riverpod
class SelectedViewLayoutNotifier
    extends _$SelectedViewLayoutNotifier {
  @override
  AppointmentViewLayout build() =>
      AppointmentViewLayout.card;

  /// Switches the appointment list layout.
  void select(AppointmentViewLayout layout) =>
      state = layout;
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
