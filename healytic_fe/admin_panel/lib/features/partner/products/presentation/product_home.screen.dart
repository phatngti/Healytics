import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_home_desktop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductHomeScreen extends HookConsumerWidget {
  const ProductHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: const ProductHomeDesktop(),
    );
  }
}
