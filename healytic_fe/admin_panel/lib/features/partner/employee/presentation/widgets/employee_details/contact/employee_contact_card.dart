import 'package:flutter/material.dart';

import 'employee_contact_item.dart';

class EmployeeContactCard extends StatelessWidget {
  final String email;
  final String phone;

  const EmployeeContactCard({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.green.shade700,
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
                ),
                const SizedBox(height: 20),
                EmployeeContactItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: phone.isNotEmpty ? phone : 'Not provided',
                  isLink: phone.isNotEmpty,
                ),
                Divider(height: 32, color: colorScheme.outlineVariant),
                EmployeeContactItem(
                  icon: Icons.emergency_outlined,
                  iconColor: Colors.red,
                  iconBgColor: Colors.red.shade50,
                  label: 'Emergency Contact',
                  value: 'Not available',
                  subtitle: 'No emergency contact on file',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
