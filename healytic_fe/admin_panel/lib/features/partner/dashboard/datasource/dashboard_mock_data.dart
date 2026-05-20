import 'package:admin_panel/features/partner/dashboard/domain/dashboard_notification.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_stats.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/employee_distribution.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/inventory_alert.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/revenue_data_point.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/service_performance.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/staff_schedule.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/upcoming_appointment.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_review.entity.dart';

// ─── KPI Stats ──────────────────────────────────

const mockDashboardStats = DashboardStats(
  totalAppointments: 342,
  completedAppointments: 285,
  cancelledAppointments: 18,
  pendingAppointments: 39,
  totalRevenue: 48750000,
  revenueGrowthPercent: 12.5,
  totalServices: 24,
  activeServices: 18,
  totalEmployees: 15,
  activeEmployees: 12,
  averageRating: 4.7,
  totalReviews: 156,
);

// ─── Revenue Data — Monthly ─────────────────────

List<RevenueDataPoint> get mockMonthlyRevenueData {
  final now = DateTime.now();
  return List.generate(30, (i) {
    final date = now.subtract(Duration(days: 29 - i));
    // Simulate realistic daily revenue with variance
    final base = 1200000.0 + (i * 30000);
    final variance = (i % 7 == 0 || i % 7 == 6)
        ? -300000.0 // weekends dip
        : 200000.0 * (i % 3);
    return RevenueDataPoint(
      date: DateTime(date.year, date.month, date.day),
      revenue: base + variance,
    );
  });
}

List<RevenueDataPoint> get mockWeeklyRevenueData {
  final now = DateTime.now();
  return List.generate(7, (i) {
    final date = now.subtract(Duration(days: 6 - i));
    final base = 1500000.0;
    final variance = (i == 0 || i == 6) ? -400000.0 : 300000.0 * (i % 3);
    return RevenueDataPoint(
      date: DateTime(date.year, date.month, date.day),
      revenue: base + variance,
    );
  });
}

List<RevenueDataPoint> get mockTodayRevenueData {
  final now = DateTime.now();
  return List.generate(12, (i) {
    final hour = 8 + i; // 8 AM to 7 PM
    return RevenueDataPoint(
      date: DateTime(now.year, now.month, now.day, hour),
      revenue: 80000.0 + (i * 25000) + (i % 3 * 15000),
    );
  });
}

List<RevenueDataPoint> get mockQuarterlyRevenueData {
  final now = DateTime.now();
  return List.generate(12, (i) {
    final date = DateTime(now.year, now.month - 2 + (i ~/ 4), 1 + (i % 4) * 7);
    return RevenueDataPoint(date: date, revenue: 8000000.0 + (i * 500000));
  });
}

List<RevenueDataPoint> get mockYearlyRevenueData {
  final now = DateTime.now();
  return List.generate(12, (i) {
    final date = DateTime(now.year, i + 1, 15);
    return RevenueDataPoint(date: date, revenue: 35000000.0 + (i * 2000000));
  });
}

// ─── Upcoming Appointments ──────────────────────

List<UpcomingAppointment> get mockUpcomingAppointments {
  final now = DateTime.now();
  return [
    UpcomingAppointment(
      id: 'apt-001',
      patientName: 'Nguyễn Văn An',
      serviceName: 'Full Body Massage',
      employeeName: 'Dr. Trần Minh',
      scheduledAt: now.add(const Duration(hours: 1)),
      status: 'confirmed',
    ),
    UpcomingAppointment(
      id: 'apt-002',
      patientName: 'Lê Thị Bình',
      serviceName: 'Facial Treatment',
      employeeName: 'Phạm Hoa',
      scheduledAt: now.add(const Duration(hours: 2)),
      status: 'confirmed',
    ),
    UpcomingAppointment(
      id: 'apt-003',
      patientName: 'Trần Đức Cường',
      serviceName: 'Acupuncture Session',
      employeeName: 'Dr. Nguyễn Thu',
      scheduledAt: now.add(const Duration(hours: 3, minutes: 30)),
      status: 'pending',
    ),
    UpcomingAppointment(
      id: 'apt-004',
      patientName: 'Phạm Thị Dung',
      serviceName: 'Hot Stone Therapy',
      employeeName: 'Vũ Thanh',
      scheduledAt: now.add(const Duration(hours: 5)),
      status: 'confirmed',
    ),
    UpcomingAppointment(
      id: 'apt-005',
      patientName: 'Hoàng Minh Đức',
      serviceName: 'Dermatology Consult',
      employeeName: 'Dr. Lê Hùng',
      scheduledAt: now.add(const Duration(days: 1)),
      status: 'pending',
    ),
  ];
}

// ─── Service Performance ────────────────────────

const mockServicePerformance = [
  ServicePerformance(
    serviceName: 'Full Body Massage',
    bookingCount: 85,
    revenue: 12750000,
    averageRating: 4.8,
  ),
  ServicePerformance(
    serviceName: 'Facial Treatment',
    bookingCount: 62,
    revenue: 9300000,
    averageRating: 4.6,
  ),
  ServicePerformance(
    serviceName: 'Acupuncture',
    bookingCount: 48,
    revenue: 7200000,
    averageRating: 4.9,
  ),
  ServicePerformance(
    serviceName: 'Hot Stone Therapy',
    bookingCount: 41,
    revenue: 8200000,
    averageRating: 4.7,
  ),
  ServicePerformance(
    serviceName: 'Dermatology',
    bookingCount: 35,
    revenue: 5250000,
    averageRating: 4.5,
  ),
  ServicePerformance(
    serviceName: 'Aromatherapy',
    bookingCount: 28,
    revenue: 4200000,
    averageRating: 4.4,
  ),
];

// ─── Employee Distribution ──────────────────────

const mockEmployeeDistribution = [
  EmployeeDistribution(role: 'Doctor', count: 4, status: 'active'),
  EmployeeDistribution(role: 'Spa Therapist', count: 5, status: 'active'),
  EmployeeDistribution(role: 'Massage Therapist', count: 3, status: 'active'),
  EmployeeDistribution(role: 'Receptionist', count: 2, status: 'active'),
  EmployeeDistribution(role: 'On Leave', count: 1, status: 'on_leave'),
];

// ─── Recent Reviews ─────────────────────────────

final mockRecentReviews = [
  DashboardReview(
    reviewerName: 'Nguyễn Văn Hùng',
    rating: 5,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    text:
        'Dịch vụ tuyệt vời! Nhân viên rất '
        'chuyên nghiệp và thân thiện.',
    status: 'published',
  ),
  DashboardReview(
    reviewerName: 'Trần Thị Mai',
    rating: 4,
    date: DateTime.now().subtract(const Duration(hours: 8)),
    text:
        'Không gian sạch sẽ, thoáng mát. '
        'Massage rất thư giãn.',
    status: 'published',
  ),
  DashboardReview(
    reviewerName: 'Lê Hoàng Nam',
    rating: 5,
    date: DateTime.now().subtract(const Duration(days: 1)),
    text:
        'Bác sĩ tư vấn rất kỹ và tận tâm. '
        'Sẽ quay lại lần sau.',
    status: 'published',
  ),
  DashboardReview(
    reviewerName: 'Phạm Thanh Hà',
    rating: 3,
    date: DateTime.now().subtract(const Duration(days: 2)),
    text:
        'Dịch vụ tốt nhưng thời gian chờ '
        'hơi lâu.',
    status: 'published',
  ),
];

// ─── Staff Schedule ─────────────────────────────

List<StaffScheduleEntry> getMockStaffSchedule(DateTime date) {
  return [
    StaffScheduleEntry(
      employeeId: 'emp-001',
      employeeName: 'Dr. Trần Minh',
      role: 'Doctor',
      startTime: DateTime(date.year, date.month, date.day, 8),
      endTime: DateTime(date.year, date.month, date.day, 9),
      serviceName: 'General Consultation',
      patientName: 'Nguyễn Văn An',
    ),
    StaffScheduleEntry(
      employeeId: 'emp-001',
      employeeName: 'Dr. Trần Minh',
      role: 'Doctor',
      startTime: DateTime(date.year, date.month, date.day, 9, 30),
      endTime: DateTime(date.year, date.month, date.day, 10, 30),
      serviceName: 'Acupuncture',
      patientName: 'Trần Đức Cường',
    ),
    StaffScheduleEntry(
      employeeId: 'emp-002',
      employeeName: 'Phạm Hoa',
      role: 'Spa Therapist',
      startTime: DateTime(date.year, date.month, date.day, 8),
      endTime: DateTime(date.year, date.month, date.day, 9, 30),
      serviceName: 'Facial Treatment',
      patientName: 'Lê Thị Bình',
    ),
    StaffScheduleEntry(
      employeeId: 'emp-003',
      employeeName: 'Vũ Thanh',
      role: 'Massage Therapist',
      startTime: DateTime(date.year, date.month, date.day, 10),
      endTime: DateTime(date.year, date.month, date.day, 11, 30),
      serviceName: 'Hot Stone Therapy',
      patientName: 'Phạm Thị Dung',
    ),
    StaffScheduleEntry(
      employeeId: 'emp-004',
      employeeName: 'Dr. Nguyễn Thu',
      role: 'Doctor',
      startTime: DateTime(date.year, date.month, date.day, 13),
      endTime: DateTime(date.year, date.month, date.day, 14),
      serviceName: 'Dermatology Consult',
      patientName: 'Hoàng Minh Đức',
    ),
  ];
}

// ─── Notifications ──────────────────────────────

final mockNotifications = [
  DashboardNotification(
    id: 'notif-001',
    title: 'New Appointment',
    message:
        'Nguyễn Văn An booked a '
        'Full Body Massage for today.',
    type: 'appointment',
    createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
  ),
  DashboardNotification(
    id: 'notif-002',
    title: 'New Review',
    message:
        'Trần Thị Mai left a 4-star '
        'review for Facial Treatment.',
    type: 'review',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: true,
  ),
  DashboardNotification(
    id: 'notif-003',
    title: 'Staff Schedule Update',
    message:
        'Dr. Lê Hùng is on leave '
        'tomorrow. Reassign appointments.',
    type: 'alert',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  DashboardNotification(
    id: 'notif-004',
    title: 'Payment Received',
    message:
        'Payment of 1,500,000₫ received '
        'from Hoàng Minh Đức.',
    type: 'system',
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    isRead: true,
  ),
  DashboardNotification(
    id: 'notif-005',
    title: 'Low Stock Alert',
    message:
        'Essential oil supply is running '
        'low. Reorder recommended.',
    type: 'alert',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

// ─── Inventory Alerts ───────────────────────────

final mockInventoryAlerts = [
  InventoryAlert(
    id: 'inv-001',
    productName: 'Essential Oil — Lavender',
    alertType: 'low_stock',
    message:
        'Only 3 units remaining. '
        'Reorder threshold: 10.',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    severity: 'warning',
  ),
  InventoryAlert(
    id: 'inv-002',
    productName: 'Face Mask — Collagen',
    alertType: 'expiring',
    message:
        'Batch expires in 5 days. '
        '12 units affected.',
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    severity: 'critical',
  ),
  InventoryAlert(
    id: 'inv-003',
    productName: 'Disposable Acupuncture Needles',
    alertType: 'out_of_stock',
    message:
        'Out of stock since yesterday. '
        'Urgent resupply needed.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    severity: 'critical',
  ),
  InventoryAlert(
    id: 'inv-004',
    productName: 'Massage Cream — Deep Tissue',
    alertType: 'low_stock',
    message:
        '8 units remaining. '
        'Reorder threshold: 15.',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    severity: 'info',
  ),
];
