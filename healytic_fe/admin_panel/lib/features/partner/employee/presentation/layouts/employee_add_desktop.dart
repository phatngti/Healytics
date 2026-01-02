import 'package:admin_panel/features/common/widgets/button/back_button.dart';

import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_add_form_section.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_actions.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_profile_section.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class EmployeeAddDesktop extends StatefulWidget {
  final VoidCallback? onCancel;
  final ValueChanged<Map<String, dynamic>>? onSubmit;

  const EmployeeAddDesktop({super.key, this.onCancel, this.onSubmit});

  @override
  State<EmployeeAddDesktop> createState() => _EmployeeAddDesktopState();
}

class _EmployeeAddDesktopState extends State<EmployeeAddDesktop> {
  final _formKey = GlobalKey<FormBuilderState>();
  EmployeeRole _selectedRole = EmployeeRole.therapist;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onSubmit?.call(_formKey.currentState!.value);
    }
  }

  void _handleRoleChanged(EmployeeRole role) {
    // Reset all form fields when switching role
    _formKey.currentState?.reset();
    setState(() {
      _selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilder(
      key: _formKey,
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
                      child: EmployeeAddFormSection(
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        onTap:
                            widget.onCancel ??
                            () {
                              context.goNamed(EmployeeHomeRoute.name);
                            },
                      ),
                      AppDimens.horizontalMedium,
                      Text(
                        'Create ${_selectedRole.displayName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  EmployeeFormActions(
                    onCancel: widget.onCancel,
                    onSubmit: _handleSubmit,
                    submitLabel: 'Create ${_selectedRole.displayName}',
                    submitIcon: Icon(
                      Icons.person_add_outlined,
                      size: 18,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
