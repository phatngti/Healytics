import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_contact_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/contact/employee_notes_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_operational_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/details_infonmation/employee_skills_card.dart';
import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_details/header/employee_header_card.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmployeeDetailsDesktop extends HookConsumerWidget {
  final EmployeeId employeeId;

  const EmployeeDetailsDesktop({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(employeeDetailsProvider(employeeId));

    return employeeAsync.when(
      data: (employee) => _EmployeeDetailsContent(employee: employee),
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
              onPressed: () => ref.refresh(employeeDetailsProvider(employeeId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeDetailsContent extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeDetailsContent({required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            EmployeeHeaderCard(employee: employee),
            AppDimens.verticalLarge,
            // Content Grid
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    SizedBox(
                      width: 340,
                      child: _EmployeeLeftColumn(employee: employee),
                    ),
                    AppDimens.horizontalLarge,
                    // Right Column
                    const Expanded(child: _EmployeeRightColumn()),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeLeftColumn extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeLeftColumn({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeeContactCard(email: employee.email, phone: employee.phone),
        AppDimens.verticalMedium,
        const EmployeeNotesCard(),
      ],
    );
  }
}

class _EmployeeRightColumn extends StatelessWidget {
  const _EmployeeRightColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        EmployeeSkillsCard(),
        AppDimens.verticalMedium,
        EmployeeOperationalCard(),
      ],
    );
  }
}
