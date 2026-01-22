import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Account and contact information section
class AccountContactSection extends StatelessWidget {
  const AccountContactSection({
    this.username,
    this.email,
    this.isEmailVerified = false,
    this.phoneNumber,
    super.key,
  });

  final String? username;
  final String? email;
  final bool isEmailVerified;
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(context, colorScheme, textTheme),
          const Divider(height: 1),

          // Content
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfoItem(context, 'Username', username)),
                Expanded(child: _buildEmailItem(context)),
                Expanded(
                  child: _buildInfoItem(context, 'Phone Number', phoneNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(Icons.manage_accounts, color: colorScheme.primary, size: 20),
          AppDimens.horizontalSmall,
          Text(
            'Account & Contact',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String? value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          value ?? 'N/A',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEmailItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EMAIL ADDRESS',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Row(
          children: [
            Flexible(
              child: Text(
                email ?? 'N/A',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isEmailVerified) ...[
              AppDimens.horizontalSmall,
              Icon(
                Icons.verified,
                size: 16,
                color: semantics?.success ?? Colors.green,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
