import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Grid of KPI cards derived from [AdminFinanceOverview].
class AdminFinanceKpiGrid extends StatelessWidget {
  const AdminFinanceKpiGrid({
    super.key,
    required this.overview,
  });

  final AdminFinanceOverview overview;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiData(
        'Gross Volume',
        overview.grossVolume,
        12.3,
        AdminFinanceRiskTone.positive,
      ),
      _KpiData(
        'Net Revenue',
        overview.netRevenue,
        8.7,
        AdminFinanceRiskTone.positive,
      ),
      _KpiData(
        'Platform Fees',
        overview.platformFeeRevenue,
        10.1,
        AdminFinanceRiskTone.positive,
      ),
      _KpiData(
        'Refund Exposure',
        overview.refundExposure,
        -2.4,
        AdminFinanceRiskTone.warning,
      ),
      _KpiData(
        'Failed Payments',
        overview.failedPaymentAmount,
        -15.0,
        AdminFinanceRiskTone.critical,
      ),
      _KpiData(
        'Pending Payouts',
        overview.pendingPayoutAmount,
        5.2,
        AdminFinanceRiskTone.neutral,
      ),
      _KpiData(
        'Held Payouts',
        overview.heldPayoutAmount,
        0,
        AdminFinanceRiskTone.warning,
      ),
      _KpiData(
        'Unreconciled',
        overview.unreconciledAmount,
        -3.1,
        AdminFinanceRiskTone.warning,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 600
                    ? 3
                    : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppDimens.spaceMd,
            crossAxisSpacing: AppDimens.spaceMd,
            childAspectRatio: 2.2,
          ),
          itemCount: cards.length,
          itemBuilder: (context, i) => _KpiCard(
            data: cards[i],
            currency: overview.currency,
          ),
        );
      },
    );
  }
}

class _KpiData {
  const _KpiData(
    this.label,
    this.value,
    this.changePercent,
    this.tone,
  );

  final String label;
  final double value;
  final double changePercent;
  final AdminFinanceRiskTone tone;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.data,
    required this.currency,
  });

  final _KpiData data;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMd,
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllSmMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                AdminFinanceRiskDot(tone: data.tone),
                AppDimens.horizontalXs,
                Flexible(
                  child: Text(
                    data.label,
                    style: tt.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            AppDimens.verticalXs,
            Text(
              formatAdminCurrencyCompact(
                data.value,
                currency,
              ),
              style: tt.titleLarge?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (data.changePercent != 0)
              AdminFinanceChangeBadge(
                changePercent: data.changePercent,
              ),
          ],
        ),
      ),
    );
  }
}
