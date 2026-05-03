import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard_state.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_content.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class AdminDashboardTablet extends StatelessWidget {
  const AdminDashboardTablet({super.key, required this.state});

  final AdminDashboardState state;

  @override
  Widget build(BuildContext context) {
    return AdminDashboardContent(
      state: state,
      compact: true,
      padding: AppDimens.paddingAllMediumLarge,
    );
  }
}
