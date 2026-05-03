import 'package:admin_panel/features/admin/partner_manager/presentation/layouts/view_partner_detail_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Screen for viewing partner details (read-only)
class ViewPartnerDetailScreen extends HookConsumerWidget {
  const ViewPartnerDetailScreen({required this.partnerId, super.key});

  /// The ID of the partner to view
  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: ViewPartnerDetailDesktop(partnerId: partnerId),
    );
  }
}
