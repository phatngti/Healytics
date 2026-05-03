import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/employee/presentation/layouts/employee_home_desktop.dart';
import 'package:flutter/material.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: EmployeeHomeDesktop(),
    );
  }
}
