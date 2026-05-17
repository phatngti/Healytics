import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_employee.request.freezed.dart';
part 'update_employee.request.g.dart';

/// Request model for updating an existing employee.
///
/// Contains only fields that changed in the edit form.
/// The [id] field identifies the employee to update; [fields]
/// is sent as the sparse PATCH payload.
@Freezed(toJson: true)
abstract class UpdateEmployeeRequest with _$UpdateEmployeeRequest {
  /// Creates a new [UpdateEmployeeRequest].
  const factory UpdateEmployeeRequest({
    /// The unique identifier of the employee to update.
    required EmployeeId id,

    /// Sparse API field map. Keys are backend DTO
    /// field names such as `firstName`,
    /// `doctorProfile`, or `therapistProfile`.
    @Default(<String, dynamic>{}) Map<String, dynamic> fields,
  }) = _UpdateEmployeeRequest;

  /// Creates an [UpdateEmployeeRequest] from JSON data.
  factory UpdateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmployeeRequestFromJson(json);
}
