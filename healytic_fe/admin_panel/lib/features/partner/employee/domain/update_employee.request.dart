import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_employee.request.freezed.dart';
part 'update_employee.request.g.dart';

/// Request model for updating an existing employee.
///
/// Contains all fields that can be updated for an employee.
/// The [id] field is required to identify which employee to update.
@Freezed(toJson: true)
abstract class UpdateEmployeeRequest with _$UpdateEmployeeRequest {
  /// Creates a new [UpdateEmployeeRequest].
  const factory UpdateEmployeeRequest({
    /// The unique identifier of the employee to update.
    required EmployeeId id,

    /// Updated full name.
    required String fullName,

    /// Updated display name.
    required String displayName,

    /// Updated avatar URL.
    required String avatar,

    /// Updated role (e.g., 'DOCTOR', 'THERAPIST').
    required String role,

    /// Updated position/title.
    required String position,

    /// Updated status (e.g., 'ACTIVE', 'INACTIVE', 'ON_LEAVE').
    required String status,

    /// Updated branch assignment.
    required String branch,

    /// Updated email address.
    required String email,

    /// Updated phone number.
    required String phone,

    /// Updated street address.
    required String address,

    /// Updated city.
    required String city,

    /// Updated state/province.
    required String state,

    /// Updated country.
    required String country,

    /// Updated license document URL.
    String? licenseUrl,

    /// Updated ID card document URL.
    String? idCardUrl,

    /// Updated list of document URLs.
    @Default([]) List<String> documents,

    /// New password (only if password change is needed).
    String? password,
  }) = _UpdateEmployeeRequest;

  /// Creates an [UpdateEmployeeRequest] from JSON data.
  factory UpdateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmployeeRequestFromJson(json);
}
