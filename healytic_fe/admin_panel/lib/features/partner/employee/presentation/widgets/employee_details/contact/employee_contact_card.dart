import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'employee_contact_item.dart';

class EmployeeContactCard extends StatelessWidget {
  final String email;
  final String phone;

  /// Emergency contact person's name.
  final String? emergencyContactName;

  /// Emergency contact person's phone number.
  final String? emergencyContactPhone;

  final bool isEditing;

  const EmployeeContactCard({
    super.key,
    required this.email,
    required this.phone,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    final hasEmergency =
        (emergencyContactName?.isNotEmpty ?? false) ||
        (emergencyContactPhone?.isNotEmpty ?? false);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact & Basic Info',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: semanticColors.success,
                  ),
                  onPressed: () {},
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                EmployeeContactItem(
                  icon: Icons.mail_outline,
                  label: 'Email Address',
                  value: email.isNotEmpty ? email : 'Not provided',
                  isLink: email.isNotEmpty,
                  isEditing: isEditing,
                ),
                const SizedBox(height: 20),
                EmployeeContactItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: phone.isNotEmpty ? phone : 'Not provided',
                  isLink: phone.isNotEmpty,
                  isEditing: isEditing,
                ),
                Divider(height: 32, color: colorScheme.outlineVariant),
                EmployeeContactItem(
                  icon: Icons.emergency_outlined,
                  iconColor: semanticColors.error,
                  iconBgColor: semanticColors.error?.withAlpha(25),
                  label: 'Emergency Contact',
                  value: hasEmergency
                      ? emergencyContactName ?? 'Unknown'
                      : 'Not available',
                  subtitle: hasEmergency
                      ? emergencyContactPhone
                      : 'No emergency contact on file',
                  isEditing: isEditing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
