import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';

class EmployeeContactInfoCard extends StatelessWidget {
  const EmployeeContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Text(
              'Contact & Basic Info',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          // First Name & Last Name Row
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  label: 'First Name',
                  placeholder: 'e.g. Sarah',
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  label: 'Last Name',
                  placeholder: 'e.g. Jenkins',
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Email
          FormFieldBuilders.buildTextField(
            context,
            label: 'Email Address',
            placeholder: 'sarah.j@spa.com',
            isRequired: true,
            prefixIcon: Icons.mail_outline,
          ),
          const SizedBox(height: 20),
          // Phone
          FormFieldBuilders.buildTextField(
            context,
            label: 'Phone Number',
            placeholder: '+1 (555) 000-0000',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 20),
          // Date of Birth & Gender Row
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildDateField(
                  context,
                  label: 'Date of Birth',
                  fieldKey: 'date_of_birth',
                  hintText: 'MM/DD/YYYY',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormFieldBuilders.buildDropdownField(
                  context,
                  label: 'Gender',
                  items: [
                    'Select...',
                    'Female',
                    'Male',
                    'Non-binary',
                    'Prefer not to say',
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Emergency Contact Section
          Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EMERGENCY CONTACT',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                FormFieldBuilders.buildTextField(
                  context,
                  label: '',
                  placeholder: 'Contact Name',
                ),
                const SizedBox(height: 12),
                FormFieldBuilders.buildTextField(
                  context,
                  label: '',
                  placeholder: 'Contact Phone',
                  prefixIcon: Icons.phone_in_talk_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
