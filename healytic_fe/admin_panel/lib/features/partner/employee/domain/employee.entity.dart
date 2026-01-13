import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.entity.freezed.dart';
part 'employee.entity.g.dart';

extension type const EmployeeId(String value) implements String {
  factory EmployeeId.fromJson(dynamic json) => EmployeeId(json as String);
  String toJson() => value;
}

sealed class EmployeeEntity {
  EmployeeId get id;
  String get fullName;
  String get displayName;
  String get avatar;
  String get role;
  String get position;
  double get rating;
  int get reviewCount;
  String get status;
  String get email;
  String get phone;
  String get address;
  String get city;
  String get state;
  String get country;
  String? get licenseUrl;
  String? get idCardUrl;
  String? get description;
  List<String> get documents;
  List<EmployeeSchedule> get workSchedule;
  String? get dateOfBirth;
  String? get gender;
  String? get employmentType;
  String? get startDate;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toString().toUpperCase();
    final therapistType = json['therapistType']?.toString().toUpperCase();

    if (role == 'DOCTOR') {
      return DoctorEntity.fromJson(json);
    } else if (role == 'THERAPIST') {
      if (therapistType == 'SPA') {
        return SpaTherapistEntity.fromJson(json);
      } else if (therapistType == 'MASSAGE') {
        return MassageTherapistEntity.fromJson(json);
      }
    }
    return BasicEmployeeEntity.fromJson(json);
  }
}

@Freezed(toJson: true)
abstract class DoctorEntity with _$DoctorEntity implements EmployeeEntity {
  const factory DoctorEntity({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required double rating,
    required int reviewCount,
    required String status,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    required String jobTitle,
    required String medicalLicense,
    @Default([]) List<String> specializations,
    @Default([]) List<String> education,
    @Default([]) List<String> certifications,
    int? experienceYears,
    double? consultationFee,
    String? licenseUrl,
    String? idCardUrl,
    String? description,
    @Default([]) List<String> documents,
    @Default([]) List<EmployeeSchedule> workSchedule,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
  }) = _DoctorEntity;

  factory DoctorEntity.fromJson(Map<String, dynamic> json) =>
      _$DoctorEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class SpaTherapistEntity
    with _$SpaTherapistEntity
    implements EmployeeEntity {
  const factory SpaTherapistEntity({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required double rating,
    required int reviewCount,
    required String status,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    required String jobTitle,
    @Default(0.0) double commissionRate,
    @Default([]) List<String> skills,
    @Default([]) List<String> deviceProficiency,
    String? therapistLevel,
    String? healthCheckDate,
    String? licenseUrl,
    String? idCardUrl,
    String? description,
    @Default([]) List<String> documents,
    @Default([]) List<EmployeeSchedule> workSchedule,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
  }) = _SpaTherapistEntity;

  factory SpaTherapistEntity.fromJson(Map<String, dynamic> json) =>
      _$SpaTherapistEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class MassageTherapistEntity
    with _$MassageTherapistEntity
    implements EmployeeEntity {
  const factory MassageTherapistEntity({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required double rating,
    required int reviewCount,
    required String status,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    required String jobTitle,
    @Default(0.0) double commissionRate,
    @Default([]) List<String> skills,
    String? strengthLevel,
    String? therapistLevel,
    String? healthCheckDate,
    String? licenseUrl,
    String? idCardUrl,
    String? description,
    @Default([]) List<String> documents,
    @Default([]) List<EmployeeSchedule> workSchedule,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
  }) = _MassageTherapistEntity;

  factory MassageTherapistEntity.fromJson(Map<String, dynamic> json) =>
      _$MassageTherapistEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class BasicEmployeeEntity
    with _$BasicEmployeeEntity
    implements EmployeeEntity {
  const factory BasicEmployeeEntity({
    required EmployeeId id,
    required String fullName,
    required String displayName,
    required String avatar,
    required String role,
    required String position,
    required double rating,
    required int reviewCount,
    required String status,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String country,
    String? licenseUrl,
    String? idCardUrl,
    String? description,
    @Default([]) List<String> documents,
    @Default([]) List<EmployeeSchedule> workSchedule,
    String? dateOfBirth,
    String? gender,
    String? employmentType,
    String? startDate,
  }) = _BasicEmployeeEntity;

  factory BasicEmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$BasicEmployeeEntityFromJson(json);
}

@Freezed(toJson: true)
abstract class EmployeeSchedule with _$EmployeeSchedule {
  const factory EmployeeSchedule({
    required String day,
    required String start,
    required String end,
    @Default(true) bool isWorking,
  }) = _EmployeeSchedule;

  factory EmployeeSchedule.fromJson(Map<String, dynamic> json) =>
      _$EmployeeScheduleFromJson(json);
}
