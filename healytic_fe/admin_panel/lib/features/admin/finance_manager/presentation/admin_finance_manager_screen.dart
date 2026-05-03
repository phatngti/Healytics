import 'package:admin_panel/features/admin/finance_manager/presentation/layouts/admin_finance_manager_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

/// Entry point screen for the Admin Finance Manager.
class AdminFinanceManagerScreen extends StatelessWidget {
  const AdminFinanceManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: AdminFinanceManagerDesktop(),
      tablet: AdminFinanceManagerDesktop(),
      mobile: AdminFinanceManagerDesktop(),
    );
  }
}
