import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';

import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';

abstract class ProductRepository {
  /// Get paginated list of products for table display
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  /// Get total count of products
  Future<int> getTotalRows();

  /// Get a single product by ID
  Future<Product> getProductById(ProductId id);

  /// Create a new product
  Future<Product> createProduct(CreateProductRequest request);

  /// Update an existing product
  Future<void> updateProduct(UpdateProductRequest request);

  /// Delete a product by ID
  Future<void> deleteProduct(ProductId id);

  Future<List<CategoryEntity>> getCategories();
}
