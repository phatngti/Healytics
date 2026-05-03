import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Header row for the Finance Manager screen.
///
/// Shows title, subtitle, and action buttons for
/// refresh and export.
class AdminFinanceHeader extends ConsumerWidget {
  const AdminFinanceHeader({
    super.key,
    this.onExport,
  });

  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Finance Manager',
                style: tt.headlineSmall?.copyWith(
                  fontWeight: AppDimens.fontWeightBold,
                ),
              ),
              AppDimens.verticalXs,
              Text(
                'Monitor platform revenue, payouts, '
                'refunds, and reconciliation.',
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AppDimens.horizontalSmall,
        IconButton.filledTonal(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            ref
                .read(
                  adminFinanceWorkspaceProvider.notifier,
                )
                .bumpReload();
          },
        ),
        AppDimens.horizontalXs,
        FilledButton.icon(
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export'),
          onPressed: onExport,
        ),
      ],
    );
  }
}
