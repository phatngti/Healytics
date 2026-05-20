import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:user_app/features/booking/domain/entities/booking.entity.dart';
import 'package:user_app/features/booking/domain/entities/time_slot.entity.dart';

part 'booking.provider.g.dart';

/// Fetches specialists for the given [categoryId].
///
/// Returns an empty list if no category is selected.
@riverpod
Future<List<BookingSpecialist>> specialistsByCategory(
  Ref ref,
  String categoryId,
) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getSpecialistsByCategory(categoryId);
}

/// Fetches specialists assigned to the given
/// [serviceId].
///
/// Used when navigating from Service Details.
@riverpod
Future<List<BookingSpecialist>> specialistsByService(
  Ref ref,
  String serviceId,
) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getSpecialistsByService(
    serviceId,
  );
}

/// Fetches services for the given [specialistId].
///
/// Returns an empty list if no specialist is selected.
@riverpod
Future<List<BookingService>> servicesBySpecialist(
  Ref ref,
  String specialistId,
) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getServicesBySpecialist(specialistId);
}

/// Fetches services for the given [categoryId].
///
/// Returns an empty list if no category is selected.
@riverpod
Future<List<BookingService>> servicesByCategory(
  Ref ref,
  String categoryId,
) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getServicesByCategory(categoryId);
}

/// Searches services and specialists matching
/// [query] via the backend (Elasticsearch).
@riverpod
Future<BookingSearchResult> searchBooking(
  Ref ref,
  String query,
) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.searchBooking(query);
}

/// Fetches time-slot availability for [employeeId]
/// starting from [date] (YYYY-MM-DD).
///
/// Defaults to 7 days to match the [DatePickerRow]
/// visible range.
@riverpod
Future<EmployeeTimeSlotsEntity> employeeTimeSlots(
  Ref ref,
  String employeeId, {
  String? date,
}) async {
  final datasource = ref.read(
    bookingRemoteDatasourceProvider,
  );
  return datasource.getTimeSlots(
    employeeId: employeeId,
    date: date,
    days: 7,
  );
}
