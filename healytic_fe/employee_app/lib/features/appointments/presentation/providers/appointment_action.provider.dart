import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/employee_appointment_impl.repository.dart';
import 'appointment_list.provider.dart';

part 'appointment_action.provider.g.dart';

final _log = Logger('AppointmentAction');

@riverpod
class AppointmentAction extends _$AppointmentAction {
  @override
  FutureOr<void> build() {}

  Future<bool> startService(String id) async {
    state = const AsyncLoading();
    try {
      final success = await ref
          .read(employeeAppointmentRepositoryProvider)
          .startService(id);
      state = const AsyncData(null);
      if (success) _invalidateLists();
      _log.info('Started service for $id');
      return success;
    } catch (e, s) {
      state = AsyncError(e, s);
      _log.severe('Failed to start service', e, s);
      return false;
    }
  }

  Future<bool> completeService(String id) async {
    state = const AsyncLoading();
    try {
      final success = await ref
          .read(employeeAppointmentRepositoryProvider)
          .completeService(id);
      state = const AsyncData(null);
      if (success) _invalidateLists();
      _log.info('Completed service for $id');
      return success;
    } catch (e, s) {
      state = AsyncError(e, s);
      _log.severe('Failed to complete service', e, s);
      return false;
    }
  }

  Future<bool> cancelAppointment(
    String id, {
    String? reason,
  }) async {
    state = const AsyncLoading();
    try {
      final success = await ref
          .read(employeeAppointmentRepositoryProvider)
          .cancelAppointment(id, reason: reason);
      state = const AsyncData(null);
      if (success) _invalidateLists();
      _log.info('Canceled appointment $id');
      return success;
    } catch (e, s) {
      state = AsyncError(e, s);
      _log.severe('Failed to cancel appointment', e, s);
      return false;
    }
  }

  void _invalidateLists() {
    ref.invalidate(appointmentListProvider);
  }
}
