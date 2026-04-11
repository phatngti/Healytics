import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_details_desktop.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product_details.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return productAsync.when(
      data: (product) => Scaffold(
        body: ResponsiveWrapper(
          useLayout: true,
          desktop: ProductDetailsDesktop(
            product: product,
            onEdit: () => ProductEditRoute(id: productId).go(context),
            onBack: () => context.goNamed(ProductHomeRoute.name),
          ),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.goNamed(
              ProductHomeRoute.name,
            ),
          ),
        ),
        body: Center(
          child: ErrorCard(
            title: 'Error loading product',
            error: error,
            stackTrace: stack,
            onRetry: () => ref.invalidate(
              productDetailsProvider(productId),
            ),
          ),
        ),
      ),
    );
  }
}
