import 'dart:convert';
import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_openapi/api.dart';

import '../../../domain/entities/booking.entity.dart';
import '../../../domain/entities/'
    'eligibility_detail.entity.dart';
import '../../../domain/entities/time_slot.entity.dart';
import 'booking_mock_data.dart';

// ─── Abstract interface ───────────────────────────

/// Contract for fetching booking-flow data.
abstract class BookingRemoteDatasource {
  /// Returns specialists available for the given
  /// [categoryId].
  Future<List<BookingSpecialist>> getSpecialistsByCategory(String categoryId);

  /// Returns specialists assigned to the given
  /// [serviceId].
  Future<List<BookingSpecialist>> getSpecialistsByService(String serviceId);

  /// Returns services offered by the given
  /// [specialistId].
  Future<List<BookingService>> getServicesBySpecialist(String specialistId);

  /// Returns services available under the given
  /// [categoryId].
  Future<List<BookingService>> getServicesByCategory(String categoryId);

  /// Searches services and specialists matching
  /// [query] via full-text search.
  ///
  /// Backend uses Elasticsearch; mock performs
  /// client-side filtering.
  Future<BookingSearchResult> searchBooking(String query);

  /// Returns time-slot availability for the
  /// given [employeeId] starting from [date].
  ///
  /// [days] controls how many days to fetch
  /// (default 7, max 30).
  Future<EmployeeTimeSlotsEntity> getTimeSlots({
    required String employeeId,
    String? date,
    int? days,
  });

  /// Fetches detailed eligibility info for
  /// the given [eligibilityId] (surrogate PK
  /// from `product_employee_eligibility`).
  Future<EligibilityDetailEntity> getEligibilityDetail(String eligibilityId);
}

// ─── Real implementation ──────────────────────────

/// Production implementation calling the backend
/// via the generated OpenAPI client.
class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final ApiService _apiService;

  BookingRemoteDatasourceImpl(this._apiService);

  @override
  Future<List<BookingSpecialist>> getSpecialistsByCategory(
    String categoryId,
  ) async {
    try {
      // Use raw HTTP to avoid the generated DTO's
      // null-assert crash on optional fields like
      // `specialty`.
      final httpResponse = await _apiService.userCategoriesApi
          .userCategoriesControllerFindSpecialistsByCategoryWithHttpInfo(
            categoryId,
          );

      if (httpResponse.statusCode >= 400) {
        log(
          'Specialists API returned '
          '${httpResponse.statusCode}',
        );
        return [];
      }

      if (httpResponse.body.isEmpty) return [];

      final decoded = json.decode(httpResponse.body);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_parseSpecialistJson)
          .toList();
    } catch (e, st) {
      log('Error fetching specialists', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<BookingSpecialist>> getSpecialistsByService(
    String serviceId,
  ) async {
    try {
      final response = await _apiService.userHealthServicesApi
          .userHealthServiceControllerGetProductEmployees(serviceId);

      if (response == null) return [];

      return response
          .map(
            (dto) => BookingSpecialist(
              id: dto.id,
              eligibilityId: dto.eligibilityId,
              name: dto.name,
              specialty: dto.role,
              avatarUrl: dto.imageUrl?.toString(),
            ),
          )
          .toList();
    } catch (e, st) {
      log('Error fetching specialists by service', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<BookingService>> getServicesBySpecialist(
    String specialistId,
  ) async {
    try {
      final response = await _apiService.userEmployeesApi
          .userEmployeesControllerFindServices(specialistId);

      if (response == null) return [];

      return response.map(_mapServiceDto).toList();
    } catch (e, st) {
      log('Error fetching services by specialist', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<BookingService>> getServicesByCategory(String categoryId) async {
    try {
      final response = await _apiService.userCategoriesApi
          .userCategoriesControllerFindServicesByCategory(categoryId);

      if (response == null) return [];

      return response.map(_mapServiceDto).toList();
    } catch (e, st) {
      log('Error fetching services by category', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<BookingSearchResult> searchBooking(String query) async {
    final normalized = query.trim();
    if (normalized.length < 2) return const BookingSearchResult();

    try {
      final response = await _apiService.userBookingSearchApi
          .bookingSearchControllerSearch(normalized, limit: '5');

      if (response == null) return const BookingSearchResult();

      return BookingSearchResult(
        services: response.services.map(_mapServiceDto).toList(),
        specialists: response.specialists
            .map(
              (dto) => BookingSpecialist(
                id: dto.id,
                eligibilityId: dto.eligibilityId,
                name: dto.name,
                specialty: dto.specialty,
                avatarUrl: dto.avatarUrl?.toString(),
              ),
            )
            .toList(),
      );
    } catch (e, st) {
      log('Error searching booking data', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<EmployeeTimeSlotsEntity> getTimeSlots({
    required String employeeId,
    String? date,
    int? days,
  }) async {
    try {
      // Use raw HTTP to avoid generated DTO's
      // null-assert crashes on optional fields.
      final httpResponse = await _apiService.userEmployeesApi
          .userEmployeesControllerGetTimeSlotsWithHttpInfo(
            employeeId,
            date: date,
            days: days != null ? num.parse('$days') : null,
          );

      if (httpResponse.statusCode >= 400 || httpResponse.body.isEmpty) {
        return _emptyTimeSlots(employeeId, date);
      }

      final decoded = json.decode(httpResponse.body);
      if (decoded is! Map<String, dynamic>) {
        return _emptyTimeSlots(employeeId, date);
      }

      return _parseTimeSlotsJson(decoded, employeeId, date);
    } catch (e, st) {
      log('Error fetching time slots', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<EligibilityDetailEntity> getEligibilityDetail(
    String eligibilityId,
  ) async {
    try {
      final httpResponse = await _apiService.userHealthServicesApi
          .userHealthServiceControllerGetEligibilityDetailWithHttpInfo(
            eligibilityId,
          );

      if (httpResponse.statusCode >= 400 || httpResponse.body.isEmpty) {
        throw ApiException(
          httpResponse.statusCode,
          'Eligibility detail not found',
        );
      }

      final decoded = json.decode(httpResponse.body);
      if (decoded is! Map<String, dynamic>) {
        throw ApiException(500, 'Invalid eligibility response');
      }

      return _parseEligibilityJson(decoded);
    } catch (e, st) {
      log('Error fetching eligibility detail', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Parses a raw JSON map into [BookingSpecialist]
  /// with safe fallbacks for missing fields.
  ///
  /// Avoids the generated DTO's `fromJson` which
  /// uses `!` on optional fields like `specialty`.
  BookingSpecialist _parseSpecialistJson(Map<String, dynamic> j) {
    return BookingSpecialist(
      id: j['id']?.toString() ?? '',
      eligibilityId: j['eligibilityId']?.toString(),
      name: j['name']?.toString() ?? '',
      specialty: j['specialty']?.toString() ?? '',
      avatarUrl: j['avatarUrl']?.toString(),
    );
  }

  /// Maps [BookingServiceResponseDto] to the
  /// domain [BookingService] entity.
  ///
  /// v2 DTO provides dedicated fields for each
  /// property — no more subtitle parsing.
  BookingService _mapServiceDto(BookingServiceResponseDto dto) {
    return BookingService(
      id: dto.id,
      imageUrl: dto.imageUrl?.toString(),
      title: dto.title,
      duration: dto.duration,
      price: dto.price,
      clinicName: dto.clinicName?.toString(),
      clinicAddress: dto.clinicAddress?.toString(),
      distance: dto.distance?.toString(),
    );
  }

  /// Returns an empty [EmployeeTimeSlotsEntity]
  /// when the API returns no data.
  EmployeeTimeSlotsEntity _emptyTimeSlots(String employeeId, String? date) {
    return EmployeeTimeSlotsEntity(
      employeeId: employeeId,
      employeeName: '',
      slotDurationMinutes: 30,
      rangeStart: date ?? '',
      rangeEnd: '',
    );
  }

  /// Parses raw JSON into [EmployeeTimeSlotsEntity]
  /// with safe fallbacks for missing fields.
  EmployeeTimeSlotsEntity _parseTimeSlotsJson(
    Map<String, dynamic> j,
    String employeeId,
    String? date,
  ) {
    final scheduleList = j['schedule'];
    final schedule = <DayScheduleEntity>[];

    if (scheduleList is List) {
      for (final item in scheduleList) {
        if (item is Map<String, dynamic>) {
          schedule.add(_parseDayScheduleJson(item));
        }
      }
    }

    return EmployeeTimeSlotsEntity(
      employeeId: j['employeeId']?.toString() ?? employeeId,
      employeeName: j['employeeName']?.toString() ?? '',
      slotDurationMinutes: (j['slotDurationMinutes'] as num?)?.toInt() ?? 30,
      schedule: schedule,
      rangeStart: j['rangeStart']?.toString() ?? date ?? '',
      rangeEnd: j['rangeEnd']?.toString() ?? '',
    );
  }

  /// Parses a raw JSON day schedule into
  /// [DayScheduleEntity].
  DayScheduleEntity _parseDayScheduleJson(Map<String, dynamic> j) {
    final slotsList = j['slots'];
    final slots = <TimeSlotEntity>[];

    if (slotsList is List) {
      for (final item in slotsList) {
        if (item is Map<String, dynamic>) {
          slots.add(_parseTimeSlotJson(item));
        }
      }
    }

    return DayScheduleEntity(
      date: j['date']?.toString() ?? '',
      dayOfWeek: j['dayOfWeek']?.toString() ?? '',
      isWorkingDay: j['isWorkingDay'] as bool? ?? false,
      slots: slots,
    );
  }

  /// Parses a raw JSON time slot into
  /// [TimeSlotEntity].
  TimeSlotEntity _parseTimeSlotJson(Map<String, dynamic> j) {
    return TimeSlotEntity(
      label: j['label']?.toString() ?? '',
      time: j['time']?.toString() ?? '',
      isAvailable: !_isBusy(j['isBusy']),
    );
  }

  /// Interprets the `isBusy` field from the API
  /// which may be a boolean (`true`/`false`) or a
  static bool _isBusy(dynamic value) {
    if (value is bool) return value;
    if (value == null) return false;
    final str = value.toString().toLowerCase();
    return str == 'busy' || str == 'true';
  }

  /// Parses the eligibility detail JSON into
  /// the domain entity with safe fallbacks.
  EligibilityDetailEntity _parseEligibilityJson(Map<String, dynamic> j) {
    final specJ =
        j['specialist'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final svcJ = j['service'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final catJ = j['category'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final locJ = j['location'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final priceJ =
        j['priceBreakdown'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final schedJ = j['bookingSchedule'] as Map<String, dynamic>?;

    return EligibilityDetailEntity(
      isCompletedStep: j['isCompletedStep'] as bool? ?? false,
      schedule: schedJ != null
          ? EligibilitySchedule(
              date: schedJ['date']?.toString(),
              timeSlotLabel: schedJ['timeSlotLabel']?.toString(),
            )
          : null,
      specialist: EligibilitySpecialist(
        id: specJ['id']?.toString() ?? '',
        name: specJ['name']?.toString() ?? '',
        specialty: specJ['specialty']?.toString(),
        avatarUrl: specJ['avatarUrl']?.toString(),
      ),
      service: EligibilityService(
        id: svcJ['id']?.toString() ?? '',
        title: svcJ['title']?.toString() ?? '',
        subtitle: svcJ['subtitle']?.toString(),
        duration: svcJ['duration']?.toString() ?? '',
        imageUrl: svcJ['imageUrl']?.toString(),
      ),
      category: EligibilityCategory(
        id: catJ['id']?.toString() ?? '',
        name: catJ['name']?.toString() ?? '',
      ),
      location: EligibilityLocation(
        name: locJ['name']?.toString() ?? '',
        address: locJ['address']?.toString() ?? '',
        mapUrl: locJ['mapUrl']?.toString(),
      ),
      priceBreakdown: EligibilityPriceBreakdown(
        subTotal: (priceJ['subTotal'] as num?) ?? 0,
        discount: (priceJ['discount'] as num?) ?? 0,
        totalAmount: (priceJ['totalAmount'] as num?) ?? 0,
        currency: priceJ['currency']?.toString() ?? 'VND',
      ),
    );
  }
}

// ─── Mock implementation ──────────────────────────

/// Mock implementation returning fake data after a
/// simulated network delay.
class BookingRemoteDatasourceMock implements BookingRemoteDatasource {
  @override
  Future<List<BookingSpecialist>> getSpecialistsByCategory(
    String categoryId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockSpecialistsByCategory[categoryId] ?? [];
  }

  @override
  Future<List<BookingSpecialist>> getSpecialistsByService(
    String serviceId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockSpecialistsByService[serviceId] ?? [];
  }

  @override
  Future<List<BookingService>> getServicesBySpecialist(
    String specialistId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockServicesBySpecialist[specialistId] ?? [];
  }

  @override
  Future<List<BookingService>> getServicesByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockServicesByCategory[categoryId] ?? [];
  }

  @override
  Future<BookingSearchResult> searchBooking(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const BookingSearchResult();

    // Filter services.
    final seenSvc = <String>{};
    final services = <BookingService>[];
    for (final list in kMockServicesByCategory.values) {
      for (final svc in list) {
        if (!seenSvc.add(svc.id)) continue;
        final match =
            svc.title.toLowerCase().contains(q) ||
            (svc.clinicName ?? '').toLowerCase().contains(q);
        if (match) services.add(svc);
      }
    }

    // Filter specialists.
    final seenSpec = <String>{};
    final specialists = <BookingSpecialist>[];
    for (final list in kMockSpecialistsByCategory.values) {
      for (final spec in list) {
        if (!seenSpec.add(spec.id)) continue;
        final match =
            spec.name.toLowerCase().contains(q) ||
            spec.specialty.toLowerCase().contains(q);
        if (match) specialists.add(spec);
      }
    }

    return BookingSearchResult(services: services, specialists: specialists);
  }

  @override
  Future<EmployeeTimeSlotsEntity> getTimeSlots({
    required String employeeId,
    String? date,
    int? days,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockEmployeeTimeSlots;
  }

  @override
  Future<EligibilityDetailEntity> getEligibilityDetail(
    String eligibilityId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return kMockEligibilityDetail;
  }
}

// ─── Provider ─────────────────────────────────────

/// Uses [AppEnvironment.useMock] to switch between
/// real and mock implementations at runtime.
final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>((
  ref,
) {
  if (AppEnvironment.current.useMock) {
    return BookingRemoteDatasourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return BookingRemoteDatasourceImpl(apiService);
});
