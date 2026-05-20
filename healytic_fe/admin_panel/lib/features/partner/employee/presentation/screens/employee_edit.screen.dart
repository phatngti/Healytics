import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/massage_strength_level.dart';
import 'package:admin_panel/features/partner/employee/domain/schedule_day.dart';
import 'package:admin_panel/features/partner/employee/domain/schedule_entry_key.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_level.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_edit_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:common/widgets/card/error_card.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeEditScreen extends ConsumerStatefulWidget {
  final String employeeId;

  const EmployeeEditScreen({super.key, required this.employeeId});

  @override
  ConsumerState<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends ConsumerState<EmployeeEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late EmployeeRoleType _selectedRole;
  bool _isEditing = false;
  bool _isInitialized = false;

  EmployeeRoleType _getRoleFromEntity(EmployeeEntity employee) {
    try {
      return EmployeeRoleType.values.firstWhere(
        (e) => e.name.toUpperCase() == employee.role.toUpperCase(),
        orElse: () => EmployeeRoleType.therapist,
      );
    } catch (_) {
      return EmployeeRoleType.therapist;
    }
  }

  Map<String, dynamic> _getInitialValues(EmployeeEntity employee) {
    final nameParts = employee.fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final baseValues = <String, dynamic>{
      EmployeeFormField.firstName.key: firstName,
      EmployeeFormField.lastName.key: lastName,
      EmployeeFormField.emailAddress.key: employee.email,
      EmployeeFormField.phoneNumber.key: employee.phone,
      EmployeeFormField.avatarUrl.key: employee.avatar,
      EmployeeFormField.employeeRole.key: _selectedRole.apiValue,
      EmployeeFormField.employeeId.key: employee.employeeCode,
      EmployeeFormField.verificationDocuments.key: employee
          .verificationDocuments
          .map(
            (d) => {
              'fieldKey': d.fieldKey,
              'documents': d.documents
                  .map(
                    (doc) => {
                      'name': doc.name,
                      'url': doc.url,
                      if (doc.updatedTime != null)
                        'updatedTime': doc.updatedTime,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      EmployeeFormField.dateOfBirth.key: _parseDate(employee.dateOfBirth),
      EmployeeFormField.gender.key: _mapGender(employee.gender),
      EmployeeFormField.employmentType.key: _mapEmploymentType(
        employee.employmentType,
      ),
      EmployeeFormField.startDate.key: _parseDate(employee.startDate),
      EmployeeFormField.description.key: employee.description,
      EmployeeFormField.emergencyContactName.key: employee.emergencyContactName,
      EmployeeFormField.emergencyContactPhone.key:
          employee.emergencyContactPhone,
      EmployeeFormField.workHistory.key: employee.workHistory
          .map((entry) => entry.toJson())
          .toList(),
    };

    if (employee is DoctorEntity) {
      // Indexed medical credential fields
      final credentialMap = <String, dynamic>{};
      for (int i = 0; i < employee.medicalTitles.length; i++) {
        credentialMap['medical_title_$i'] = employee.medicalTitles[i];
      }
      for (int i = 0; i < employee.medicalLicenses.length; i++) {
        credentialMap['medical_license_$i'] = employee.medicalLicenses[i];
      }

      baseValues.addAll({
        EmployeeFormField.jobTitle.key: employee.jobTitle,
        ...credentialMap,
        EmployeeFormField.experienceYears.key: employee.experienceYears
            ?.toString(),
        EmployeeFormField.consultationFee.key: employee.consultationFee
            ?.toString(),
        EmployeeFormField.specializations.key: employee.specializations,
        EmployeeFormField.education.key: employee.education,
        EmployeeFormField.certifications.key: employee.certifications,
      });
    } else if (employee is SpaTherapistEntity) {
      baseValues.addAll({
        EmployeeFormField.jobTitle.key: employee.jobTitle,
        EmployeeFormField.therapistType.key: TherapistType.spa.apiValue,
        EmployeeFormField.therapistLevel.key: _mapTherapistLevel(
          employee.therapistLevel,
        ),
        EmployeeFormField.commissionRate.key: employee.commissionRate
            .toString(),
        EmployeeFormField.healthCheckDate.key: _parseDate(
          employee.healthCheckDate,
        ),
        EmployeeFormField.spaSkills.key: employee.skills,
        EmployeeFormField.deviceProficiency.key: employee.deviceProficiency,
      });
    } else if (employee is MassageTherapistEntity) {
      baseValues.addAll({
        EmployeeFormField.jobTitle.key: employee.jobTitle,
        EmployeeFormField.therapistType.key: TherapistType.massage.apiValue,
        EmployeeFormField.therapistLevel.key: _mapTherapistLevel(
          employee.therapistLevel,
        ),
        EmployeeFormField.commissionRate.key: employee.commissionRate
            .toString(),
        EmployeeFormField.healthCheckDate.key: _parseDate(
          employee.healthCheckDate,
        ),
        EmployeeFormField.massageSkills.key: employee.skills,
        EmployeeFormField.strengthLevel.key: employee.strengthLevel,
      });
    }

    return baseValues;
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  String? _mapGender(String? gender) {
    return EmployeeGender.fromApiValue(gender)?.displayName;
  }

  String? _mapEmploymentType(String? employmentType) {
    if (employmentType == null || employmentType.isEmpty) return null;
    final parsed = EmploymentType.fromApiValue(employmentType);
    return parsed?.displayName ?? employmentType;
  }

  String? _mapTherapistLevel(String? therapistLevel) {
    if (therapistLevel == null || therapistLevel.isEmpty) return null;
    final parsed = TherapistLevel.fromApiValue(therapistLevel);
    return parsed?.displayName ?? therapistLevel;
  }

  void _toggleEdit(EmployeeEntity employee) {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form when cancelling edit
        _formKey.currentState?.reset();
        _selectedRole = _getRoleFromEntity(employee);
      }
    });
  }

  Future<void> _handleSubmit(EmployeeEntity employee) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      try {
        final request = _buildDeltaRequest(
          employee,
          values,
          _getInitialValues(employee),
        );

        if (request.fields.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No employee changes to save.')),
            );
          }
          return;
        }

        await ref.read(employeeProvider.notifier).updateEmployee(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee updated successfully')),
          );
          // Refresh details
          ref.invalidate(
            employeeDetailsProvider(EmployeeId(widget.employeeId)),
          );
          setState(() {
            _isEditing = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating employee: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  void _handleRoleChanged(EmployeeRoleType _) {
    // Existing employees keep their original role type.
  }

  UpdateEmployeeRequest _buildDeltaRequest(
    EmployeeEntity employee,
    Map<String, dynamic> values,
    Map<String, dynamic> initialValues,
  ) {
    final fields = <String, dynamic>{};
    const orderedEq = DeepCollectionEquality();
    const unorderedEq = DeepCollectionEquality.unordered();

    void addIfChanged(String key, dynamic current, dynamic initial) {
      if (!_valuesEqual(current, initial)) {
        fields[key] = current;
      }
    }

    final firstName = _strOrNull(values, EmployeeFormField.firstName);
    final initialFirstName = _strOrNull(
      initialValues,
      EmployeeFormField.firstName,
    );
    final lastName = _strOrNull(values, EmployeeFormField.lastName);
    final initialLastName = _strOrNull(
      initialValues,
      EmployeeFormField.lastName,
    );
    final fullName = _fullName(firstName, lastName);
    final initialFullName = _fullName(initialFirstName, initialLastName);
    final jobTitle = _strOrNull(values, EmployeeFormField.jobTitle);
    final initialJobTitle = _strOrNull(
      initialValues,
      EmployeeFormField.jobTitle,
    );

    addIfChanged(
      'employeeCode',
      _strOrNull(values, EmployeeFormField.employeeId),
      _strOrNull(initialValues, EmployeeFormField.employeeId),
    );
    addIfChanged('firstName', firstName, initialFirstName);
    addIfChanged('lastName', lastName, initialLastName);
    addIfChanged('fullName', fullName, initialFullName);
    addIfChanged(
      'avatarUrl',
      _strOrNull(values, EmployeeFormField.avatarUrl),
      _strOrNull(initialValues, EmployeeFormField.avatarUrl),
    );
    addIfChanged(
      'role',
      _roleApiValue(values),
      _roleApiValue(initialValues),
    );
    addIfChanged(
      'email',
      _strOrNull(values, EmployeeFormField.emailAddress),
      _strOrNull(initialValues, EmployeeFormField.emailAddress),
    );
    addIfChanged(
      'phone',
      _strOrNull(values, EmployeeFormField.phoneNumber),
      _strOrNull(initialValues, EmployeeFormField.phoneNumber),
    );
    addIfChanged(
      'dob',
      _dateValue(values[EmployeeFormField.dateOfBirth.key]),
      _dateValue(initialValues[EmployeeFormField.dateOfBirth.key]),
    );
    addIfChanged(
      'gender',
      _genderApiValue(values[EmployeeFormField.gender.key]),
      _genderApiValue(initialValues[EmployeeFormField.gender.key]),
    );
    addIfChanged('jobTitle', jobTitle, initialJobTitle);
    addIfChanged(
      'startDate',
      _dateValue(values[EmployeeFormField.startDate.key]),
      _dateValue(initialValues[EmployeeFormField.startDate.key]),
    );
    addIfChanged(
      'employmentType',
      _employmentTypeApiValue(values[EmployeeFormField.employmentType.key]),
      _employmentTypeApiValue(
        initialValues[EmployeeFormField.employmentType.key],
      ),
    );
    addIfChanged(
      'emergencyContactName',
      _strOrNull(values, EmployeeFormField.emergencyContactName),
      _strOrNull(initialValues, EmployeeFormField.emergencyContactName),
    );
    addIfChanged(
      'emergencyContactPhone',
      _strOrNull(values, EmployeeFormField.emergencyContactPhone),
      _strOrNull(initialValues, EmployeeFormField.emergencyContactPhone),
    );
    addIfChanged(
      'description',
      _stringOrNull(values[EmployeeFormField.description.key]),
      _stringOrNull(initialValues[EmployeeFormField.description.key]),
    );

    final verificationDocuments = _collectVerificationDocs(values);
    final initialVerificationDocuments = _collectVerificationDocs(
      initialValues,
    );
    if (!orderedEq.equals(
      verificationDocuments,
      initialVerificationDocuments,
    )) {
      fields['verificationDocuments'] = verificationDocuments;
    }

    final schedule = _collectSchedule(values);
    final initialSchedule = _initialSchedule(employee);
    if (!orderedEq.equals(schedule, initialSchedule)) {
      fields['schedule'] = schedule;
    }

    final workHistory = _collectWorkHistory(values);
    final initialWorkHistory = _collectWorkHistory(initialValues);
    if (!orderedEq.equals(workHistory, initialWorkHistory)) {
      fields['workHistory'] = workHistory;
    }

    final doctorProfile = _buildDoctorProfileDelta(
      employee,
      values,
      initialValues,
      jobTitle,
      initialJobTitle,
      orderedEq,
      unorderedEq,
    );
    if (doctorProfile.isNotEmpty) {
      fields['doctorProfile'] = doctorProfile;
    }

    final therapistProfile = _buildTherapistProfileDelta(
      employee,
      values,
      initialValues,
      unorderedEq,
    );
    if (therapistProfile.isNotEmpty) {
      fields['therapistProfile'] = therapistProfile;
    }

    return UpdateEmployeeRequest(id: employee.id, fields: fields);
  }

  Map<String, dynamic> _buildDoctorProfileDelta(
    EmployeeEntity employee,
    Map<String, dynamic> values,
    Map<String, dynamic> initialValues,
    String? jobTitle,
    String? initialJobTitle,
    DeepCollectionEquality orderedEq,
    DeepCollectionEquality unorderedEq,
  ) {
    if (employee is! DoctorEntity) return <String, dynamic>{};

    final profile = <String, dynamic>{};

    void addIfChanged(String key, dynamic current, dynamic initial) {
      if (!_valuesEqual(current, initial)) {
        profile[key] = current;
      }
    }

    addIfChanged('title', jobTitle, initialJobTitle);

    final medicalTitles = _collectIndexed(
      values,
      EmployeeFormField.medicalTitlePrefix.key,
    );
    final initialMedicalTitles = _collectIndexed(
      initialValues,
      EmployeeFormField.medicalTitlePrefix.key,
    );
    final medicalLicenses = _collectIndexed(
      values,
      EmployeeFormField.medicalLicensePrefix.key,
    );
    final initialMedicalLicenses = _collectIndexed(
      initialValues,
      EmployeeFormField.medicalLicensePrefix.key,
    );
    if (!orderedEq.equals(medicalTitles, initialMedicalTitles) ||
        !orderedEq.equals(medicalLicenses, initialMedicalLicenses)) {
      profile['medicalCredentials'] = _medicalCredentials(
        medicalTitles,
        medicalLicenses,
      );
    }

    addIfChanged(
      'experienceYears',
      _parseInt(values[EmployeeFormField.experienceYears.key]),
      _parseInt(initialValues[EmployeeFormField.experienceYears.key]),
    );
    addIfChanged(
      'consultationFee',
      _parseDouble(values[EmployeeFormField.consultationFee.key]),
      _parseDouble(initialValues[EmployeeFormField.consultationFee.key]),
    );

    final specializations = _toStringList(
      values[EmployeeFormField.specializations.key],
    );
    final initialSpecializations = _toStringList(
      initialValues[EmployeeFormField.specializations.key],
    );
    if (!unorderedEq.equals(specializations, initialSpecializations)) {
      profile['specializations'] = specializations;
    }

    final education = _toStringList(values[EmployeeFormField.education.key]);
    final initialEducation = _toStringList(
      initialValues[EmployeeFormField.education.key],
    );
    if (!unorderedEq.equals(education, initialEducation)) {
      profile['education'] = education;
    }

    final certifications = _toStringList(
      values[EmployeeFormField.certifications.key],
    );
    final initialCertifications = _toStringList(
      initialValues[EmployeeFormField.certifications.key],
    );
    if (!unorderedEq.equals(certifications, initialCertifications)) {
      profile['certifications'] = certifications;
    }

    return profile;
  }

  Map<String, dynamic> _buildTherapistProfileDelta(
    EmployeeEntity employee,
    Map<String, dynamic> values,
    Map<String, dynamic> initialValues,
    DeepCollectionEquality unorderedEq,
  ) {
    if (employee is! SpaTherapistEntity &&
        employee is! MassageTherapistEntity) {
      return <String, dynamic>{};
    }

    final profile = <String, dynamic>{};

    void addIfChanged(String key, dynamic current, dynamic initial) {
      if (!_valuesEqual(current, initial)) {
        profile[key] = current;
      }
    }

    final type = _therapistTypeValue(values, employee);
    final initialType = _therapistTypeValue(initialValues, employee);
    final currentTherapistType = TherapistType.fromApiValue(type);
    final initialTherapistType = TherapistType.fromApiValue(initialType);

    addIfChanged('type', type, initialType);
    addIfChanged(
      'level',
      _therapistLevelApiValue(
        values[EmployeeFormField.therapistLevel.key],
      ),
      _therapistLevelApiValue(
        initialValues[EmployeeFormField.therapistLevel.key],
      ),
    );
    addIfChanged(
      'commissionRate',
      _parseDouble(values[EmployeeFormField.commissionRate.key]),
      _parseDouble(initialValues[EmployeeFormField.commissionRate.key]),
    );
    addIfChanged(
      'healthCheckDate',
      _dateValue(values[EmployeeFormField.healthCheckDate.key]),
      _dateValue(initialValues[EmployeeFormField.healthCheckDate.key]),
    );

    final strengthLevel = currentTherapistType == TherapistType.massage
        ? _strengthLevelApiValue(values[EmployeeFormField.strengthLevel.key])
        : null;
    final initialStrengthLevel = initialTherapistType == TherapistType.massage
        ? _strengthLevelApiValue(
            initialValues[EmployeeFormField.strengthLevel.key],
          )
        : null;
    addIfChanged('strengthLevel', strengthLevel, initialStrengthLevel);

    final skills = _therapistSkills(values);
    final initialSkills = _therapistSkills(initialValues);
    if (!unorderedEq.equals(skills, initialSkills)) {
      profile['skills'] = skills;
    }

    final deviceProficiency = currentTherapistType == TherapistType.spa
        ? _toStringList(values[EmployeeFormField.deviceProficiency.key])
        : const <String>[];
    final initialDeviceProficiency = initialTherapistType == TherapistType.spa
        ? _toStringList(
            initialValues[EmployeeFormField.deviceProficiency.key],
          )
        : const <String>[];
    if (!unorderedEq.equals(deviceProficiency, initialDeviceProficiency)) {
      profile['deviceProficiency'] = deviceProficiency;
    }

    return profile;
  }

  String _str(Map<String, dynamic> values, EmployeeFormField field) =>
      values[field.key]?.toString().trim() ?? '';

  String? _strOrNull(Map<String, dynamic> values, EmployeeFormField field) {
    final value = _str(values, field);
    return value.isEmpty ? null : value;
  }

  bool _valuesEqual(dynamic current, dynamic initial) => current == initial;

  String? _stringOrNull(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  String? _fullName(String? firstName, String? lastName) {
    final text = [firstName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .join(' ')
        .trim();
    return text.isEmpty ? null : text;
  }

  int? _parseInt(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return int.tryParse(text);
  }

  double? _parseDouble(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return double.tryParse(text);
  }

  String? _dateValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toIso8601String().split('T').first;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    final parsed = DateTime.tryParse(text);
    return parsed?.toIso8601String().split('T').first ?? text;
  }

  String? _roleApiValue(Map<String, dynamic> values) {
    final raw = values[EmployeeFormField.employeeRole.key];
    if (raw is EmployeeRoleType) return raw.apiValue;
    final text = raw?.toString();
    if (text == null || text.isEmpty) return null;
    return EmployeeRoleType.fromApiValue(text)?.apiValue ?? text.toUpperCase();
  }

  String? _genderApiValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    for (final gender in EmployeeGender.values) {
      if (gender.displayName == text) return gender.apiValue;
    }
    return EmployeeGender.fromApiValue(text)?.apiValue ?? text.toUpperCase();
  }

  String? _employmentTypeApiValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    for (final type in EmploymentType.values) {
      if (type.displayName == text) return type.apiValue;
    }
    return EmploymentType.fromApiValue(text)?.apiValue ?? text.toUpperCase();
  }

  String? _therapistLevelApiValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    for (final level in TherapistLevel.values) {
      if (level.displayName == text) return level.apiValue;
    }
    return TherapistLevel.fromApiValue(text)?.apiValue ?? text.toUpperCase();
  }

  String? _strengthLevelApiValue(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    for (final level in MassageStrengthLevel.values) {
      if (level.displayName == text) return level.apiValue;
    }
    return MassageStrengthLevel.fromApiValue(text)?.apiValue ??
        text.toUpperCase();
  }

  String? _therapistTypeValue(
    Map<String, dynamic> values,
    EmployeeEntity employee,
  ) {
    final raw = values[EmployeeFormField.therapistType.key]?.toString();
    if (raw != null && raw.isNotEmpty) {
      return TherapistType.fromApiValue(raw)?.apiValue ?? raw.toUpperCase();
    }
    return _getTherapistType(employee)?.apiValue;
  }

  TherapistType? _getTherapistType(EmployeeEntity employee) {
    if (employee is SpaTherapistEntity) return TherapistType.spa;
    if (employee is MassageTherapistEntity) return TherapistType.massage;
    return null;
  }

  List<String> _therapistSkills(Map<String, dynamic> values) {
    final type = values[EmployeeFormField.therapistType.key]?.toString();
    final isSpa = TherapistType.fromApiValue(type) == TherapistType.spa;
    return _toStringList(
      values[isSpa
          ? EmployeeFormField.spaSkills.key
          : EmployeeFormField.massageSkills.key],
    );
  }

  List<String> _collectIndexed(Map<String, dynamic> values, String prefix) {
    final result = <String>[];
    for (var i = 0; ; i++) {
      final value = values['$prefix$i']?.toString().trim();
      if (value == null) break;
      if (value.isNotEmpty) result.add(value);
    }
    return result;
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (value is String && value.isNotEmpty) {
      return value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  List<Map<String, dynamic>> _medicalCredentials(
    List<String> titles,
    List<String> licenses,
  ) {
    final count = titles.length > licenses.length
        ? titles.length
        : licenses.length;
    return List.generate(count, (index) {
      return {
        'title': index < titles.length ? titles[index] : '',
        'license': index < licenses.length ? licenses[index] : '',
      };
    });
  }

  List<Map<String, dynamic>> _collectWorkHistory(Map<String, dynamic> values) {
    final raw = values[EmployeeFormField.workHistory.key];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  List<Map<String, dynamic>> _collectSchedule(Map<String, dynamic> values) {
    return ScheduleDay.values.map((day) {
      final val = values[day.scheduleFieldKey];
      if (val is List && val.length == 2) {
        final start = val[0]?.toString() ?? '';
        final end = val[1]?.toString() ?? '';
        return {
          ScheduleEntryKey.day: day.displayName,
          ScheduleEntryKey.start: start,
          ScheduleEntryKey.end: end,
          ScheduleEntryKey.isWorking: start.isNotEmpty && end.isNotEmpty,
        };
      }
      return {
        ScheduleEntryKey.day: day.displayName,
        ScheduleEntryKey.start: '',
        ScheduleEntryKey.end: '',
        ScheduleEntryKey.isWorking: false,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _initialSchedule(EmployeeEntity employee) {
    return ScheduleDay.values.map((day) {
      final existing = _scheduleForDay(employee.workSchedule, day);
      if (existing != null) {
        return {
          ScheduleEntryKey.day: day.displayName,
          ScheduleEntryKey.start: existing.start,
          ScheduleEntryKey.end: existing.end,
          ScheduleEntryKey.isWorking: existing.isWorking,
        };
      }
      return _defaultScheduleEntry(day);
    }).toList();
  }

  EmployeeSchedule? _scheduleForDay(
    List<EmployeeSchedule> schedule,
    ScheduleDay day,
  ) {
    if (schedule.isEmpty) return null;
    for (final entry in schedule) {
      if (entry.day.toLowerCase() == day.formKey) {
        return entry;
      }
    }
    return null;
  }

  Map<String, dynamic> _defaultScheduleEntry(ScheduleDay day) {
    final isWeekday = switch (day) {
      ScheduleDay.monday ||
      ScheduleDay.tuesday ||
      ScheduleDay.wednesday ||
      ScheduleDay.thursday ||
      ScheduleDay.friday => true,
      ScheduleDay.saturday || ScheduleDay.sunday => false,
    };
    final end = day == ScheduleDay.friday ? '13:00' : '17:00';
    return {
      ScheduleEntryKey.day: day.displayName,
      ScheduleEntryKey.start: isWeekday ? '09:00' : '',
      ScheduleEntryKey.end: isWeekday ? end : '',
      ScheduleEntryKey.isWorking: isWeekday,
    };
  }

  /// Collects verification documents from
  /// form values.
  List<Map<String, dynamic>> _collectVerificationDocs(
    Map<String, dynamic> values,
  ) {
    final raw = values[EmployeeFormField.verificationDocuments.key];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(
      employeeDetailsProvider(EmployeeId(widget.employeeId)),
    );

    return employeeAsync.when(
      data: (employee) {
        if (!_isInitialized) {
          _selectedRole = _getRoleFromEntity(employee);
          _isInitialized = true;
        }

        return FormBuilder(
          key: _formKey,
          initialValue: _getInitialValues(employee),
          enabled: _isEditing,
          child: ResponsiveWrapper(
            useLayout: true,
            desktop: EmployeeEditDesktop(
              employee: employee,
              isEditing: _isEditing,
              selectedRole: _selectedRole,
              onRoleChanged: _handleRoleChanged,
              onToggleEdit: () => _toggleEdit(employee),
              onSave: () => _handleSubmit(employee),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: ErrorCard(
          title: 'Failed to load employee details',
          error: error,
          stackTrace: stack,
          onRetry: () => ref.refresh(
            employeeDetailsProvider(EmployeeId(widget.employeeId)),
          ),
        ),
      ),
    );
  }
}
