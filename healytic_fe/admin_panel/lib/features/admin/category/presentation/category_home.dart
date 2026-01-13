import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/admin/category/presentation/layouts/category_home_desktop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryHomeScreen extends HookConsumerWidget {
  const CategoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: const CategoryHomeDesktop(),
    );
  }
}
