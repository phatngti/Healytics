import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

class PartnerManagerScreen extends StatelessWidget {
  const PartnerManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: Center(child: Text('Partner Manager')),
    );
  }
}
