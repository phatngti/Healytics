import 'package:admin_panel/features/admin/partner_manager/presentation/layouts/partner_manager_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PartnerManagerScreen extends HookConsumerWidget {
  const PartnerManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: PartnerManagerDesktop(),
    );
  }
}
