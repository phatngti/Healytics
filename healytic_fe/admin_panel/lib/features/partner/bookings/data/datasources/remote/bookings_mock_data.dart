import 'package:admin_panel/features/partner/bookings/domain/entities/booking.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_slot.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/booking_status.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/customer.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/service.entity.dart';
import 'package:admin_panel/features/partner/bookings/domain/entities/specialist.entity.dart';

/// Mock booking fixture data for development and testing.
///
/// Contains 16 records satisfying Req 8.3 variety rules:
/// - Every [BookingStatus] appears at least once
/// - More than 3 records have customer, specialist, or service names > 30 chars
/// - More than 3 records have names ≤ 10 chars
///
/// The dates are anchored around the current local day so the date-range
/// picker remains useful in development even as the project moves forward.
final List<Booking> mockBookings = [
  _booking(
    id: 'booking-1001',
    customer: _customer(
      id: 'customer-1001',
      fullName: 'An Tran',
      age: 29,
      avatarUrl: 'https://i.pravatar.cc/128?img=11',
    ),
    specialist: _specialist(
      id: 'specialist-2001',
      fullName: 'Dr. Minh Pham',
      roleLabel: 'Cardiology specialist',
      avatarUrl: 'https://i.pravatar.cc/128?img=12',
    ),
    service: _service(
      id: 'service-3001',
      name: 'Heart checkup',
      categoryName: 'Cardiology',
      price: 450000,
    ),
    status: BookingStatus.waiting,
    dayOffset: -2,
    startHour: 8,
    startMinute: 0,
    durationMinutes: 45,
  ),
  _booking(
    id: 'booking-1002',
    customer: _customer(id: 'customer-1002', fullName: 'Bao Le', age: 34),
    specialist: _specialist(
      id: 'specialist-2002',
      fullName: 'Dr. Lan Nguyen Thi Phuong Anh',
      roleLabel: 'Senior diagnostic imaging consultant',
    ),
    service: _service(
      id: 'service-3002',
      name: 'Abdominal ultrasound screening',
      categoryName: 'Diagnostic imaging',
      price: 720000,
    ),
    status: BookingStatus.onProcess,
    dayOffset: -1,
    startHour: 9,
    startMinute: 30,
    durationMinutes: 30,
  ),
  _booking(
    id: 'booking-1003',
    customer: _customer(
      id: 'customer-1003',
      fullName: 'Christine Alexandra Montgomery',
      age: 42,
      avatarUrl: 'https://i.pravatar.cc/128?img=24',
    ),
    specialist: _specialist(
      id: 'specialist-2003',
      fullName: 'Dr. Huy Tran',
      roleLabel: 'Dermatology',
    ),
    service: _service(
      id: 'service-3003',
      name: 'Dermatology consultation',
      categoryName: 'Dermatology',
      price: 35,
      currencyCode: 'USD',
    ),
    status: BookingStatus.finished,
    dayOffset: -5,
    startHour: 14,
    startMinute: 15,
    durationMinutes: 45,
  ),
  _booking(
    id: 'booking-1004',
    customer: _customer(id: 'customer-1004', fullName: 'Mai', age: 23),
    specialist: _specialist(
      id: 'specialist-2004',
      fullName: 'Dr. Tue',
      roleLabel: 'General practitioner',
    ),
    service: _service(
      id: 'service-3004',
      name: 'Flu shot',
      categoryName: 'Preventive care',
      price: 180000,
    ),
    status: BookingStatus.canceled,
    dayOffset: 0,
    startHour: 10,
    startMinute: 0,
    durationMinutes: 20,
  ),
  _booking(
    id: 'booking-1005',
    customer: _customer(
      id: 'customer-1005',
      fullName: 'Nguyen Hoang Bao Tran Minh Chau',
      age: 31,
    ),
    specialist: _specialist(
      id: 'specialist-2005',
      fullName: 'Dr. Quang Vo',
      roleLabel: 'Musculoskeletal rehabilitation physician',
      avatarUrl: 'https://i.pravatar.cc/128?img=33',
    ),
    service: _service(
      id: 'service-3005',
      name: 'Sports injury rehabilitation planning',
      categoryName: 'Rehabilitation',
      price: 980000,
    ),
    status: BookingStatus.waiting,
    dayOffset: 1,
    startHour: 7,
    startMinute: 45,
    durationMinutes: 60,
  ),
  _booking(
    id: 'booking-1006',
    customer: _customer(id: 'customer-1006', fullName: 'Duc', age: 51),
    specialist: _specialist(
      id: 'specialist-2006',
      fullName: 'Dr. Khoa',
      roleLabel: 'Endocrinology',
    ),
    service: _service(
      id: 'service-3006',
      name: 'Diabetes review',
      categoryName: 'Endocrinology',
      price: 520000,
    ),
    status: BookingStatus.onProcess,
    dayOffset: 0,
    startHour: 11,
    startMinute: 30,
    durationMinutes: 30,
  ),
  _booking(
    id: 'booking-1007',
    customer: _customer(
      id: 'customer-1007',
      fullName: 'Pham Thi Kim Ngan',
      age: 37,
      avatarUrl: 'https://i.pravatar.cc/128?img=45',
    ),
    specialist: _specialist(
      id: 'specialist-2007',
      fullName: 'Professor Elizabeth Marian Hartwell',
      roleLabel: 'Consultant neurologist and headache specialist',
    ),
    service: _service(
      id: 'service-3007',
      name: 'Neurology follow-up',
      categoryName: 'Neurology',
      price: 1250000,
    ),
    status: BookingStatus.finished,
    dayOffset: -3,
    startHour: 16,
    startMinute: 0,
    durationMinutes: 40,
  ),
  _booking(
    id: 'booking-1008',
    customer: _customer(id: 'customer-1008', fullName: 'Eve Stone', age: 27),
    specialist: _specialist(
      id: 'specialist-2008',
      fullName: 'Dr. Sara',
      roleLabel: 'Nutrition',
    ),
    service: _service(
      id: 'service-3008',
      name: 'Diet plan',
      categoryName: 'Nutrition',
      price: 28,
      currencyCode: 'USD',
    ),
    status: BookingStatus.canceled,
    dayOffset: 2,
    startHour: 13,
    startMinute: 0,
    durationMinutes: 30,
  ),
  _booking(
    id: 'booking-1009',
    customer: _customer(
      id: 'customer-1009',
      fullName: 'Tran Van Binh',
      age: 45,
    ),
    specialist: _specialist(
      id: 'specialist-2009',
      fullName: 'Dr. Nhat Le',
      roleLabel: 'Orthopedic surgeon',
    ),
    service: _service(
      id: 'service-3009',
      name: 'Knee pain evaluation',
      categoryName: 'Orthopedics',
      price: 650000,
    ),
    status: BookingStatus.waiting,
    dayOffset: 4,
    startHour: 8,
    startMinute: 30,
    durationMinutes: 45,
  ),
  _booking(
    id: 'booking-1010',
    customer: _customer(
      id: 'customer-1010',
      fullName: 'Olivia Katherine Beaumont Sinclair',
      age: 39,
      avatarUrl: 'https://i.pravatar.cc/128?img=50',
    ),
    specialist: _specialist(
      id: 'specialist-2010',
      fullName: 'Dr. Nam',
      roleLabel: 'Internal medicine',
    ),
    service: _service(
      id: 'service-3010',
      name: 'Comprehensive executive health screening package',
      categoryName: 'Internal medicine',
      price: 2500000,
    ),
    status: BookingStatus.finished,
    dayOffset: -8,
    startHour: 15,
    startMinute: 30,
    durationMinutes: 90,
  ),
  _booking(
    id: 'booking-1011',
    customer: _customer(id: 'customer-1011', fullName: 'Tom', age: 19),
    specialist: _specialist(
      id: 'specialist-2011',
      fullName: 'Dr. Linh',
      roleLabel: 'ENT',
    ),
    service: _service(
      id: 'service-3011',
      name: 'ENT exam',
      categoryName: 'ENT',
      price: 300000,
    ),
    status: BookingStatus.waiting,
    dayOffset: 6,
    startHour: 17,
    startMinute: 0,
    durationMinutes: 25,
  ),
  _booking(
    id: 'booking-1012',
    customer: _customer(id: 'customer-1012', fullName: 'Le Minh Quan', age: 62),
    specialist: _specialist(
      id: 'specialist-2012',
      fullName: 'Dr. Avery Jonathan Whitmore',
      roleLabel: 'Geriatric care coordinator',
      avatarUrl: 'https://i.pravatar.cc/128?img=59',
    ),
    service: _service(
      id: 'service-3012',
      name: 'Medication reconciliation visit',
      categoryName: 'Geriatric care',
      price: 580000,
    ),
    status: BookingStatus.onProcess,
    dayOffset: 3,
    startHour: 10,
    startMinute: 45,
    durationMinutes: 35,
  ),
  _booking(
    id: 'booking-1013',
    customer: _customer(id: 'customer-1013', fullName: 'Nora', age: 33),
    specialist: _specialist(
      id: 'specialist-2013',
      fullName: 'Dr. Iris',
      roleLabel: 'Ophthalmology',
    ),
    service: _service(
      id: 'service-3013',
      name: 'Eye test',
      categoryName: 'Ophthalmology',
      price: 220000,
    ),
    status: BookingStatus.finished,
    dayOffset: -1,
    startHour: 18,
    startMinute: 15,
    durationMinutes: 30,
  ),
  _booking(
    id: 'booking-1014',
    customer: _customer(
      id: 'customer-1014',
      fullName: 'Vo Thanh Tam',
      age: 48,
      avatarUrl: 'https://i.pravatar.cc/128?img=61',
    ),
    specialist: _specialist(
      id: 'specialist-2014',
      fullName: 'Dr. Peter Nguyen Long Administrative Name',
      roleLabel: 'Respiratory therapy and sleep medicine consultant',
    ),
    service: _service(
      id: 'service-3014',
      name: 'Sleep apnea consultation',
      categoryName: 'Respiratory care',
      price: 890000,
    ),
    status: BookingStatus.canceled,
    dayOffset: -4,
    startHour: 12,
    startMinute: 15,
    durationMinutes: 45,
  ),
  _booking(
    id: 'booking-1015',
    customer: _customer(id: 'customer-1015', fullName: 'Grace Lee', age: 26),
    specialist: _specialist(
      id: 'specialist-2015',
      fullName: 'Dr. Hana Mori',
      roleLabel: 'Mental health counselor',
    ),
    service: _service(
      id: 'service-3015',
      name: 'Stress counseling session',
      categoryName: 'Mental health',
      price: 42,
      currencyCode: 'USD',
    ),
    status: BookingStatus.waiting,
    dayOffset: 7,
    startHour: 9,
    startMinute: 15,
    durationMinutes: 50,
  ),
  _booking(
    id: 'booking-1016',
    customer: _customer(
      id: 'customer-1016',
      fullName: 'Hoang Anh Minh Long Name For Layout Check',
      age: 57,
    ),
    specialist: _specialist(
      id: 'specialist-2016',
      fullName: 'Dr. Son',
      roleLabel: 'Urology',
    ),
    service: _service(
      id: 'service-3016',
      name: 'Kidney function laboratory and review',
      categoryName: 'Urology',
      price: 760000,
    ),
    status: BookingStatus.onProcess,
    dayOffset: 5,
    startHour: 14,
    startMinute: 45,
    durationMinutes: 35,
  ),
];

final DateTime _mockToday = DateTime.now();

Booking _booking({
  required String id,
  required Customer customer,
  required Specialist specialist,
  required Service service,
  required BookingStatus status,
  required int dayOffset,
  required int startHour,
  required int startMinute,
  required int durationMinutes,
}) {
  final start = DateTime(
    _mockToday.year,
    _mockToday.month,
    _mockToday.day + dayOffset,
    startHour,
    startMinute,
  );

  return Booking(
    id: id,
    customer: customer,
    specialist: specialist,
    service: service,
    slot: BookingSlot(
      start: start,
      end: start.add(Duration(minutes: durationMinutes)),
    ),
    status: status,
  );
}

Customer _customer({
  required String id,
  required String fullName,
  required int age,
  String? avatarUrl,
}) {
  return Customer(id: id, fullName: fullName, age: age, avatarUrl: avatarUrl);
}

Specialist _specialist({
  required String id,
  required String fullName,
  required String roleLabel,
  String? avatarUrl,
}) {
  return Specialist(
    id: id,
    fullName: fullName,
    roleLabel: roleLabel,
    avatarUrl: avatarUrl,
  );
}

Service _service({
  required String id,
  required String name,
  String categoryName = 'General',
  required double price,
  String currencyCode = 'VND',
}) {
  return Service(
    id: id,
    name: name,
    categoryName: categoryName,
    price: price,
    currencyCode: currencyCode,
  );
}
