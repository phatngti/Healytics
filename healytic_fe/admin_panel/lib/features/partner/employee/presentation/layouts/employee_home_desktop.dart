import 'package:admin_panel/features/common/widgets/card/statistic_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_home/employee_management_table.dart';
import 'package:admin_panel/utils/demensions.dart';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.verticalSmall,
                Text(
                  'Overview of your employees',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.verticalSmall,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StatisticCard(
                        label: 'Total Employees',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Active Employees',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Inactive Employees',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Deleted Employees',
                        value: '100',
                        change: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
