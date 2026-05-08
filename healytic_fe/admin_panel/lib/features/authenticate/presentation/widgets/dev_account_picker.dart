import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/features/authenticate/datasource/auth_mock_data.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Dev-only quick-select widget for mock accounts.
///
/// Shows role-appropriate account chips that fill
/// the sign-in form on tap. Only rendered when
/// `mockFlag == true`.
class DevAccountPicker extends StatelessWidget {
  const DevAccountPicker({
    super.key,
    required this.currentRole,
    required this.onAccountSelected,
  });

  /// Current role tab value (`admin` or `health_partner`).
  final String currentRole;

  /// Called when a dev account chip is tapped.
  final void Function(String email, String password)
      onAccountSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(
          alpha: 0.3,
        ),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(
          color: colorScheme.tertiary.withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.developer_mode,
                size: 16,
                color: colorScheme.tertiary,
              ),
              AppDimens.horizontalExtraSmall,
              Text(
                'Dev Quick Login',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppDimens.verticalExtraSmall,
          if (currentRole == Role.admin.value)
            _buildAdminChips(context)
          else
            _buildPartnerChips(context),
        ],
      ),
    );
  }

  Widget _buildAdminChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _DevChip(
          label: '🔑 Admin',
          description: 'Any credentials accepted',
          onTap: () => onAccountSelected(
            DevMockAccounts.adminEmail,
            DevMockAccounts.adminPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: DevMockAccounts.partnerAccounts
          .map(
            (account) => _DevChip(
              label: account.label,
              description: account.description,
              onTap: () => onAccountSelected(
                account.email,
                account.password,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DevChip extends StatelessWidget {
  const _DevChip({
    required this.label,
    required this.description,
    required this.onTap,
  });

  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Tooltip(
      message: description,
      child: ActionChip(
        label: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onTertiaryContainer,
          ),
        ),
        backgroundColor:
            colorScheme.tertiaryContainer.withValues(
          alpha: 0.6,
        ),
        side: BorderSide(
          color: colorScheme.tertiary.withValues(
            alpha: 0.4,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: onTap,
      ),
    );
  }
}
