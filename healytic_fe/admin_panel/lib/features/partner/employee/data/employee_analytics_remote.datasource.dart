import 'dart:math' as math;

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/widgets/analytics/analytics_status_badge.widget.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/data/employee_mock_data.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_analytics.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_analytics_remote.datasource.g.dart';

abstract class EmployeeAnalyticsRemoteDataSource {
  Future<EmployeeOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  });

  Future<EmployeeDetailAnalytics> getDetailAnalytics({
    required EmployeeId employeeId,
    required DashboardTimePeriod period,
  });
}

class EmployeeAnalyticsRemoteDataSourceImpl
    implements EmployeeAnalyticsRemoteDataSource {
  EmployeeAnalyticsRemoteDataSourceImpl({
    required EmployeeRepository repository,
  }) : _repository = repository;

  final EmployeeRepository _repository;

  @override
  Future<EmployeeOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    final employees = await _loadEmployees();
    return _buildEmployeeOverviewAnalytics(employees, period);
  }

  @override
  Future<EmployeeDetailAnalytics> getDetailAnalytics({
    required EmployeeId employeeId,
    required DashboardTimePeriod period,
  }) async {
    final employee = await _repository.getEmployeeById(employeeId);
    return _buildEmployeeDetailAnalytics(employee: employee, period: period);
  }

  Future<List<EmployeeEntity>> _loadEmployees() async {
    final totalRows = await _repository.getTotalRows();
    final count = totalRows == 0 ? 1 : totalRows;
    return _repository.getEmployees(0, count, null, null);
  }
}

class EmployeeAnalyticsRemoteDataSourceMock
    implements EmployeeAnalyticsRemoteDataSource {
  @override
  Future<EmployeeOverviewAnalytics> getOverviewAnalytics({
    required DashboardTimePeriod period,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final employees = <EmployeeEntity>[
      createMockDoctor(const EmployeeId('mock-doc-0')),
      createMockDoctor(const EmployeeId('mock-doc-1')),
      createMockSpaTherapist(const EmployeeId('mock-spa-0')),
      createMockSpaTherapist(const EmployeeId('mock-spa-1')),
      createMockMassageTherapist(const EmployeeId('mock-massage-0')),
    ];
    return _buildEmployeeOverviewAnalytics(employees, period);
  }

  @override
  Future<EmployeeDetailAnalytics> getDetailAnalytics({
    required EmployeeId employeeId,
    required DashboardTimePeriod period,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final idValue = employeeId.value.toLowerCase();
    final employee = idValue.contains('doc')
        ? createMockDoctor(employeeId)
        : idValue.contains('spa')
        ? createMockSpaTherapist(employeeId)
        : createMockMassageTherapist(employeeId);

    return _buildEmployeeDetailAnalytics(employee: employee, period: period);
  }
}

@riverpod
EmployeeAnalyticsRemoteDataSource employeeAnalyticsRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return EmployeeAnalyticsRemoteDataSourceMock();
  }

  final repository = ref.read(employeeRepositoryProvider);
  return EmployeeAnalyticsRemoteDataSourceImpl(repository: repository);
}

EmployeeOverviewAnalytics _buildEmployeeOverviewAnalytics(
  List<EmployeeEntity> employees,
  DashboardTimePeriod period,
) {
  final scale = _employeePeriodScale(period);
  final activeEmployees = employees
      .where((employee) => employee.status.toUpperCase() == 'ACTIVE')
      .length;
  final onLeaveEmployees = employees
      .where((employee) => employee.status.toUpperCase() == 'ON_LEAVE')
      .length;
  final inactiveEmployees =
      employees.length - activeEmployees - onLeaveEmployees;
  final reviewCount = employees.fold<int>(
    0,
    (sum, employee) => sum + employee.reviewCount,
  );
  final averageRating = employees.isEmpty
      ? 0.0
      : employees.fold<double>(0, (sum, employee) => sum + employee.rating) /
            employees.length;

  return EmployeeOverviewAnalytics(
    totalEmployees: employees.length,
    activeEmployees: activeEmployees,
    onLeaveEmployees: onLeaveEmployees,
    inactiveEmployees: math.max(0, inactiveEmployees),
    utilizationRate: _averageUtilization(employees, scale),
    utilizationDelta: 3.8 + scale,
    averageRating: averageRating,
    ratingDelta: 1.6 + scale * 0.4,
    reviewCount: reviewCount,
    trendPoints: _buildEmployeeTrendPoints(
      scale: scale,
      seed: employees.length,
      sessionsBase: employees.length * 7.5,
      valueBase: employees.length * 1450000,
    ),
    roleDistribution: _buildRoleDistribution(employees),
    topPerformers:
        employees
            .map((employee) => _buildPerformanceSummary(employee, scale))
            .toList()
          ..sort((left, right) => right.rating.compareTo(left.rating)),
    complianceItems: _buildOverviewCompliance(employees),
  );
}

EmployeeDetailAnalytics _buildEmployeeDetailAnalytics({
  required EmployeeEntity employee,
  required DashboardTimePeriod period,
}) {
  final scale = _employeePeriodScale(period);
  final completedSessions = math.max(
    8,
    ((employee.reviewCount / 2) + _availableWeeklyHours(employee) * scale)
        .round(),
  );
  final contributionValue = _contributionValue(employee, completedSessions);

  return EmployeeDetailAnalytics(
    employeeId: employee.id,
    completedSessions: completedSessions,
    sessionsDelta: 4.2 + scale,
    contributionValue: contributionValue,
    contributionDelta: 5.1 + scale,
    utilizationRate: _employeeUtilization(employee, scale),
    utilizationDelta: 2.4 + scale * 0.5,
    averageRating: employee.rating,
    reviewCount: employee.reviewCount,
    trendPoints: _buildEmployeeTrendPoints(
      scale: scale,
      seed: employee.fullName.length,
      sessionsBase: completedSessions / 6,
      valueBase: contributionValue / 6,
    ),
    mixMetrics: _buildEmployeeMix(employee),
    scheduleLoad: _buildScheduleLoad(employee, scale),
    qualityMetrics: _buildQualityMetrics(employee),
    complianceItems: _buildDetailCompliance(employee),
  );
}

List<EmployeeTrendPoint> _buildEmployeeTrendPoints({
  required double scale,
  required int seed,
  required double sessionsBase,
  required double valueBase,
}) {
  const factors = [0.82, 0.95, 1.06, 0.98, 1.14, 1.19];
  const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  return List<EmployeeTrendPoint>.generate(labels.length, (index) {
    final modifier = factors[(index + seed) % factors.length];
    return EmployeeTrendPoint(
      label: labels[index],
      sessions: math.max(4, sessionsBase * modifier * scale),
      contributionValue: math.max(500000, valueBase * modifier * scale),
    );
  });
}

List<EmployeeRoleDistribution> _buildRoleDistribution(
  List<EmployeeEntity> employees,
) {
  final counts = <String, int>{};
  for (final employee in employees) {
    final role = _roleLabel(employee);
    counts.update(role, (value) => value + 1, ifAbsent: () => 1);
  }

  return counts.entries
      .map(
        (entry) =>
            EmployeeRoleDistribution(role: entry.key, count: entry.value),
      )
      .toList()
    ..sort((left, right) => right.count.compareTo(left.count));
}

List<EmployeeComplianceItem> _buildOverviewCompliance(
  List<EmployeeEntity> employees,
) {
  final missingDocs = employees
      .where((employee) => employee.verificationDocuments.isEmpty)
      .length;
  final missingEmergency = employees
      .where((employee) => employee.emergencyContactPhone == null)
      .length;

  return [
    EmployeeComplianceItem(
      title: 'Verification coverage',
      detail: missingDocs == 0
          ? 'All visible profiles have supporting documents.'
          : '$missingDocs profiles still need verification uploads.',
      tone: missingDocs == 0
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.warning,
    ),
    EmployeeComplianceItem(
      title: 'Emergency readiness',
      detail: missingEmergency == 0
          ? 'Emergency contacts are complete across the roster.'
          : '$missingEmergency profiles are missing emergency contacts.',
      tone: missingEmergency == 0
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.critical,
    ),
  ];
}

EmployeePerformanceSummary _buildPerformanceSummary(
  EmployeeEntity employee,
  double scale,
) {
  return EmployeePerformanceSummary(
    employeeName: employee.displayName,
    roleLabel: _roleLabel(employee),
    rating: employee.rating,
    utilizationRate: _employeeUtilization(employee, scale),
    contributionValue: _contributionValue(
      employee,
      math.max(8, (employee.reviewCount * scale).round()),
    ),
  );
}

List<EmployeeMixMetric> _buildEmployeeMix(EmployeeEntity employee) {
  switch (employee) {
    case DoctorEntity doctor:
      final items = doctor.specializations.isEmpty
          ? ['Consultation', 'Procedure']
          : doctor.specializations;
      return _buildMixFromLabels(items);
    case SpaTherapistEntity spa:
      final items = spa.skills.isEmpty ? ['Facial', 'Device Care'] : spa.skills;
      return _buildMixFromLabels(items);
    case MassageTherapistEntity massage:
      final items = massage.skills.isEmpty
          ? ['Thai Massage', 'Deep Tissue']
          : massage.skills;
      return _buildMixFromLabels(items);
    case BasicEmployeeEntity _:
      return _buildMixFromLabels(['Support tasks', 'Client care']);
  }
}

List<EmployeeMixMetric> _buildMixFromLabels(List<String> labels) {
  final total = labels.length;
  return List<EmployeeMixMetric>.generate(labels.length, (index) {
    final value = (total - index) * 12;
    return EmployeeMixMetric(
      label: labels[index],
      value: value,
      share: value / (total * 12 * (total + 1) / 2),
    );
  });
}

List<EmployeeScheduleLoad> _buildScheduleLoad(
  EmployeeEntity employee,
  double scale,
) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final available = _availableWeeklyHours(employee) / labels.length;

  return List<EmployeeScheduleLoad>.generate(labels.length, (index) {
    final modifier = 0.58 + (index * 0.08);
    return EmployeeScheduleLoad(
      label: labels[index],
      availableHours: available,
      bookedHours: math.min(available, available * modifier * scale),
    );
  });
}

List<EmployeeQualityMetric> _buildQualityMetrics(EmployeeEntity employee) {
  final docsReady = employee.verificationDocuments.isNotEmpty;
  final emergencyReady = employee.emergencyContactPhone != null;

  return [
    EmployeeQualityMetric(
      label: 'Client sentiment',
      value: employee.rating.toStringAsFixed(1),
      detail: '${employee.reviewCount} reviews across recent services',
      tone: employee.rating >= 4.5
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.warning,
    ),
    EmployeeQualityMetric(
      label: 'Documentation',
      value: docsReady ? 'Ready' : 'Missing',
      detail: docsReady
          ? 'Verification documents are attached.'
          : 'Upload credentials and identity records.',
      tone: docsReady
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.critical,
    ),
    EmployeeQualityMetric(
      label: 'Emergency readiness',
      value: emergencyReady ? 'Ready' : 'Needs action',
      detail: emergencyReady
          ? 'Emergency contact details are available.'
          : 'Add emergency contacts for operational safety.',
      tone: emergencyReady
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.warning,
    ),
  ];
}

List<EmployeeComplianceItem> _buildDetailCompliance(EmployeeEntity employee) {
  return [
    EmployeeComplianceItem(
      title: 'Profile status',
      detail:
          '${_roleLabel(employee)} profile is ${employee.status.toLowerCase()}.',
      tone: employee.status.toUpperCase() == 'ACTIVE'
          ? AnalyticsStatusTone.positive
          : AnalyticsStatusTone.warning,
    ),
    EmployeeComplianceItem(
      title: 'Verification posture',
      detail: employee.verificationDocuments.isEmpty
          ? 'No supporting verification documents attached.'
          : '${employee.verificationDocuments.length} document(s) available.',
      tone: employee.verificationDocuments.isEmpty
          ? AnalyticsStatusTone.critical
          : AnalyticsStatusTone.positive,
    ),
  ];
}

double _employeePeriodScale(DashboardTimePeriod period) {
  switch (period) {
    case DashboardTimePeriod.today:
      return 0.35;
    case DashboardTimePeriod.thisWeek:
      return 0.76;
    case DashboardTimePeriod.thisMonth:
      return 1.0;
    case DashboardTimePeriod.thisQuarter:
      return 1.42;
    case DashboardTimePeriod.thisYear:
      return 2.08;
  }
}

double _averageUtilization(List<EmployeeEntity> employees, double scale) {
  if (employees.isEmpty) {
    return 0;
  }

  final total = employees.fold<double>(
    0,
    (sum, employee) => sum + _employeeUtilization(employee, scale),
  );
  return total / employees.length;
}

double _employeeUtilization(EmployeeEntity employee, double scale) {
  final availableHours = _availableWeeklyHours(employee);
  if (availableHours == 0) {
    return 0;
  }

  final bookedHours = math.min(
    availableHours,
    availableHours * (0.58 + (employee.reviewCount % 18) / 100) * scale,
  );
  return (bookedHours / availableHours) * 100;
}

double _availableWeeklyHours(EmployeeEntity employee) {
  final workingSlots = employee.workSchedule.where((slot) => slot.isWorking);
  return workingSlots.fold<double>(0, (sum, slot) {
    final start = _hourValue(slot.start);
    final end = _hourValue(slot.end);
    return sum + math.max(0, end - start);
  });
}

double _hourValue(String value) {
  if (value.isEmpty) {
    return 0;
  }

  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  return hour + (minute / 60);
}

double _contributionValue(EmployeeEntity employee, int completedSessions) {
  final sessionValue = switch (employee) {
    DoctorEntity doctor => doctor.consultationFee ?? 500000.0,
    SpaTherapistEntity spa => 350000.0 + (spa.commissionRate * 10000),
    MassageTherapistEntity massage =>
      320000.0 + (massage.commissionRate * 9000),
    BasicEmployeeEntity _ => 180000.0,
  };

  return completedSessions * sessionValue;
}

String _roleLabel(EmployeeEntity employee) {
  return switch (employee) {
    DoctorEntity _ => 'Doctor',
    SpaTherapistEntity _ => 'Spa therapist',
    MassageTherapistEntity _ => 'Massage therapist',
    BasicEmployeeEntity _ => 'Team member',
  };
}
