import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/transactions/presentation/layouts/transaction_home_desktop.dart';
import 'package:flutter/material.dart';

class TransactionHomeScreen extends StatelessWidget {
  const TransactionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: TransactionHomeDesktop(),
    );
  }
}
