import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_employee.request.freezed.dart';
part 'create_employee.request.g.dart';

@Freezed(toJson: true)
abstract class CreateEmployeeRequest with _$CreateEmployeeRequest {
  const factory CreateEmployeeRequest({
    required String name,
    required String email,
    required String password,
  }) = _CreateEmployeeRequest;

  factory CreateEmployeeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateEmployeeRequestFromJson(json);
}
