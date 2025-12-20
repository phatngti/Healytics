import 'dart:math';

import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeProfessionalRoleCard extends StatefulWidget {
  const EmployeeProfessionalRoleCard({super.key});

  @override
  State<EmployeeProfessionalRoleCard> createState() =>
      _EmployeeProfessionalRoleCardState();
}

class _EmployeeProfessionalRoleCardState
    extends State<EmployeeProfessionalRoleCard> {
  late final TextEditingController _employeeIdController;
  late final TextEditingController _startDateController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _employmentTypeController;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController(text: 'EMP-2051');
    _startDateController = TextEditingController();
    _jobTitleController = TextEditingController();
    _employmentTypeController = TextEditingController();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _startDateController.dispose();
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
              Expanded(child: _buildEmployeeIdField(context)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  context,
                  label: 'Employment Type',
                  items: ['Full-Time', 'Part-Time', 'Contractor', 'Seasonal'],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(child: _buildDateField(context, label: 'Start Date')),
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

  Widget _buildEmployeeIdField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Define the label color matching HTML #618961
    const labelColor = Color(0xFF618961);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            'EMPLOYEE ID',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextFormField(
          controller: _employeeIdController,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: AppButton(
                onPressed: () {
                  final random = Random();
                  final id = 1000 + random.nextInt(9000);
                  setState(() {
                    _employeeIdController.text = 'EMPL-$id';
                  });
                },
                buttonType: ButtonType.text,
                customStyle: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withAlpha(50),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: const Text(
                  'Auto-Generate',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required List<String> items,
  }) {
    // Define the label color matching HTML #618961
    const labelColor = Color(0xFF618961);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: items.first,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, {required String label}) {
    final fieldKey = label.toLowerCase().replaceAll(' ', '_');
    // Define the label color matching HTML #618961
    const labelColor = Color(0xFF618961);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextFormField(
          controller: _startDateController,
          readOnly: true,
          onTap: () async {
            final now = DateTime.now();
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: now,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              final formattedDate =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              _startDateController.text = formattedDate;

              // Sync with FormBuilder state
              final form = FormBuilder.of(context);
              if (form != null) {
                form.fields[fieldKey]?.didChange(formattedDate);
              }
            }
          },
          decoration: InputDecoration(
            hintText: 'Select $label',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
