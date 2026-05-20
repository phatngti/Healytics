import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_status.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_details_desktop.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_analytics.provider.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee_details.provider.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_panel/router/partner_routes.dart';

class EmployeeDetailsScreen extends ConsumerStatefulWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  ConsumerState<EmployeeDetailsScreen> createState() =>
      _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends ConsumerState<EmployeeDetailsScreen> {
  bool _isDeactivating = false;

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(
      employeeDetailsProvider(EmployeeId(widget.employeeId)),
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
                pathParameters: {'id': widget.employeeId},
              );
            },
            onDeactivate:
                employee.status.toUpperCase() ==
                    EmployeeStatusType.inactive.apiValue
                ? null
                : () => _confirmDeactivate(employee),
            isDeactivating: _isDeactivating,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: ErrorCard(
          title: 'Failed to load employee details',
          error: error,
          stackTrace: stack,
          onRetry: () => ref.refresh(
            employeeDetailsProvider(EmployeeId(widget.employeeId)),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeactivate(EmployeeEntity employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Deactivate employee?'),
          content: Text(
            '${employee.fullName} will no longer be available as an active '
            'employee profile. Existing historical records remain unchanged.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isDeactivating = true);
    try {
      await ref
          .read(employeeProvider.notifier)
          .updateEmployeeStatus(employee.id, EmployeeStatusType.inactive);

      ref.invalidate(employeeDetailsProvider(employee.id));
      ref.invalidate(employeeAssignedServicesProvider(employee.id));
      ref.invalidate(employeeProvider);
      ref.invalidate(employeeOverviewAnalyticsProvider);
      ref.invalidate(employeeDetailAnalyticsProvider(employee.id.value));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${employee.fullName} was deactivated')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deactivate employee: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isDeactivating = false);
      }
    }
  }
}
