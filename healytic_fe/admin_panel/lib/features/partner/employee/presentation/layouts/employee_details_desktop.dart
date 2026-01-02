import 'package:admin_panel/features/common/widgets/button/back_button.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_profile_section.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/doctor_fields_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_professional_role_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/employee_work_schedule_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/therapist_fields_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_details_documents_card.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeDetailsDesktop extends HookConsumerWidget {
  final EmployeeId employeeId;

  const EmployeeDetailsDesktop({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(employeeDetailsProvider(employeeId));

    return employeeAsync.when(
      data: (employee) => _EmployeeDetailsContent(employee: employee),
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
              onPressed: () => ref.refresh(employeeDetailsProvider(employeeId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeDetailsContent extends StatefulWidget {
  final EmployeeEntity employee;

  const _EmployeeDetailsContent({required this.employee});

  @override
  State<_EmployeeDetailsContent> createState() =>
      _EmployeeDetailsContentState();
}

class _EmployeeDetailsContentState extends State<_EmployeeDetailsContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  late EmployeeRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = _getRoleFromEntity(widget.employee);
  }

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

  Map<String, dynamic> _getInitialValues() {
    final nameParts = widget.employee.fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return {
      'first_name': firstName,
      'last_name': lastName,
      'email_address': widget.employee.email,
      'phone_number': widget.employee.phone,
      'avatar_url': widget.employee.avatar,
      'employee_role': _selectedRole,
      'license_file': widget.employee.licenseUrl,
      'id_card_file': widget.employee.idCardUrl,
      'additional_documents': widget.employee.documents,
    };
  }

  Future<void> _handleSubmit(WidgetRef ref) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;

      try {
        final firstName = values['first_name']?.toString().trim() ?? '';
        final lastName = values['last_name']?.toString().trim() ?? '';
        final fullName = '$firstName $lastName'.trim();

        final request = UpdateEmployeeRequest(
          id: widget.employee.id,
          fullName: fullName.isNotEmpty ? fullName : widget.employee.fullName,
          displayName: fullName.isNotEmpty
              ? fullName
              : widget.employee.displayName,
          avatar: values['avatar_url']?.toString() ?? widget.employee.avatar,
          role:
              (values['employee_role'] as EmployeeRole?)?.apiValue ??
              widget.employee.role,
          position:
              values['medical_title']?.toString() ?? widget.employee.position,
          status: widget.employee.status,
          branch: 'Main Branch', // TODO: Add branch selection
          email: values['email_address']?.toString() ?? widget.employee.email,
          phone: values['phone_number']?.toString() ?? widget.employee.phone,
          address: widget.employee.address,
          city: widget.employee.city,
          state: widget.employee.state,
          country: widget.employee.country,
          licenseUrl: values['license_file'] is String
              ? values['license_file'] as String?
              : widget.employee.licenseUrl,
          idCardUrl: values['id_card_file'] is String
              ? values['id_card_file'] as String?
              : widget.employee.idCardUrl,
          documents: values['additional_documents'] is List<String>
              ? values['additional_documents'] as List<String>
              : widget.employee.documents,
        );

        await ref.read(employeeProvider.notifier).updateEmployee(request);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee updated successfully')),
          );
          // Refresh details
          ref.refresh(employeeDetailsProvider(widget.employee.id));
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
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Use Consumer to access ref inside stateful widget's build if needed,
    // or just use HookConsumerWidget mixin.
    // _EmployeeDetailsContent is just StatefulWidget, so we need to pass ref or convert it.
    // _EmployeeDetailsContent is child of HookConsumerWidget, but here it is separate.
    return Consumer(
      builder: (context, ref, child) {
        return FormBuilder(
          key: _formKey,
          initialValue: _getInitialValues(),
          child: Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  top: 100, // Height for the floating header
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Profile Image & Contact Info
                        const SizedBox(
                          width: 340,
                          child: EmployeeFormProfileSection(),
                        ),
                        AppDimens.horizontalLarge,
                        // Right Column - Role, Skills, Schedule
                        Expanded(
                          child: _RightColumn(
                            selectedRole: _selectedRole,
                            onRoleChanged: _handleRoleChanged,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Floating header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AppBackButton(
                            onTap: () {
                              context.goNamed(EmployeeHomeRoute.name);
                            },
                          ),
                          AppDimens.horizontalMedium,
                          Text(
                            'Edit ${_selectedRole.displayName}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AppButton(
                            buttonType: ButtonType.outline,
                            onPressed: () {
                              context.goNamed(EmployeeHomeRoute.name);
                            },
                            child: const Text('Cancel'),
                          ),
                          AppDimens.horizontalSmall,
                          AppButton(
                            buttonType: ButtonType.elevated,
                            onPressed: () => _handleSubmit(ref),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.save,
                                  size: 18,
                                  color: colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text('Save Changes'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RightColumn extends StatelessWidget {
  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleChanged;

  const _RightColumn({required this.selectedRole, required this.onRoleChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeProfessionalRoleCard(
          // key: ValueKey(selectedRole), // Removed to prevent recreation
          initialRole: selectedRole,
          onRoleChanged: onRoleChanged,
        ),
        AppDimens.verticalMedium,
        // Conditionally show role-specific fields
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: selectedRole == EmployeeRole.therapist
              ? const TherapistFieldsCard(key: ValueKey('therapist'))
              : const DoctorFieldsCard(key: ValueKey('doctor')),
        ),
        AppDimens.verticalMedium,
        const EmployeeDetailsDocumentsCard(),
        AppDimens.verticalMedium,
        const EmployeeWorkScheduleCard(),
      ],
    );
  }
}
