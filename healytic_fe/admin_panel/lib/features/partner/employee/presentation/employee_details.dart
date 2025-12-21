import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_details_desktop.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/employee_details/employee_details.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: const EmployeeDetailsDesktop(),
    );
  }
}
