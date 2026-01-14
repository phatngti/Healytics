import 'package:admin_panel/features/partner/products/data/product_impl.repository.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_details.provider.g.dart';

@riverpod
Future<Product> productDetails(Ref ref, String id) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.getProductById(ProductId(id));
}
