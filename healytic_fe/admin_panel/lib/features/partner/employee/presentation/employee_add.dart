import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/create_doctor.request.dart';
import 'package:admin_panel/features/partner/employee/domain/create_therapist.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_add_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class EmployeeAddScreen extends ConsumerStatefulWidget {
  const EmployeeAddScreen({super.key});

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
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createDoctor(Map<String, dynamic> values) async {
    // Parse name from first_name and last_name fields
    final firstName = values['first_name']?.toString().trim() ?? '';
    final lastName = values['last_name']?.toString().trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    // Parse specializations and education from comma-separated strings
    final specializations = _parseCommaSeparatedList(
      values['specializations']?.toString(),
    );
    final education = _parseCommaSeparatedList(values['education']?.toString());

    final request = CreateDoctorRequest(
      employeeCode:
          values['employee_id']?.toString().trim() ??
          const Uuid().v4().substring(0, 8).toUpperCase(),
      fullName: fullName.isNotEmpty ? fullName : 'New Doctor',
      displayName: fullName.isNotEmpty ? fullName : null,
      email: values['email_address']?.toString().trim() ?? '',
      phone: values['phone_number']?.toString().trim(),
      avatarUrl:
          values['avatar_url']?.toString() ??
          'https://i.pravatar.cc/150?u=${values['email_address']}',
      dob: values['date_of_birth']?.toString(),
      gender: values['gender']?.toString().toUpperCase(),
      branchId: null, // TODO: Add branch selection
      title: values['medical_title']?.toString().trim(),
      medicalLicense: values['medical_license']?.toString().trim() ?? '',
      experienceYears: int.tryParse(
        values['experience_years']?.toString() ?? '',
      ),
      consultationFee: double.tryParse(
        values['consultation_fee']?.toString() ?? '',
      ),
      specializations: specializations,
      education: education,
    );

    await ref.read(employeeProvider.notifier).createDoctor(request);
  }

  Future<void> _createTherapist(Map<String, dynamic> values) async {
    // Parse name from first_name and last_name fields
    final firstName = values['first_name']?.toString().trim() ?? '';
    final lastName = values['last_name']?.toString().trim() ?? '';
    final fullName = '$firstName $lastName'.trim();

    // Determine therapist type
    final type =
        values['therapist_type']?.toString() ?? TherapistType.massage.apiValue;

    // Parse skills based on type
    List<String> skills = [];
    final skillsKey = type == TherapistType.spa.apiValue
        ? 'spa_skills'
        : 'massage_skills';
    final rawSkills = values[skillsKey];

    if (rawSkills is List) {
      skills = rawSkills.map((e) => e.toString()).toList();
    } else if (rawSkills is String) {
      skills = _parseCommaSeparatedList(rawSkills);
    }

    // Map therapist level
    String? level = values['therapist_level']?.toString();
    if (level != null) {
      level = level.toUpperCase();
    }

    final request = CreateTherapistRequest(
      employeeCode:
          values['employee_id']?.toString().trim() ??
          const Uuid().v4().substring(0, 8).toUpperCase(),
      fullName: fullName.isNotEmpty ? fullName : 'New Therapist',
      displayName: fullName.isNotEmpty ? fullName : null,
      email: values['email_address']?.toString().trim() ?? '',
      phone: values['phone_number']?.toString().trim(),
      avatarUrl:
          values['avatar_url']?.toString() ??
          'https://i.pravatar.cc/150?u=${values['email_address']}',
      dob: values['date_of_birth']?.toString(),
      gender: values['gender']?.toString().toUpperCase(),
      branchId: null, // TODO: Add branch selection
      level: level,
      type: type,
      strengthLevel: values['strength_level']?.toString(),
      commissionRate:
          double.tryParse(values['commission_rate']?.toString() ?? '') ?? 0,
      healthCheckDate: values['health_check_date']?.toString(),
      skills: skills,
    );

    await ref.read(employeeProvider.notifier).createTherapist(request);
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: EmployeeAddDesktop(
        onCancel: _handleCancel,
        onSubmit: _handleSubmit,
      ),
    );
  }
}
