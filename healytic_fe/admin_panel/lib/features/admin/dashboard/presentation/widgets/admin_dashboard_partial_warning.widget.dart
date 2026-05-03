import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_section.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardPartialWarning extends StatelessWidget {
  const AdminDashboardPartialWarning({super.key, required this.failedSections});

  final List<AdminDashboardSection> failedSections;

  @override
  Widget build(BuildContext context) {
    if (failedSections.isEmpty) {
      return const SizedBox.shrink();
    }

    final labels = failedSections.map(_labelOf).join(', ');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.28),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: colorScheme.error),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Text(
              'Some dashboard sections could not be loaded: $labels.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _labelOf(AdminDashboardSection section) {
    return switch (section) {
      AdminDashboardSection.overview => 'overview',
      AdminDashboardSection.revenueTrend => 'revenue trend',
      AdminDashboardSection.bookingOutcomes => 'booking outcomes',
      AdminDashboardSection.transactionHealth => 'transaction health',
      AdminDashboardSection.topPartners => 'top partners',
      AdminDashboardSection.topServices => 'top services',
      AdminDashboardSection.notifications => 'notifications',
      AdminDashboardSection.categoryHealth => 'category health',
    };
  }
}
