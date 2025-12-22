import 'package:admin_panel/features/common/widgets/input/date_pick_field.dart';
import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EmployeeProfessionalRoleCard extends StatefulWidget {
  const EmployeeProfessionalRoleCard({super.key});

  @override
  State<EmployeeProfessionalRoleCard> createState() =>
      _EmployeeProfessionalRoleCardState();
}

class _EmployeeProfessionalRoleCardState
    extends State<EmployeeProfessionalRoleCard> {
  late final TextEditingController _employeeIdController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _employmentTypeController;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController(text: 'EMP-2051');
    _jobTitleController = TextEditingController();
    _employmentTypeController = TextEditingController();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _jobTitleController.dispose();
    _employmentTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
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
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
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
            firstChild: _buildContent(context),
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

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  label: 'Job Title',
                  placeholder: 'e.g. Senior Massage Therapist',
                  isRequired: true,
                  controller: _jobTitleController,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: FormFieldBuilders.buildAutoGenerateTextField(
                  context,
                  label: 'Employee ID',
                  controller: _employeeIdController,
                  onGenerate: () {
                    setState(() {
                      _employeeIdController.text = const Uuid().v4();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildDropdownField(
                  context,
                  label: 'Employment Type',
                  items: ['Full-Time', 'Part-Time', 'Contractor', 'Seasonal'],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: AppDatePickField(
                  fieldKey: 'start_date',
                  label: 'Start Date',
                  hintText: 'Select Start Date',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String placeholder,
    bool isRequired = false,
    TextEditingController? controller,
  }) {
    final fieldKey = label.toLowerCase().replaceAll(' ', '_');
    return AppTextField(
      fieldKey: fieldKey,
      label: label,
      hintText: placeholder,
      isRequired: isRequired,
      controller: controller,
    );
  }
}
