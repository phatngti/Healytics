import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_analytics/employee_overview_analytics.widget.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/employee_management_table.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeHomeDesktop extends HookConsumerWidget {
  const EmployeeHomeDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EmployeeOverviewAnalyticsSection(),
            AppDimens.verticalLarge,
            Text(
              'Employee Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              'Manage, edit, and delete all employees from this central dashboard',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalSmall,
            EmployeeManagementTable(
              height: MediaQuery.of(context).size.height * 0.75,
            ),
          ],
        ),
      ),
    );
  }
}
