import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/presentation/product_home/product_home_desktop.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductHomeScreen extends HookConsumerWidget {
  const ProductHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: ProductHomeDesktop(),
    );
  }
}
