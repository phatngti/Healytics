import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_distribution.entity.freezed.dart';

/// Role distribution data for employee pie/donut chart.
///
/// Each instance represents one role category and its
/// employee count for the donut chart.
@freezed
abstract class EmployeeDistribution with _$EmployeeDistribution {
  const factory EmployeeDistribution({
    required String role,
    required int count,
    required String status,
  }) = _EmployeeDistribution;
}
