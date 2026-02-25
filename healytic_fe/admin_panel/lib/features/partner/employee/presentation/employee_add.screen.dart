import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
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

  /// Pre-fill all fields in debug builds when `?autofill=true` is in URL.
  final bool autofill;

  @override
  ConsumerState<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends ConsumerState<EmployeeAddScreen> {
  Future<void> _handleSubmit(Map<String, dynamic> values) async {
    try {
      final role =
          values['employee_role']?.toString().toUpperCase() ??
          EmployeeRole.therapist.apiValue;

      if (role == EmployeeRole.doctor.apiValue) {
        await _createDoctor(values);
      } else {
        await _createTherapist(values);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${role == EmployeeRole.doctor.apiValue ? 'Doctor' : 'Therapist'} created successfully',
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
    // Parse name from first_name and last_name fields
    final firstName = values['first_name']?.toString().trim() ?? '';
    final lastName = values['last_name']?.toString().trim() ?? '';

    // Parse specializations and education from comma-separated strings
    final specializations = _parseCommaSeparatedList(
      values['specializations']?.toString(),
    );
    final education = _parseCommaSeparatedList(values['education']?.toString());
    final certifications = _parseCommaSeparatedList(
      values['certifications']?.toString(),
    );

    final request = CreateDoctorRequest(
      firstName: firstName,
      lastName: lastName,
      employeeId:
          values['employee_id']?.toString().trim() ??
          const Uuid().v4().substring(0, 8).toUpperCase(),
      email: values['email_address']?.toString().trim() ?? '',
      phone: values['phone_number']?.toString().trim() ?? '',
      avatar:
          values['avatar_url']?.toString() ??
          'https://i.pravatar.cc/150?u=${values['email_address']}',
      dateOfBirth: values['date_of_birth']?.toString() ?? '',
      gender: values['gender']?.toString().toUpperCase() ?? 'OTHER',
      emergencyContactName:
          values['emergency_contact_name']?.toString() ?? 'Unknown',
      emergencyContactPhone:
          values['emergency_contact_phone']?.toString() ?? 'Unknown',
      employmentType: values['employment_type']?.toString() ?? 'Full-Time',
      startDate: values['start_date']?.toString() ?? DateTime.now().toString(),
      jobTitle: values['job_title']?.toString().trim() ?? 'Doctor',
      medicalLicense: values['medical_license']?.toString().trim() ?? '',
      experienceYears: int.tryParse(
        values['experience_years']?.toString() ?? '',
      ),
      consultationFee: double.tryParse(
        values['consultation_fee']?.toString() ?? '',
      ),
      specializations: specializations,
      education: education,
      certifications: certifications,
      description: values['description']?.toString(),
    );

    await ref.read(employeeProvider.notifier).createDoctor(request);
  }

  Future<void> _createTherapist(Map<String, dynamic> values) async {
    // Parse name from first_name and last_name fields
    final firstName = values['first_name']?.toString().trim() ?? '';
    final lastName = values['last_name']?.toString().trim() ?? '';

    // Determine therapist type
    final type =
        values['therapist_type']?.toString() ?? TherapistType.massage.apiValue;

    // Map therapist level
    String? level = values['therapist_level']?.toString();
    if (level != null) {
      level = level.toUpperCase();
    }

    final double commissionRate =
        double.tryParse(values['commission_rate']?.toString() ?? '') ?? 0.0;
    final String? healthCheckDate = values['health_check_date']?.toString();
    final String? licenseUrl = values['license_url']?.toString();

    // Common fields
    final commonEmployeeId =
        values['employee_id']?.toString().trim() ??
        const Uuid().v4().substring(0, 8).toUpperCase();
    final commonEmail = values['email_address']?.toString().trim() ?? '';
    final commonPhone = values['phone_number']?.toString().trim() ?? '';
    final commonAvatar =
        values['avatar_url']?.toString() ??
        'https://i.pravatar.cc/150?u=${values['email_address']}';
    final commonDob = values['date_of_birth']?.toString() ?? '';
    final commonGender = values['gender']?.toString().toUpperCase() ?? 'OTHER';
    final commonEmergencyName =
        values['emergency_contact_name']?.toString() ?? 'Unknown';
    final commonEmergencyPhone =
        values['emergency_contact_phone']?.toString() ?? 'Unknown';
    final commonEmploymentType =
        values['employment_type']?.toString() ?? 'Full-Time';
    final commonStartDate =
        values['start_date']?.toString() ?? DateTime.now().toString();
    final commonJobTitle =
        values['job_title']?.toString().trim() ?? 'Therapist';
    final commonDescription = values['description']?.toString();

    if (type == TherapistType.spa.apiValue) {
      // Spa Therapist
      List<String> skills = [];
      final rawSkills = values['spa_skills'];
      if (rawSkills is List) {
        skills = rawSkills.map((e) => e.toString()).toList();
      } else if (rawSkills is String) {
        skills = _parseCommaSeparatedList(rawSkills);
      }

      List<String> deviceProficiency = [];
      final rawDevices = values['device_proficiency'];
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
        avatar: commonAvatar,
        jobTitle: commonJobTitle,
        therapistLevel: level,
        commissionRate: commissionRate,
        healthCheckDate: healthCheckDate,
        skills: skills,
        deviceProficiency: deviceProficiency,
        licenseUrl: licenseUrl,
        description: commonDescription,
      );

      await ref.read(employeeProvider.notifier).createSpaTherapist(request);
    } else {
      // Massage Therapist
      List<String> skills = [];
      final rawSkills = values['massage_skills'];
      if (rawSkills is List) {
        skills = rawSkills.map((e) => e.toString()).toList();
      } else if (rawSkills is String) {
        skills = _parseCommaSeparatedList(rawSkills);
      }

      final strengthLevel = values['strength_level']?.toString();

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
        avatar: commonAvatar,
        jobTitle: commonJobTitle,
        therapistLevel: level,
        strengthLevel: strengthLevel,
        commissionRate: commissionRate,
        healthCheckDate: healthCheckDate,
        skills: skills,
        licenseUrl: licenseUrl,
        description: commonDescription,
      );

      await ref.read(employeeProvider.notifier).createMassageTherapist(request);
    }
  }

  List<String> _parseCommaSeparatedList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _handleCancel() {
    context.goNamed(EmployeeHomeRoute.name);
  }

  /// Sample data map for all [EmployeeAddDesktop] `FormBuilder`
  /// fields. Delegates to [EmployeeAddAutofill.forRole].
  static Map<String, dynamic> _buildAutofillValues([
    String role = 'THERAPIST',
  ]) => EmployeeAddAutofill.forRole(role);

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
