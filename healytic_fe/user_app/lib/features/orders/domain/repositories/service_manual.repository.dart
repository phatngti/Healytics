// Abstract repository for the service manual feature.
//
// Pure Dart — no Flutter or framework imports.

import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';

/// Contract for fetching a service manual by
/// appointment identifier.
abstract class ServiceManualRepository {
  /// Returns the service manual for the given
  /// [appointmentId], or `null` if not found.
  Future<ServiceManualEntity?> getManualByAppointmentId(String appointmentId);
}
