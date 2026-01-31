import 'package:admin_panel/features/admin/partner_manager/presentation/layouts/review_application_desktop.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Screen for reviewing partner verification applications
class ReviewApplicationScreen extends HookConsumerWidget {
  const ReviewApplicationScreen({required this.partnerId, super.key});

  /// The ID of the partner verification to review
  final String partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: ReviewApplicationDesktop(partnerId: partnerId),
    );
  }
}
