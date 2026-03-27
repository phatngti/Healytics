import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/layouts/service_tags_home_desktop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ServiceTagsHomeScreen extends HookConsumerWidget {
  const ServiceTagsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: const ServiceTagsHomeDesktop(),
    );
  }
}
