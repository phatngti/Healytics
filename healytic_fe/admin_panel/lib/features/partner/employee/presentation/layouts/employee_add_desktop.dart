import 'package:common/widgets/button/back_button.dart';

import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/domain/therapist_type.dart';
import 'package:admin_panel/features/partner/employee/presentation/validation/employee_create_form_validation.dart';
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
  /// Only active when UAT autofill is enabled.
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
  EmployeeRoleType _selectedRole = EmployeeRoleType.therapist;
  TherapistType _selectedTherapistType = TherapistType.massage;
  bool _isFormValid = false;

  /// Tracks the current form initial values.
  /// Updated when role changes during autofill.
  late Map<String, dynamic> _formInitialValue;

  @override
  void initState() {
    super.initState();
    _formInitialValue = widget.initialValue;
    _selectedRole = EmployeeCreateFormValidation.roleFromValues(
      _formInitialValue,
    );
    _selectedTherapistType =
        EmployeeCreateFormValidation.therapistTypeFromValues(_formInitialValue);
    _scheduleFormValidityUpdate();
  }

  void _handleSubmit() {
    final state = _formKey.currentState;
    if (state == null) return;

    state.save();
    final values = _currentFieldValues(state);
    final requiredFieldsComplete = EmployeeCreateFormValidation.isComplete(
      values,
      role: _selectedRole,
      therapistType: _selectedTherapistType,
    );
    final formBuilderValid = state.validate();
    final canSubmit = requiredFieldsComplete && formBuilderValid;

    if (!canSubmit) {
      _setFormValidity(false);
      return;
    }

    widget.onSubmit?.call(state.value);
  }

  void _handleRoleChanged(EmployeeRoleType role) {
    setState(() {
      _selectedRole = role;
      // Reset therapist type to default
      // when switching roles.
      _selectedTherapistType = TherapistType.massage;

      // Rebuild FormBuilder with role-specific
      // autofill data in UAT.
      if (widget.shouldAutofill) {
        final values = widget.onBuildAutofillValues?.call(role.apiValue);
        if (values != null) {
          _formInitialValue = values;
          _formKey = GlobalKey<FormBuilderState>();
        }
      }
    });
    _scheduleFormValidityUpdate();
  }

  void _handleTherapistTypeChanged(TherapistType type) {
    setState(() {
      _selectedTherapistType = type;

      if (widget.shouldAutofill) {
        final values = widget.onBuildAutofillValues?.call(
          _selectedRole.apiValue,
          type.apiValue,
        );
        if (values != null) {
          _formInitialValue = values;
          _formKey = GlobalKey<FormBuilderState>();
        }
      }
    });
    _scheduleFormValidityUpdate();
  }

  void _scheduleFormValidityUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    final state = _formKey.currentState;
    if (state == null) return;
    final values = _currentFieldValues(state);
    final isValid = EmployeeCreateFormValidation.isComplete(
      values,
      role: _selectedRole,
      therapistType: _selectedTherapistType,
    );
    _setFormValidity(isValid);
  }

  Map<String, dynamic> _currentFieldValues(FormBuilderState state) {
    return {
      for (final entry in state.fields.entries) entry.key: entry.value.value,
    };
  }

  void _setFormValidity(bool isValid) {
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilder(
      key: _formKey,
      initialValue: _formInitialValue,
      onChanged: () {
        _scheduleFormValidityUpdate();
      },
      child: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppDimens.paddingAllLarge.left,
              right: AppDimens.paddingAllLarge.right,
              bottom: AppDimens.paddingAllLarge.bottom,
              top: AppDimens.floatingHeaderHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Profile Image & Contact Info
                    const SizedBox(
                      width: AppDimens.profileColumnWidth,
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
              padding: AppDimens.paddingHorizontalLarge.add(
                AppDimens.paddingVerticalMedium,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(8),
                    blurRadius: AppDimens.shadowBlurSm,
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
                    isFormValid: _isFormValid,
                    onCancel: widget.onCancel,
                    onSubmit: _handleSubmit,
                    submitLabel: 'Create ${_selectedRole.displayName}',
                    submitIcon: Icon(
                      Icons.person_add_outlined,
                      size: AppDimens.iconSmMd,
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
