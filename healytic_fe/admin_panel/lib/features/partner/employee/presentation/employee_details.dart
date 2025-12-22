import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_details_desktop.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final String employeeId;

  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: EmployeeDetailsDesktop(employeeId: EmployeeId(employeeId)),
    );
  }
}
