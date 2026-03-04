/// Parameters collected from the service details screen
/// that are needed to initialise the checkout flow.
///
/// Pure Dart — no Flutter or Riverpod imports.
class BookingParams {
  const BookingParams({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImageUrl,
    required this.price,
    required this.clinicName,
    required this.clinicAddress,
    required this.clinicImageUrl,
    required this.employeeId,
    required this.employeeName,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  /// Service (product) identifier.
  final String serviceId;

  /// Display name of the service.
  final String serviceName;

  /// Cover image URL shown in the checkout item.
  final String serviceImageUrl;

  /// Formatted price string, e.g. "\$120.00".
  final String price;

  /// Clinic / vendor name.
  final String clinicName;

  /// Clinic address.
  final String clinicAddress;

  /// Clinic cover image URL.
  final String clinicImageUrl;

  /// Selected specialist employee ID.
  final String employeeId;

  /// Selected specialist display name.
  final String employeeName;

  /// The date the user picked for the appointment.
  final DateTime selectedDate;

  /// The time-slot label, e.g. "09:00 AM".
  final String selectedTimeSlot;
}
