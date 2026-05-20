import 'package:admin_panel/features/partner/employee/domain/employee_gender.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeContactInfoCard extends StatefulWidget {
  final bool enabled;
  final bool showPasswordField;
  final bool passwordRequired;
  final String passwordLabel;
  final String passwordHintText;

  const EmployeeContactInfoCard({
    super.key,
    this.enabled = true,
    this.showPasswordField = false,
    this.passwordRequired = false,
    this.passwordLabel = 'Password',
    this.passwordHintText = 'At least 8 characters',
  });

  @override
  State<EmployeeContactInfoCard> createState() =>
      _EmployeeContactInfoCardState();
}

class _EmployeeContactInfoCardState extends State<EmployeeContactInfoCard> {
  bool _showPassword = false;

  String? _validatePassword(dynamic value) {
    final password = value?.toString() ?? '';
    if (password.isEmpty) {
      return widget.passwordRequired ? 'Password is required' : null;
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

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
                  enabled: widget.enabled,
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
                  enabled: widget.enabled,
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
            enabled: widget.enabled,
            keyboardType: TextInputType.emailAddress,
          ),
          if (widget.showPasswordField) ...[
            const SizedBox(height: 20),
            FormFieldBuilders.buildTextField(
              context,
              fieldKey: EmployeeFormField.password.key,
              label: widget.passwordLabel,
              hintText: widget.passwordHintText,
              isRequired: widget.passwordRequired,
              prefixIcon: Icons.lock_outline,
              enabled: widget.enabled,
              obscureText: !_showPassword,
              validator: _validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: AppDimens.iconSmMd,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: widget.enabled
                    ? () {
                        setState(() => _showPassword = !_showPassword);
                      }
                    : null,
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Phone
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: EmployeeFormField.phoneNumber.key,
            label: 'Phone Number',
            hintText: '+1 (555) 000-0000',
            isRequired: true,
            prefixIcon: Icons.phone_outlined,
            enabled: widget.enabled,
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
                  enabled: widget.enabled,
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
                  enabled: widget.enabled,
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
                  enabled: widget.enabled,
                ),
                AppDimens.verticalMediumSmall,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: EmployeeFormField.emergencyContactPhone.key,
                  label: 'Emergency Phone',
                  hintText: 'Contact Phone',
                  isRequired: true,
                  prefixIcon: Icons.phone_in_talk_outlined,
                  enabled: widget.enabled,
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
