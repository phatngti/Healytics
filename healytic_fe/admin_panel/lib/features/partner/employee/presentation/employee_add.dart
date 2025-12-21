import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_add_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeAddScreen extends ConsumerStatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  ConsumerState<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends ConsumerState<EmployeeAddScreen> {
  Future<void> _handleSubmit(Map<String, dynamic> values) async {
    try {
      // Map form values to CreateEmployeeRequest
      final request = CreateEmployeeRequest(
        firstName: values['first_name']?.toString().trim() ?? '',
        lastName: values['last_name']?.toString().trim() ?? '',
        email: values['email_address']?.toString().trim() ?? '',
        phone: values['phone_number']?.toString().trim() ?? '',
        dateOfBirth: values['date_of_birth']?.toString() ?? '',
        gender: values['gender']?.toString() ?? '',
        emergencyContactName: values['contact_name']?.toString().trim() ?? '',
        emergencyContactPhone: values['contact_phone']?.toString().trim() ?? '',
        jobTitle: values['job_title']?.toString().trim() ?? '',
        employeeId: values['employee_id']?.toString().trim() ?? '',
        employmentType: values['employment_type']?.toString() ?? 'Full-Time',
        startDate: values['start_date']?.toString() ?? '',
        skills:
            (values['skill_set'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        services:
            (values['performable_services'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        schedule: [], // TODO: Parse schedule from values
        avatar: 'https://i.pravatar.cc/150?u=${values['email_address']}',
        status: 'Active',
        branch: 'Main Branch',
        password: 'password123',
      );

      await ref.read(employeeProvider.notifier).createEmployee(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee created successfully')),
        );
        Navigator.of(context).pop();
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

  void _handleCancel() {
    Navigator.of(context).pop();
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
