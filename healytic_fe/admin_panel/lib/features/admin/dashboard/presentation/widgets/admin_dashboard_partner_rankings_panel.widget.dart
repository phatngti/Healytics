import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_badges.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_formatters.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_panel.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardPartnerRankingsPanel extends StatelessWidget {
  const AdminDashboardPartnerRankingsPanel({super.key, required this.items});

  final List<AdminPartnerRankingItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AdminDashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Revenue Partners',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          AppDimens.verticalMedium,
          if (items.isEmpty)
            const Text('No partner rankings available.')
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spaceMdLg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RankingPill(rank: item.rank),
                    AppDimens.horizontalMediumSmall,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.partnerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AppDimens.verticalExtraSmall,
                          Text(
                            '${formatAdminCurrency(item.grossRevenue)} • ${item.bookingCount} bookings • ${formatAdminPercent(item.successfulBookingRate)} success',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    AppDimens.horizontalMediumSmall,
                    verificationStatusBadge(context, item.verificationStatus),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RankingPill extends StatelessWidget {
  const _RankingPill({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: AppDimens.avatarSm,
      width: AppDimens.avatarSm,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      alignment: Alignment.center,
      child: Text(
        '#$rank',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
