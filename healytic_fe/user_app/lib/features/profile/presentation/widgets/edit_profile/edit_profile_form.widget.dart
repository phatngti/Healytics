import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField(
          context,
          label: 'FULL NAME',
          icon: Icons.person_outline,
          controller: nameController,
          hintText: 'Enter your full name',
        ),
        const SizedBox(height: 24),
        _buildField(
          context,
          label: 'EMAIL ADDRESS',
          icon: Icons.mail_outline,
          controller: emailController,
          hintText: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
        ),
        const SizedBox(height: 24),
        _buildField(
          context,
          label: 'PHONE NUMBER',
          icon: Icons.call_outlined,
          controller: phoneController,
          hintText: '+1 (000) 000-0000',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        _buildField(
          context,
          label: 'LOCATION',
          icon: Icons.location_on_outlined,
          controller: locationController,
          hintText: 'City, State',
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                icon,
                color: colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
