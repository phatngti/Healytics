import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_stats.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager.provider.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dashboard statistics cards for partner verification.
/// Fetches real data from [partnerVerificationStatsProvider].
class PartnerStatsCards extends HookConsumerWidget {
  const PartnerStatsCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(
      partnerVerificationStatsProvider,
    );

    return switch (asyncStats) {
      AsyncData(:final value) =>
        _StatsGrid(stats: value),
      AsyncError() => _StatsGrid(
          stats: const PartnerVerificationStats(),
          hasError: true,
          onRetry: () => ref.invalidate(
            partnerVerificationStatsProvider,
          ),
        ),
      _ => const _LoadingCards(),
    };
  }
}

/// Grid of 4 statistic cards.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.stats,
    this.hasError = false,
    this.onRetry,
  });

  final PartnerVerificationStats stats;
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _StatCard(
              icon: Icons.pending_actions,
              label: 'Pending Review',
              value: stats.pendingReview.toString(),
              iconColor: _getWarningColor(context),
              iconBackgroundColor: _getWarningColor(
                context,
              ).withValues(alpha: 0.1),
            ),
            _HighPriorityCard(
              value: stats.highPriority.toString(),
            ),
            _StatCard(
              icon: Icons.check_circle,
              label: 'Active Today',
              value: stats.activeToday.toString(),
              iconColor: _getSuccessColor(context),
              iconBackgroundColor: _getSuccessColor(
                context,
              ).withValues(alpha: 0.1),
            ),
            _StatCard(
              icon: Icons.history,
              label: 'Avg. Wait Time',
              value: stats.avgWaitTime,
              iconColor: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
              iconBackgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
            ),
          ],
        );
      },
    );
  }

  Color _getWarningColor(BuildContext context) {
    return Theme.of(context)
            .extension<SemanticColors>()
            ?.warning ??
        Colors.orange;
  }

  Color _getSuccessColor(BuildContext context) {
    return Theme.of(context)
            .extension<SemanticColors>()
            ?.success ??
        Colors.green;
  }
}

/// Loading shimmer placeholder for stat cards.
class _LoadingCards extends StatelessWidget {
  const _LoadingCards();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: List.generate(4, (_) {
            return Container(
              padding: AppDimens.paddingAllMedium,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius:
                    AppDimens.radiusMediumSmall,
                border: Border.all(
                  color: colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Standard statistic card.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outline
              .withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: AppDimens.radiusSmall,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          AppDimens.horizontalMedium,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              AppDimens.verticalExtraSmall,
              Text(
                value,
                style:
                    textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// High priority card with special styling.
class _HighPriorityCard extends StatelessWidget {
  const _HighPriorityCard({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dangerColor = Theme.of(context)
            .extension<SemanticColors>()
            ?.error ??
        Colors.red;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: dangerColor.withValues(alpha: 0.05),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: dangerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.priority_high,
              size: 64,
              color: dangerColor.withValues(
                alpha: 0.1,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: dangerColor.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: AppDimens.radiusSmall,
                ),
                child: Icon(
                  Icons.flag,
                  color: dangerColor,
                  size: 24,
                ),
              ),
              AppDimens.horizontalMedium,
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'HIGH PRIORITY',
                    style:
                        textTheme.labelSmall?.copyWith(
                      color: dangerColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    value,
                    style: textTheme.headlineSmall
                        ?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
