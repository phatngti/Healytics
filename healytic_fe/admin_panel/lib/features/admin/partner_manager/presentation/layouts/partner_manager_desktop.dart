import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/partner_stats_cards.widget.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/partner_verification_table.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Desktop layout for partner verification management.
class PartnerManagerDesktop extends HookConsumerWidget {
  const PartnerManagerDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final ws = ref.watch(partnerManagerWorkspaceProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Provider Requests',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Review and manage partner '
                        'verification requests. '
                        'Approve or reject '
                        'applications.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimens.horizontalMedium,
                _TabButtons(
                  currentScope: ws.scope,
                  onScopeChanged: (scope) {
                    ref
                        .read(partnerManagerWorkspaceProvider.notifier)
                        .setScope(scope);
                  },
                ),
              ],
            ),
            AppDimens.verticalLarge,

            // Statistics Cards
            const PartnerStatsCards(),
            AppDimens.verticalLarge,

            // Verification Table
            PartnerVerificationTable(
              key: ValueKey(
                'partner-table'
                '-${ws.scope.name}'
                '-${ws.reloadToken}'
                '-${ws.searchQuery}'
                '-${ws.statusFilter}',
              ),
              height: DeviceUtils.getScreenHeight(context),
              state: ws,
              onSearchChanged: (value) {
                ref
                    .read(partnerManagerWorkspaceProvider.notifier)
                    .setSearchQuery(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// State-driven tab buttons for switching between
/// Verification Queue and All Providers.
class _TabButtons extends StatelessWidget {
  const _TabButtons({required this.currentScope, required this.onScopeChanged});

  final PartnerManagerScope currentScope;
  final ValueChanged<PartnerManagerScope> onScopeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTab(
            context: context,
            label: 'Verification Queue',
            scope: PartnerManagerScope.verificationQueue,
            isActive: currentScope == PartnerManagerScope.verificationQueue,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          _buildTab(
            context: context,
            label: 'All Providers',
            scope: PartnerManagerScope.allProviders,
            isActive: currentScope == PartnerManagerScope.allProviders,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String label,
    required PartnerManagerScope scope,
    required bool isActive,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusExtraSmall,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => onScopeChanged(scope),
      borderRadius: AppDimens.radiusExtraSmall,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
