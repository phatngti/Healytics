import 'package:intl/intl.dart';

import '../../domain/entities/booking.entity.dart';
import '../../domain/entities/booking_filters.entity.dart';
import '../../domain/entities/booking_slot.entity.dart';
import '../../domain/entities/booking_sort.dart';
import '../../domain/entities/booking_status.dart';

/// Filters [bookings] by the active [filters].
///
/// Three independent predicates are combined with logical AND:
///
/// 1. **Status set membership** — when [filters.statuses] is
///    non-empty, only bookings whose status is in the set pass.
///    An empty set is treated as "All" (no status filter).
/// 2. **Date range** — when [filters.dateRange] is non-null,
///    only bookings whose `slot.start` falls within the
///    inclusive range `[start 00:00:00, end 23:59:59]` in local
///    time pass.
/// 3. **Search query** — when [filters.searchQuery] is
///    non-empty (already trimmed and lowercased upstream), a
///    case-insensitive substring match is applied against
///    customer full name, specialist full name, and service
///    name. A booking passes if any of the three contains the
///    query.
///
/// Returns a new list; the input is not mutated.
///
/// _(Req 5.1, 5.2, 5.4; Property 8)_
List<Booking> applyFilters(List<Booking> bookings, BookingFilters filters) {
  final statuses = filters.statuses;
  final range = filters.dateRange;
  final query = filters.searchQuery;

  return bookings.where((b) {
    if (statuses.isNotEmpty && !statuses.contains(b.status)) {
      return false;
    }
    if (range != null && !_isInDateRange(b.slot.start, range)) {
      return false;
    }
    if (query.isNotEmpty && !_matchesSearch(b, query)) {
      return false;
    }
    return true;
  }).toList();
}

/// Returns `true` when [dateTime] falls within the inclusive
/// day range `[start 00:00:00, end 23:59:59]` in local time.
bool _isInDateRange(DateTime dateTime, dynamic range) {
  final local = dateTime.toLocal();
  final start = DateTime(range.start.year, range.start.month, range.start.day);
  final end = DateTime(
    range.end.year,
    range.end.month,
    range.end.day,
    23,
    59,
    59,
  );
  return !local.isBefore(start) && !local.isAfter(end);
}

/// Returns `true` when the trimmed, lowercased [query]
/// appears as a substring in any of the booking's searchable
/// name fields.
bool _matchesSearch(Booking booking, String query) {
  final names = [
    booking.customer.fullName,
    booking.specialist.fullName,
    booking.service.name,
  ];
  return names.any((n) => n.toLowerCase().contains(query));
}

/// Sorts [bookings] according to [sort].
///
/// - [BookingSort.startAsc] — `slot.start` ascending.
/// - [BookingSort.startDesc] — `slot.start` descending.
/// - [BookingSort.statusGrouping] — groups by status in the
///   order Waiting → OnProcess → Finished → Canceled, with
///   `slot.start` ascending as the tiebreaker within each
///   group.
///
/// Returns a new sorted list; the input is not mutated.
///
/// _(Req 5.6, 5.7; Property 9)_
List<Booking> applySort(List<Booking> bookings, BookingSort sort) {
  final sorted = List<Booking>.of(bookings);
  switch (sort) {
    case BookingSort.startAsc:
      sorted.sort((a, b) => a.slot.start.compareTo(b.slot.start));
    case BookingSort.startDesc:
      sorted.sort((a, b) => b.slot.start.compareTo(a.slot.start));
    case BookingSort.statusGrouping:
      sorted.sort((a, b) {
        final cmp = _statusOrder(a.status).compareTo(_statusOrder(b.status));
        if (cmp != 0) return cmp;
        return a.slot.start.compareTo(b.slot.start);
      });
  }
  return sorted;
}

/// Canonical ordering index for status grouping.
///
/// Waiting(0) → OnProcess(1) → Finished(2) → Canceled(3).
int _statusOrder(BookingStatus status) => switch (status) {
  BookingStatus.waiting => 0,
  BookingStatus.onProcess => 1,
  BookingStatus.finished => 2,
  BookingStatus.canceled => 3,
};

/// Formats [price] with 2 fractional digits using a
/// locale-aware currency formatter keyed by [currencyCode].
///
/// Uses `NumberFormat.currency` from `package:intl` so the
/// output respects the locale's grouping separators and
/// decimal point.
///
/// _(Req 2.3)_
String formatPrice(double price, String currencyCode) {
  final locale = currencyCode.toUpperCase() == 'VND' ? 'vi_VN' : 'en_US';
  final symbol = currencyCode.toUpperCase() == 'VND' ? 'VND ' : '\$';
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 2,
  );
  return formatter.format(price);
}

/// Formats a [slot] as `"HH:mm - HH:mm"` in local time.
///
/// Uses `DateFormat('HH:mm')` from `package:intl` for
/// consistent 24-hour short-time output.
///
/// _(Req 2.4)_
String formatSlot(BookingSlot slot) {
  final fmt = DateFormat('HH:mm');
  final startStr = fmt.format(slot.start.toLocal());
  final endStr = fmt.format(slot.end.toLocal());
  return '$startStr - $endStr';
}

/// Formats a [slot] as a full local date with the short time span.
String formatFullSlot(BookingSlot slot) {
  final start = slot.start.toLocal();
  final date = DateFormat.yMMMMEEEEd().format(start);
  return '$date • ${formatSlot(slot)}';
}

/// Derives up to 2 uppercase initials from [fullName].
///
/// Splits on whitespace, takes the first character of the
/// first and last non-empty segments, uppercases them, and
/// returns at most 2 characters. Returns an empty string
/// when no derivable initials exist (empty input, only
/// whitespace, or no alphabetic characters).
///
/// _(Req 2.6, 2.7)_
String deriveInitials(String fullName) {
  final parts = fullName
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    final first = parts.first;
    if (first.isEmpty) return '';
    return first[0].toUpperCase();
  }
  final firstChar = parts.first[0].toUpperCase();
  final lastChar = parts.last[0].toUpperCase();
  return '$firstChar$lastChar';
}
