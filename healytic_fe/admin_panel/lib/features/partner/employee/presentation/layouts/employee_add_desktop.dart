import 'package:common/widgets/button/back_button.dart';

import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_add_form_section.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_actions.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form_profile_section.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

/// Callback that returns autofill values
/// for the given role and optional therapist type.
typedef AutofillBuilder =
    Map<String, dynamic> Function(String role, [String? therapistType]);

class EmployeeAddDesktop extends StatefulWidget {
  final VoidCallback? onCancel;
  final ValueChanged<Map<String, dynamic>>? onSubmit;
  final Map<String, dynamic> initialValue;

  /// Whether to re-fill form fields on role change.
  /// Only active in debug/staging builds.
  final bool shouldAutofill;

  /// Builds role-specific autofill values.
  /// Required when [shouldAutofill] is `true`.
  final AutofillBuilder? onBuildAutofillValues;

  const EmployeeAddDesktop({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.initialValue = const {},
    this.shouldAutofill = false,
    this.onBuildAutofillValues,
  });

  @override
  State<EmployeeAddDesktop> createState() => _EmployeeAddDesktopState();
}

class _EmployeeAddDesktopState extends State<EmployeeAddDesktop> {
  var _formKey = GlobalKey<FormBuilderState>();
  EmployeeRole _selectedRole = EmployeeRole.therapist;
  TherapistType _selectedTherapistType = TherapistType.massage;

  /// Tracks the current form initial values.
  /// Updated when role changes during autofill.
  late Map<String, dynamic> _formInitialValue;

  @override
  void initState() {
    super.initState();
    _formInitialValue = widget.initialValue;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onSubmit?.call(_formKey.currentState!.value);
    }
  }

  void _handleRoleChanged(EmployeeRole role) {
    setState(() {
      _selectedRole = role;
      // Reset therapist type to default
      // when switching roles.
      _selectedTherapistType = TherapistType.massage;

      // Rebuild FormBuilder with role-specific
      // autofill data in debug / staging builds.
      if (widget.shouldAutofill) {
        final values = widget.onBuildAutofillValues?.call(role.apiValue);
        if (values != null) {
          _formInitialValue = values;
          _formKey = GlobalKey<FormBuilderState>();
        }
      }
    });
  }

  void _handleTherapistTypeChanged(TherapistType type) {
    _selectedTherapistType = type;
    if (!widget.shouldAutofill) return;

    setState(() {
      final values = widget.onBuildAutofillValues?.call(
        _selectedRole.apiValue,
        type.apiValue,
      );
      if (values != null) {
        _formInitialValue = values;
        _formKey = GlobalKey<FormBuilderState>();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilder(
      key: _formKey,
      initialValue: _formInitialValue,
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
                        selectedTherapistType: _selectedTherapistType,
                        onRoleChanged: _handleRoleChanged,
                        onTherapistTypeChanged: _handleTherapistTypeChanged,
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
                    color: colorScheme.shadow.withAlpha(8),
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
