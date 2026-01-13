import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_edit_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:admin_panel/utils/demensions.dart';
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
  late EmployeeRole _selectedRole;
  bool _isEditing = false;
  bool _isInitialized = false;

  EmployeeRole _getRoleFromEntity(EmployeeEntity employee) {
    try {
      return EmployeeRole.values.firstWhere(
        (e) => e.name.toUpperCase() == employee.role.toUpperCase(),
        orElse: () => EmployeeRole.therapist,
      );
    } catch (_) {
      return EmployeeRole.therapist;
    }
  }

  Map<String, dynamic> _getInitialValues(EmployeeEntity employee) {
    final nameParts = employee.fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final baseValues = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email_address': employee.email,
      'phone_number': employee.phone,
      'avatar_url': employee.avatar,
      'employee_role': _selectedRole,
      'license_file': employee.licenseUrl,
      'id_card_file': employee.idCardUrl,
      'additional_documents': employee.documents,
      'date_of_birth': _parseDate(employee.dateOfBirth),
      'gender': _mapGender(employee.gender),
      'employment_type': employee.employmentType,
      'start_date': _parseDate(employee.startDate),
    };

    if (employee is DoctorEntity) {
      baseValues.addAll({
        'medical_title': employee.jobTitle,
        'medical_license': employee.medicalLicense,
        'experience_years': employee.experienceYears?.toString(),
        'consultation_fee': employee.consultationFee?.toString(),
        'specializations': employee.specializations,
        'education': employee.education.firstOrNull,
      });
    } else if (employee is SpaTherapistEntity) {
      baseValues.addAll({
        'therapist_type': TherapistType.spa.apiValue,
        'therapist_level': employee.therapistLevel,
        'commission_rate': employee.commissionRate.toString(),
        'health_check_date': _parseDate(employee.healthCheckDate),
        'spa_skills': employee.skills,
        'device_proficiency': employee.deviceProficiency,
      });
    } else if (employee is MassageTherapistEntity) {
      baseValues.addAll({
        'therapist_type': TherapistType.massage.apiValue,
        'therapist_level': employee.therapistLevel,
        'commission_rate': employee.commissionRate.toString(),
        'health_check_date': _parseDate(employee.healthCheckDate),
        'massage_skills': employee.skills,
        'strength_level': employee.strengthLevel,
      });
    }

    return baseValues;
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  String? _mapGender(String? gender) {
    if (gender == null) return null;
    final lower = gender.toLowerCase();
    if (lower == 'male') return 'Male';
    if (lower == 'female') return 'Female';
    return gender;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form when cancelling edit
        _formKey.currentState?.reset();
      }
    });
  }

  Future<void> _handleSubmit(EmployeeEntity employee) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      try {
        final firstName = values['first_name']?.toString().trim() ?? '';
        final lastName = values['last_name']?.toString().trim() ?? '';
        final fullName = '$firstName $lastName'.trim();

        final request = UpdateEmployeeRequest(
          id: employee.id,
          fullName: fullName.isNotEmpty ? fullName : employee.fullName,
          displayName: fullName.isNotEmpty ? fullName : employee.displayName,
          avatar: values['avatar_url']?.toString() ?? employee.avatar,
          role:
              (values['employee_role'] as EmployeeRole?)?.apiValue ??
              employee.role,
          position: values['medical_title']?.toString() ?? employee.position,
          status: employee.status,
          branch: 'Main Branch', // TODO: Add branch selection
          email: values['email_address']?.toString() ?? employee.email,
          phone: values['phone_number']?.toString() ?? employee.phone,
          address: employee.address,
          city: employee.city,
          state: employee.state,
          country: employee.country,
          licenseUrl: values['license_file'] is String
              ? values['license_file'] as String?
              : employee.licenseUrl,
          idCardUrl: values['id_card_file'] is String
              ? values['id_card_file'] as String?
              : employee.idCardUrl,
          documents: values['additional_documents'] is List<String>
              ? values['additional_documents'] as List<String>
              : employee.documents,
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

  void _handleRoleChanged(EmployeeRole role) {
    if (!_isEditing) return; // Prevent role change in view mode
    setState(() {
      _selectedRole = role;
    });
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
              onToggleEdit: _toggleEdit,
              onSave: () => _handleSubmit(employee),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            AppDimens.verticalMedium,
            Text(
              'Failed to load employee details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppDimens.verticalSmall,
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            AppDimens.verticalMedium,
            ElevatedButton(
              onPressed: () => ref.refresh(
                employeeDetailsProvider(EmployeeId(widget.employeeId)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
