import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_details_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_panel/router/partner_routes.dart';

class EmployeeDetailsScreen extends ConsumerWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(
      employeeDetailsProvider(EmployeeId(employeeId)),
    );

    return employeeAsync.when(
      data: (employee) {
        return ResponsiveWrapper(
          useLayout: true,
          desktop: EmployeeDetailsDesktop(
            employee: employee,
            onEdit: () {
              context.goNamed(
                EmployeeEditRoute.name,
                pathParameters: {'id': employeeId},
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            AppDimens.verticalMedium,
            Text(
              'Failed to load employee details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            AppDimens.verticalSmall,
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            AppDimens.verticalMedium,
            ElevatedButton(
              onPressed: () =>
                  ref.refresh(employeeDetailsProvider(EmployeeId(employeeId))),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
