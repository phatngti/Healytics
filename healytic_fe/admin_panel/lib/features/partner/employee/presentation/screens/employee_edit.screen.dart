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
        final firstName = _str(values, EmployeeFormField.firstName);
        final lastName = _str(values, EmployeeFormField.lastName);
        final fullName = '$firstName $lastName'.trim();
        final role = _roleApiValue(values) ?? employee.role;
        final jobTitle = _str(values, EmployeeFormField.jobTitle);

        final request = UpdateEmployeeRequest(
          id: employee.id,
          employeeCode:
              _strOrNull(values, EmployeeFormField.employeeId) ??
              employee.employeeCode,
          firstName: firstName.isNotEmpty ? firstName : null,
          lastName: lastName.isNotEmpty ? lastName : null,
          fullName: fullName.isNotEmpty ? fullName : employee.fullName,
          displayName: fullName.isNotEmpty ? fullName : employee.displayName,
          avatar:
              _strOrNull(values, EmployeeFormField.avatarUrl) ??
              employee.avatar,
          role: role,
          position: jobTitle.isNotEmpty ? jobTitle : employee.position,
          status: employee.status,
          branch: 'Main Branch', // TODO: Add branch selection
          email:
              _strOrNull(values, EmployeeFormField.emailAddress) ??
              employee.email,
          phone:
              _strOrNull(values, EmployeeFormField.phoneNumber) ??
              employee.phone,
          dateOfBirth:
              _dateValue(values[EmployeeFormField.dateOfBirth.key]) ??
              employee.dateOfBirth,
          gender: _genderApiValue(values[EmployeeFormField.gender.key]),
          address: employee.address,
          city: employee.city,
          state: employee.state,
          country: employee.country,
          jobTitle: jobTitle.isNotEmpty ? jobTitle : null,
          startDate:
              _dateValue(values[EmployeeFormField.startDate.key]) ??
              employee.startDate,
          employmentType:
              _strOrNull(values, EmployeeFormField.employmentType) ??
              employee.employmentType,
          emergencyContactName: _strOrNull(
            values,
            EmployeeFormField.emergencyContactName,
          ),
          emergencyContactPhone: _strOrNull(
            values,
            EmployeeFormField.emergencyContactPhone,
          ),
          description: values[EmployeeFormField.description.key]?.toString(),
          verificationDocuments: _collectVerificationDocs(values),
          schedule: _collectSchedule(values),
          workHistory: _collectWorkHistory(values),
          medicalTitles: _collectIndexed(
            values,
            EmployeeFormField.medicalTitlePrefix.key,
          ),
          medicalLicenses: _collectIndexed(
            values,
            EmployeeFormField.medicalLicensePrefix.key,
          ),
          experienceYears: int.tryParse(
            values[EmployeeFormField.experienceYears.key]?.toString() ?? '',
          ),
          consultationFee: double.tryParse(
            values[EmployeeFormField.consultationFee.key]?.toString() ?? '',
          ),
          specializations: _toStringList(
            values[EmployeeFormField.specializations.key],
          ),
          education: _toStringList(values[EmployeeFormField.education.key]),
          certifications: _toStringList(
            values[EmployeeFormField.certifications.key],
          ),
          therapistType: _therapistTypeValue(values, employee),
          therapistLevel: _therapistLevelApiValue(
            values[EmployeeFormField.therapistLevel.key],
          ),
          strengthLevel: _strengthLevelApiValue(
            values[EmployeeFormField.strengthLevel.key],
          ),
          commissionRate: double.tryParse(
            values[EmployeeFormField.commissionRate.key]?.toString() ?? '',
          ),
          healthCheckDate: _dateValue(
            values[EmployeeFormField.healthCheckDate.key],
          ),
          skills: _therapistSkills(values),
          deviceProficiency: _toStringList(
            values[EmployeeFormField.deviceProficiency.key],
          ),
        );

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

  String _str(Map<String, dynamic> values, EmployeeFormField field) =>
      values[field.key]?.toString().trim() ?? '';

  String? _strOrNull(Map<String, dynamic> values, EmployeeFormField field) {
    final value = _str(values, field);
    return value.isEmpty ? null : value;
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
