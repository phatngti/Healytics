/// Status of an employee appointment.
enum EmployeeAppointmentStatus {
  upcoming,
  inProgress,
  completed,
  canceled;

  String get displayLabel => switch (this) {
    upcoming => 'Upcoming',
    inProgress => 'In Progress',
    completed => 'Completed',
    canceled => 'Canceled',
  };
}

/// Domain entity for an employee's appointment.
class EmployeeAppointmentEntity {
  final String id;
  final String serviceName;
  final String customerName;
  final String customerId;
  final String? imageUrl;
  final EmployeeAppointmentStatus status;
  final String category;
  final String clinicName;
  final String address;
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final String duration;
  final double? price;
  final String? notes;

  const EmployeeAppointmentEntity({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.customerId,
    this.imageUrl,
    required this.status,
    required this.category,
    required this.clinicName,
    required this.address,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    this.price,
    this.notes,
  });

  EmployeeAppointmentEntity copyWith({
    EmployeeAppointmentStatus? status,
    String? notes,
  }) {
    return EmployeeAppointmentEntity(
      id: id,
      serviceName: serviceName,
      customerName: customerName,
      customerId: customerId,
      imageUrl: imageUrl,
      status: status ?? this.status,
      category: category,
      clinicName: clinicName,
      address: address,
      date: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
      duration: duration,
      price: price,
      notes: notes ?? this.notes,
    );
  }
}
