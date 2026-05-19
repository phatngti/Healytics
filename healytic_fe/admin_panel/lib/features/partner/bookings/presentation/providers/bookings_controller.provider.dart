import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/ws.provider.dart';
import '../../../../../core/services/ws/ws_client.dart' hide BookingStatus;
import '../../data/provider/bookings_data.provider.dart';
import '../../domain/entities/booking.entity.dart';
import '../../domain/entities/booking_filters.entity.dart';
import '../../domain/entities/booking_sort.dart';
import '../../domain/entities/booking_status.dart';
import 'booking_filter_predicates.dart';
import 'bookings_state.dart';

part 'bookings_controller.provider.g.dart';

/// The timeout applied to both the initial fetch and refresh
/// requests, per Requirements 1.2 and 6.5.
const _fetchTimeout = Duration(seconds: 10);

DateTimeRange todayBookingDateRange() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTimeRange(start: today, end: today);
}

/// Riverpod async notifier that owns the partner bookings
/// dashboard state.
///
/// On [build], fetches the booking list from the repository
/// with a 10-second timeout, applies the default sort
/// ([BookingSort.startAsc]), and computes the visible subset.
///
/// Exposes mutation methods for filtering, sorting, and
/// refreshing. Filter and sort changes recompute [visible]
/// locally without re-fetching. [refresh] re-fetches from the
/// repository, replaces [all] entirely (no merge), and
/// preserves the active [filters] and [sort].
///
/// _(Req 1.2, 1.7, 5.5, 5.6, 5.8, 5.9, 6.4, 6.5,
/// Property 10, Property 12)_
@riverpod
class BookingsController extends _$BookingsController {
  @override
  Future<BookingsState> build() async {
    final bookings = await _fetchBookings();
    return _buildState(
      all: bookings,
      filters: BookingFilters(dateRange: todayBookingDateRange()),
      sort: defaultBookingSort,
      refresh: const RefreshStatus.idle(),
    );
  }

  /// Re-fetches the booking list from the repository.
  ///
  /// Toggles [RefreshStatus.refreshing] so the UI can
  /// overlay a linear progress indicator while keeping
  /// the previous list visible and interactive. On
  /// success, **replaces** [state.all] entirely (no
  /// merge with the previous list). On failure,
  /// transitions to [RefreshStatus.failed] with a
  /// human-readable message.
  ///
  /// Preserves the active [filters] and [sort] across
  /// the refresh cycle (Property 10, Property 12).
  ///
  /// _(Req 1.7, 6.5, 6.6)_
  Future<void> refresh() async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(refresh: const RefreshStatus.refreshing()),
    );

    try {
      final bookings = await _fetchBookings();
      final newState = _buildState(
        all: bookings,
        filters: current.filters,
        sort: current.sort,
        refresh: const RefreshStatus.idle(),
      );
      state = AsyncData(newState);
    } catch (e, st) {
      developer.log(
        'Refresh failed',
        error: e,
        stackTrace: st,
        name: 'BookingsController',
      );
      state = AsyncData(
        current.copyWith(refresh: RefreshStatus.failed(e.toString())),
      );
    }
  }

  /// Updates the status filter set and recomputes [visible].
  ///
  /// An empty [statuses] set is treated as "All" (no status
  /// filter applied), per Requirement 5.1.
  void setStatusFilter(Set<BookingStatus> statuses) {
    _updateFilters((f) => f.copyWith(statuses: statuses));
  }

  /// Updates the selected booking day and recomputes [visible].
  ///
  /// Pass `null` to clear the date-range filter.
  ///
  /// _(Req 5.2)_
  void setDateRange(DateTimeRange? range) {
    _updateFilters((f) => f.copyWith(dateRange: range));
  }

  /// Updates the search query and recomputes [visible].
  ///
  /// The query is trimmed and lowercased before storage
  /// so the filter predicate can do a simple substring
  /// match without repeated normalization.
  ///
  /// _(Req 5.4)_
  void setSearchQuery(String query) {
    _updateFilters((f) => f.copyWith(searchQuery: query.trim().toLowerCase()));
  }

  /// Changes the sort ordering and recomputes [visible].
  ///
  /// Preserves the active [filters] without modification
  /// (Property 10).
  ///
  /// _(Req 5.6, 5.8)_
  void setSort(BookingSort sort) {
    final current = state.value;
    if (current == null) return;

    final visible = applySort(applyFilters(current.all, current.filters), sort);

    state = AsyncData(current.copyWith(sort: sort, visible: visible));
  }

  /// Resets all filters to their defaults and recomputes
  /// [visible].
  ///
  /// _(Req 5.10, 6.3)_
  void clearFilters() {
    final current = state.value;
    if (current == null) return;

    final cleared = BookingFilters(dateRange: todayBookingDateRange());
    final visible = applySort(applyFilters(current.all, cleared), current.sort);

    state = AsyncData(current.copyWith(filters: cleared, visible: visible));
  }

  /// Applies a lightweight realtime status event to
  /// the in-memory list so the booking card badge
  /// updates without refetching the dashboard.
  void applyStatusEvent(BookingStatusChangeEvent event) {
    final current = state.value;
    if (current == null) return;

    final nextStatus = switch (event.status) {
      PublicBookingStatus.processing => BookingStatus.onProcess,
      PublicBookingStatus.completed => BookingStatus.finished,
    };

    final all = current.all
        .map(
          (booking) => booking.id == event.bookingId
              ? booking.copyWith(status: nextStatus)
              : booking,
        )
        .toList(growable: false);

    state = AsyncData(
      current.copyWith(
        all: all,
        visible: applySort(applyFilters(all, current.filters), current.sort),
      ),
    );
  }

  // ─── Private helpers ───────────────────────────────────

  /// Fetches bookings from the repository with the
  /// configured [_fetchTimeout].
  Future<List<Booking>> _fetchBookings() {
    final repo = ref.read(bookingsRepositoryProvider);
    return repo.listBookings().timeout(_fetchTimeout);
  }

  /// Builds a [BookingsState] by applying [filters] and
  /// [sort] to [all].
  BookingsState _buildState({
    required List<Booking> all,
    required BookingFilters filters,
    required BookingSort sort,
    required RefreshStatus refresh,
  }) {
    final visible = applySort(applyFilters(all, filters), sort);
    return BookingsState(
      all: all,
      visible: visible,
      filters: filters,
      sort: sort,
      refresh: refresh,
    );
  }

  /// Applies a filter mutation and recomputes [visible].
  void _updateFilters(BookingFilters Function(BookingFilters) mutate) {
    final current = state.value;
    if (current == null) return;

    final newFilters = mutate(current.filters);
    final visible = applySort(
      applyFilters(current.all, newFilters),
      current.sort,
    );

    state = AsyncData(current.copyWith(filters: newFilters, visible: visible));
  }
}

/// Keeps the partner booking-events socket active
/// and routes status updates into [BookingsController].
@Riverpod(keepAlive: true)
void partnerBookingStatusRealtime(Ref ref) {
  final ws = ref.read(wsServiceProvider);
  ws.connectBookingEvents();

  final subscription = ws.bookingEvents.onBookingStatusChanged.listen((event) {
    ref.read(bookingsControllerProvider.notifier).applyStatusEvent(event);
  });

  ref.onDispose(subscription.cancel);
}
