import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_employee.request.freezed.dart';
part 'update_employee.request.g.dart';

@Freezed(toJson: true)
abstract class UpdateEmployeeRequest with _$UpdateEmployeeRequest {
  const factory UpdateEmployeeRequest({
    required EmployeeId id,
    required String name,
    required String email,
    String? password,
  }) = _UpdateEmployeeRequest;

  factory UpdateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmployeeRequestFromJson(json);
}
