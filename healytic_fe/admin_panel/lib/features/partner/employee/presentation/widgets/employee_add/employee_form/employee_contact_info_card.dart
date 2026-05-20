import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeContactInfoCard extends StatelessWidget {
  final bool enabled;

  const EmployeeContactInfoCard({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
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
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // First Name & Last Name Row
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: EmployeeFormField.firstName.key,
                  label: 'First Name',
                  hintText: 'e.g. Sarah',
                  isRequired: true,
                  enabled: enabled,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: EmployeeFormField.lastName.key,
                  label: 'Last Name',
                  hintText: 'e.g. Jenkins',
                  isRequired: true,
                  enabled: enabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Email
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: EmployeeFormField.emailAddress.key,
            label: 'Email Address',
            hintText: 'sarah.j@spa.com',
            isRequired: true,
            prefixIcon: Icons.mail_outline,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          // Phone
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: EmployeeFormField.phoneNumber.key,
            label: 'Phone Number',
            hintText: '+1 (555) 000-0000',
            isRequired: true,
            prefixIcon: Icons.phone_outlined,
            enabled: enabled,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          // Date of Birth & Gender Row
          Row(
            children: [
              Expanded(
                child: FormFieldBuilders.buildDateField(
                  context,
                  label: 'Date of Birth',
                  fieldKey: EmployeeFormField.dateOfBirth.key,
                  hintText: 'MM/DD/YYYY',
                  isRequired: true,
                  enabled: enabled,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: FormFieldBuilders.buildDropdownField(
                  context,
                  label: 'Gender',
                  fieldKey: EmployeeFormField.gender.key,
                  items: EmployeeGender.values
                      .map((e) => e.displayName)
                      .toList(),
                  isRequired: true,
                  enabled: enabled,
                ),
              ),
            ],
          ),
          AppDimens.verticalLarge,
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
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                AppDimens.verticalMediumSmall,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: EmployeeFormField.emergencyContactName.key,
                  label: 'Emergency Name',
                  hintText: 'Contact Name',
                  isRequired: true,
                  enabled: enabled,
                ),
                AppDimens.verticalMediumSmall,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: EmployeeFormField.emergencyContactPhone.key,
                  label: 'Emergency Phone',
                  hintText: 'Contact Phone',
                  isRequired: true,
                  prefixIcon: Icons.phone_in_talk_outlined,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
