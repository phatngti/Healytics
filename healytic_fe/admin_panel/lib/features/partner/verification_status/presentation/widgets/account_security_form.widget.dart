import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Account Security verification.
///
/// Displays a read-only view of account security status since
/// password changes are typically handled through a separate flow.
class AccountSecurityForm extends StatelessWidget {
  /// Creates a new [AccountSecurityForm].
  const AccountSecurityForm({
    this.isVerified = true,
    this.lastPasswordChange,
    this.onChangePassword,
    super.key,
  });

  /// Whether the account security is verified.
  final bool isVerified;

  /// Date of the last password change.
  final DateTime? lastPasswordChange;

  /// Callback when user requests to change password.
  final VoidCallback? onChangePassword;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Security status card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isVerified
                ? successColor.withValues(alpha: 0.05)
                : colorScheme.errorContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isVerified
                  ? successColor.withValues(alpha: 0.2)
                  : colorScheme.error.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isVerified
                      ? successColor.withValues(alpha: 0.1)
                      : colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isVerified ? Icons.verified_user : Icons.shield_outlined,
                  color: isVerified ? successColor : colorScheme.error,
                  size: 24,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVerified
                          ? 'Account Security Verified'
                          : 'Security Update Required',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isVerified
                          ? 'Your account meets all security requirements'
                          : 'Please update your security settings',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isVerified)
                Icon(Icons.check_circle, color: successColor, size: 24),
            ],
          ),
        ),
        AppDimens.verticalLarge,

        // Password section
        Text(
          'PASSWORD',
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppDimens.verticalSmall,

        // Password status row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              AppDimens.horizontalSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '••••••••••••',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        letterSpacing: 2,
                      ),
                    ),
                    if (lastPasswordChange != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Last changed: ${_formatDate(lastPasswordChange!)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onChangePassword != null)
                TextButton(
                  onPressed: onChangePassword,
                  child: const Text('Change'),
                ),
            ],
          ),
        ),
        AppDimens.verticalLarge,

        // Security checklist
        Text(
          'SECURITY CHECKLIST',
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppDimens.verticalSmall,

        _SecurityCheckItem(
          label: 'Strong password (8+ characters)',
          isChecked: true,
        ),
        _SecurityCheckItem(
          label: 'Contains uppercase letter',
          isChecked: true,
        ),
        _SecurityCheckItem(
          label: 'Contains number',
          isChecked: true,
        ),
        _SecurityCheckItem(
          label: 'Email verified',
          isChecked: isVerified,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Security checklist item widget.
class _SecurityCheckItem extends StatelessWidget {
  const _SecurityCheckItem({
    required this.label,
    required this.isChecked,
  });

  final String label;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isChecked ? successColor : colorScheme.outline,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isChecked
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
