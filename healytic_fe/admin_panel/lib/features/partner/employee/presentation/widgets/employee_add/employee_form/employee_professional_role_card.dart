import 'package:admin_panel/features/partner/employee/domain/employment_type.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_role.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/role_toggle_selector.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:uuid/uuid.dart';

class EmployeeProfessionalRoleCard extends StatefulWidget {
  final ValueChanged<EmployeeRoleType>? onRoleChanged;
  final EmployeeRoleType initialRole;
  final bool readOnly;
  final bool roleReadOnly;
  final EmployeeEntity? employee;

  const EmployeeProfessionalRoleCard({
    super.key,
    this.onRoleChanged,
    this.initialRole = EmployeeRoleType.therapist,
    this.readOnly = false,
    this.roleReadOnly = false,
    this.employee,
  });

  @override
  State<EmployeeProfessionalRoleCard> createState() =>
      _EmployeeProfessionalRoleCardState();
}

class _EmployeeProfessionalRoleCardState
    extends State<EmployeeProfessionalRoleCard> {
  late final TextEditingController _employeeIdController;

  bool _isExpanded = true;
  late EmployeeRoleType _selectedRole;

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController(
      text:
          widget.employee?.employeeCode ??
          const Uuid().v4().substring(0, 8).toUpperCase(),
    );

    _selectedRole = widget.initialRole;
  }

  @override
  void didUpdateWidget(EmployeeProfessionalRoleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRole != oldWidget.initialRole) {
      if (_selectedRole != widget.initialRole) {
        setState(() {
          _selectedRole = widget.initialRole;
        });
      }
    }
    if (widget.employee?.employeeCode != oldWidget.employee?.employeeCode &&
        widget.employee?.employeeCode != null) {
      _employeeIdController.text = widget.employee!.employeeCode;
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  void _handleRoleChanged(EmployeeRoleType role) {
    setState(() {
      _selectedRole = role;
    });
    widget.onRoleChanged?.call(role);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isReadOnly = widget.readOnly || !formEnabled;
    final isRoleReadOnly = widget.roleReadOnly || isReadOnly;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.info!.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).extension<SemanticColors>()!.info!.withAlpha(50),
                      ),
                    ),
                    child: Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.info,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                  Text(
                    'Professional Role',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          AnimatedCrossFade(
            firstChild: _buildContent(context, isReadOnly, isRoleReadOnly),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isReadOnly,
    bool isRoleReadOnly,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Toggle Selector
          Text(
            'Select Role Type'.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Opacity(
            opacity: isRoleReadOnly ? 0.7 : 1,
            child: IgnorePointer(
              ignoring: isRoleReadOnly,
              child: RoleToggleSelector(
                selectedRole: _selectedRole,
                onRoleChanged: _handleRoleChanged,
              ),
            ),
          ),
          // Hidden field to store role in form
          FormBuilderField<String>(
            name: 'employee_role',
            initialValue: _selectedRole.apiValue,
            builder: (field) {
              // Update field when selection changes
              if (field.value != _selectedRole.apiValue) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  field.didChange(_selectedRole.apiValue);
                });
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          // Common fields
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  label: 'Job Title',
                  placeholder: _selectedRole == EmployeeRoleType.doctor
                      ? 'e.g. Senior Dermatologist'
                      : 'e.g. Senior Massage Therapist',
                  isRequired: true,
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: FormFieldBuilders.buildAutoGenerateTextField(
                  context,
                  label: 'Employee ID',
                  fieldKey: EmployeeFormField.employeeId.key,
                  controller: _employeeIdController,
                  enabled: !isReadOnly,
                  onGenerate: () {
                    // Prevent generation in read only mode
                    if (isReadOnly) return;
                    setState(() {
                      _employeeIdController.text = const Uuid()
                          .v4()
                          .substring(0, 8)
                          .toUpperCase();
                    });
                  },
                  isRequired: true,
                ),
              ),
            ],
          ),
          AppDimens.verticalLarge,
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildDropdownField(
                  context,
                  label: 'Employment Type',
                  items: EmploymentType.values
                      .map((e) => e.displayName)
                      .toList(),
                  initialValue: _initialEmploymentType,
                  isRequired: true,
                ),
              ),
              AppDimens.horizontalLarge,
              Expanded(
                child: FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'start_date',
                  label: 'Start Date',
                  hintText: 'Select Start Date',
                  isRequired: true,
                ),
              ),
            ],
          ),
          AppDimens.verticalLarge,
          // Description (Quill Editor)
          FormFieldBuilders.buildQuillEditor(
            context,
            label: 'Description'.toUpperCase(),
            fieldKey: 'description',
            readOnly: isReadOnly,
            initialValue: widget.employee?.description,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  String get _initialEmploymentType {
    final employmentType = widget.employee?.employmentType;
    if (employmentType == null || employmentType.isEmpty) {
      return EmploymentType.fullTime.displayName;
    }
    return EmploymentType.fromApiValue(employmentType)?.displayName ??
        employmentType;
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String placeholder,
    bool isRequired = false,
    TextEditingController? controller,
  }) {
    final fieldKey = label.toLowerCase().replaceAll(' ', '_');
    return FormFieldBuilders.buildTextField(
      context,
      fieldKey: fieldKey,
      label: label,
      hintText: placeholder,
      isRequired: isRequired,
      controller: controller,
    );
  }
}
