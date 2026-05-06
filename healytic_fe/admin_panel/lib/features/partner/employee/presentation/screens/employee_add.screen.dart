import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/schedule_day.dart';
import 'package:admin_panel/features/partner/employee/domain/schedule_entry_key.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/autofill/employee_add.autofill.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_add_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class EmployeeAddScreen extends ConsumerStatefulWidget {
  const EmployeeAddScreen({super.key, this.autofill = false});

  /// Pre-fill all fields in debug builds
  /// when `?autofill=true` is in URL.
  final bool autofill;

  @override
  ConsumerState<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends ConsumerState<EmployeeAddScreen> {
  Future<void> _handleSubmit(Map<String, dynamic> values) async {
    final description = values[EmployeeFormField.description.key]?.toString();
    if (description == null || description.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Description is required'),
            backgroundColor: Theme.of(
              context,
            ).extension<SemanticColors>()!.error,
          ),
        );
      }
      return;
    }

    try {
      final role =
          values[EmployeeFormField.employeeRole.key]
              ?.toString()
              .toUpperCase() ??
          EmployeeRole.therapist.apiValue;

      if (role == EmployeeRole.doctor.apiValue) {
        await _createDoctor(values);
      } else {
        await _createTherapist(values);
      }

      if (mounted) {
        final roleEnum = EmployeeRole.fromApiValue(role);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${roleEnum?.displayName ?? role}'
              ' created successfully',
            ),
          ),
        );
        context.goNamed(EmployeeHomeRoute.name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating employee: $e'),
            backgroundColor: Theme.of(
              context,
            ).extension<SemanticColors>()!.error,
          ),
        );
      }
    }
  }

  Future<void> _createDoctor(Map<String, dynamic> values) async {
    final firstName = _str(values, EmployeeFormField.firstName);
    final lastName = _str(values, EmployeeFormField.lastName);

    final medicalTitles = _collectIndexed(
      values,
      EmployeeFormField.medicalTitlePrefix.key,
    );
    final medicalLicenses = _collectIndexed(
      values,
      EmployeeFormField.medicalLicensePrefix.key,
    );

    final specializations = _toStringList(
      values[EmployeeFormField.specializations.key],
    );
    final education = _toStringList(values[EmployeeFormField.education.key]);
    final certifications = _toStringList(
      values[EmployeeFormField.certifications.key],
    );

    final request = CreateDoctorRequest(
      firstName: firstName,
      lastName: lastName,
      employeeId: _employeeId(values),
      email: _str(values, EmployeeFormField.emailAddress),
      phone: _str(values, EmployeeFormField.phoneNumber),
      avatar: _avatarUrl(values),
      dateOfBirth: _strOrEmpty(values, EmployeeFormField.dateOfBirth),
      gender: _gender(values),
      emergencyContactName: _emergencyName(values),
      emergencyContactPhone: _emergencyPhone(values),
      employmentType: _employmentType(values),
      startDate: _startDate(values),
      schedule: _collectSchedule(values),
      verificationDocuments: _collectVerificationDocs(values),
      jobTitle: _str(values, EmployeeFormField.jobTitle).isNotEmpty
          ? _str(values, EmployeeFormField.jobTitle)
          : EmployeeRole.doctor.displayName,
      medicalTitles: medicalTitles,
      medicalLicenses: medicalLicenses,
      experienceYears: int.tryParse(
        values[EmployeeFormField.experienceYears.key]?.toString() ?? '',
      ),
      consultationFee: double.tryParse(
        values[EmployeeFormField.consultationFee.key]?.toString() ?? '',
      ),
      specializations: specializations,
      education: education,
      certifications: certifications,
      description: values[EmployeeFormField.description.key]?.toString(),
      workHistory: _collectWorkHistory(values),
    );

    await ref.read(employeeProvider.notifier).createDoctor(request);
  }

  /// Collects indexed form values like `prefix_0`,
  /// `prefix_1`, … into a list of non-empty strings.
  List<String> _collectIndexed(Map<String, dynamic> values, String prefix) {
    final result = <String>[];
    for (int i = 0; ; i++) {
      final v = values['$prefix$i']?.toString().trim();
      if (v == null) break;
      if (v.isNotEmpty) result.add(v);
    }
    return result;
  }

  /// Safely converts a value to `List<String>`.
  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    if (value is String && value.isNotEmpty) {
      return _parseCommaSeparatedList(value);
    }
    return [];
  }

  Future<void> _createTherapist(Map<String, dynamic> values) async {
    final firstName = _str(values, EmployeeFormField.firstName);
    final lastName = _str(values, EmployeeFormField.lastName);

    final type =
        values[EmployeeFormField.therapistType.key]?.toString() ??
        TherapistType.massage.apiValue;

    String? level = values[EmployeeFormField.therapistLevel.key]?.toString();
    if (level != null) {
      level = level.toUpperCase();
    }

    final double commissionRate =
        double.tryParse(
          values[EmployeeFormField.commissionRate.key]?.toString() ?? '',
        ) ??
        0.0;
    final String? healthCheckDate =
        values[EmployeeFormField.healthCheckDate.key]?.toString();

    // Common fields
    final commonEmployeeId = _employeeId(values);
    final commonEmail = _str(values, EmployeeFormField.emailAddress);
    final commonPhone = _str(values, EmployeeFormField.phoneNumber);
    final commonAvatar = _avatarUrl(values);
    final commonDob = _strOrEmpty(values, EmployeeFormField.dateOfBirth);
    final commonGender = _gender(values);
    final commonEmergencyName = _emergencyName(values);
    final commonEmergencyPhone = _emergencyPhone(values);
    final commonEmploymentType = _employmentType(values);
    final commonStartDate = _startDate(values);
    final jobTitle = _str(values, EmployeeFormField.jobTitle);
    final commonJobTitle = jobTitle.isNotEmpty
        ? jobTitle
        : EmployeeRole.therapist.displayName;
    final commonDescription = values[EmployeeFormField.description.key]
        ?.toString();

    if (type == TherapistType.spa.apiValue) {
      final skills = _parseSkills(values[EmployeeFormField.spaSkills.key]);

      List<String> deviceProficiency = [];
      final rawDevices = values[EmployeeFormField.deviceProficiency.key];
      if (rawDevices is List) {
        deviceProficiency = rawDevices.map((e) => e.toString()).toList();
      }

      final request = CreateSpaTherapistRequest(
        firstName: firstName,
        lastName: lastName,
        employeeId: commonEmployeeId,
        email: commonEmail,
        phone: commonPhone,
        dateOfBirth: commonDob,
        gender: commonGender,
        emergencyContactName: commonEmergencyName,
        emergencyContactPhone: commonEmergencyPhone,
        employmentType: commonEmploymentType,
        startDate: commonStartDate,
        schedule: _collectSchedule(values),
        avatar: commonAvatar,
        verificationDocuments: _collectVerificationDocs(values),
        jobTitle: commonJobTitle,
        therapistLevel: level,
        commissionRate: commissionRate,
        healthCheckDate: healthCheckDate,
        skills: skills,
        deviceProficiency: deviceProficiency,
        description: commonDescription,
        workHistory: _collectWorkHistory(values),
      );

      await ref.read(employeeProvider.notifier).createSpaTherapist(request);
    } else {
      final skills = _parseSkills(values[EmployeeFormField.massageSkills.key]);

      final strengthLevel = values[EmployeeFormField.strengthLevel.key]
          ?.toString();

      final request = CreateMassageTherapistRequest(
        firstName: firstName,
        lastName: lastName,
        employeeId: commonEmployeeId,
        email: commonEmail,
        phone: commonPhone,
        dateOfBirth: commonDob,
        gender: commonGender,
        emergencyContactName: commonEmergencyName,
        emergencyContactPhone: commonEmergencyPhone,
        employmentType: commonEmploymentType,
        startDate: commonStartDate,
        schedule: _collectSchedule(values),
        avatar: commonAvatar,
        verificationDocuments: _collectVerificationDocs(values),
        jobTitle: commonJobTitle,
        therapistLevel: level,
        strengthLevel: strengthLevel,
        commissionRate: commissionRate,
        healthCheckDate: healthCheckDate,
        skills: skills,
        description: commonDescription,
        workHistory: _collectWorkHistory(values),
      );

      await ref.read(employeeProvider.notifier).createMassageTherapist(request);
    }
  }

  // ── Helpers ──────────────────────────────────────

  /// Reads a trimmed string from form [values].
  String _str(Map<String, dynamic> values, EmployeeFormField field) =>
      values[field.key]?.toString().trim() ?? '';

  /// Reads a non-trimmed string, defaulting to `''`.
  String _strOrEmpty(Map<String, dynamic> values, EmployeeFormField field) =>
      values[field.key]?.toString() ?? '';

  /// Returns the employee ID or generates one.
  String _employeeId(Map<String, dynamic> values) {
    final id = _str(values, EmployeeFormField.employeeId);
    return id.isNotEmpty ? id : const Uuid().v4().substring(0, 8).toUpperCase();
  }

  /// Returns the avatar URL or a placeholder.
  String _avatarUrl(Map<String, dynamic> values) =>
      values[EmployeeFormField.avatarUrl.key]?.toString() ??
      'https://i.pravatar.cc/150?u='
          '${values[EmployeeFormField.emailAddress.key]}';

  /// Returns the gender API value,
  /// defaulting to `OTHER`.
  String _gender(Map<String, dynamic> values) =>
      values[EmployeeFormField.gender.key]?.toString().toUpperCase() ??
      EmployeeGender.nonBinary.apiValue!;

  /// Returns emergency contact name.
  String _emergencyName(Map<String, dynamic> values) =>
      values[EmployeeFormField.emergencyContactName.key]?.toString() ?? '';

  /// Returns emergency contact phone.
  String _emergencyPhone(Map<String, dynamic> values) =>
      values[EmployeeFormField.emergencyContactPhone.key]?.toString() ?? '';

  /// Returns employment type,
  /// defaulting to full-time.
  String _employmentType(Map<String, dynamic> values) =>
      values[EmployeeFormField.employmentType.key]?.toString() ??
      EmploymentType.fullTime.displayName;

  /// Returns the start date string.
  String _startDate(Map<String, dynamic> values) =>
      values[EmployeeFormField.startDate.key]?.toString() ??
      DateTime.now().toString();

  /// Parses a raw skills value into a list.
  List<String> _parseSkills(dynamic rawSkills) {
    if (rawSkills is List) {
      return rawSkills.map((e) => e.toString()).toList();
    }
    if (rawSkills is String) {
      return _parseCommaSeparatedList(rawSkills);
    }
    return [];
  }

  List<String> _parseCommaSeparatedList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Extracts work history entries from form values.
  List<Map<String, dynamic>> _collectWorkHistory(Map<String, dynamic> values) {
    final raw = values[EmployeeFormField.workHistory.key];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  /// Collects schedule entries from per-day form
  /// fields into a list of maps matching
  /// `WorkScheduleEntryDto` JSON shape.
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
          ScheduleEntryKey.isWorking: true,
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

  List<Map<String, dynamic>> _collectVerificationDocs(
    Map<String, dynamic> values,
  ) {
    final raw = values[EmployeeFormField.verificationDocuments.key];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  void _handleCancel() {
    context.goNamed(EmployeeHomeRoute.name);
  }

  /// Sample data map for all [EmployeeAddDesktop]
  /// `FormBuilder` fields.
  /// Delegates to [EmployeeAddAutofill.forRole].
  static Map<String, dynamic> _buildAutofillValues([
    String? role,
    String? therapistType,
  ]) => EmployeeAddAutofill.forRole(
    role ?? EmployeeRole.therapist.apiValue,
    therapistType,
  );

  @override
  Widget build(BuildContext context) {
    final shouldAutofill =
        kDebugMode &&
        (widget.autofill || (Store.tryGet(StoreKey.autoFill) ?? false));
    final initialValue = shouldAutofill
        ? _buildAutofillValues()
        : const <String, dynamic>{};

    return ResponsiveWrapper(
      useLayout: true,
      desktop: EmployeeAddDesktop(
        onCancel: _handleCancel,
        onSubmit: _handleSubmit,
        initialValue: initialValue,
        shouldAutofill: shouldAutofill,
        onBuildAutofillValues: _buildAutofillValues,
      ),
    );
  }
}
