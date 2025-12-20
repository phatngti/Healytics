import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_datasource.g.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  );

  Future<int> getTotalRows();

  Future<Product> getProductById(ProductId id);

  Future<Product> createProduct(CreateProductRequest request);

  Future<void> updateProduct(UpdateProductRequest request);

  Future<void> deleteProduct(ProductId id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) {
    // return apiService.productApi.productControllerGetProducts(
    //   startingAt,
    //   count,
    //   sortedBy,
    //   sortedAsc,
    // );

    return Future.delayed(
      const Duration(milliseconds: 500),
      () => [
        Product(
          id: ProductId(1),
          name: 'Product 1',
          price: 100,
          description: 'Description 1',
          image: 'image 1',
          category: 'Category 1',
        ),
        Product(
          id: ProductId(2),
          name: 'Product 2',
          price: 200,
          description: 'Description 2',
          image: 'image 2',
          category: 'Category 2',
        ),
        Product(
          id: ProductId(3),
          name: 'Product 3',
          price: 300,
          description: 'Description 3',
          image: 'image 3',
          category: 'Category 3',
        ),
        Product(
          id: ProductId(4),
          name: 'Product 4',
          price: 400,
          description: 'Description 4',
          image: 'image 4',
          category: 'Category 4',
        ),
        Product(
          id: ProductId(5),
          name: 'Product 5',
          price: 500,
          description: 'Description 5',
          image: 'image 5',
          category: 'Category 5',
        ),
        Product(
          id: ProductId(6),
          name: 'Product 6',
          price: 600,
          description: 'Description 6',
          image: 'image 6',
          category: 'Category 6',
        ),
        Product(
          id: ProductId(7),
          name: 'Product 7',
          price: 700,
          description: 'Description 7',
          image: 'image 7',
          category: 'Category 7',
        ),
        Product(
          id: ProductId(8),
          name: 'Product 8',
          price: 800,
          description: 'Description 8',
          image: 'image 8',
          category: 'Category 8',
        ),
        Product(
          id: ProductId(9),
          name: 'Product 9',
          price: 900,
          description: 'Description 9',
          image: 'image 9',
          category: 'Category 9',
        ),
        Product(
          id: ProductId(10),
          name: 'Product 10',
          price: 1000,
          description: 'Description 10',
          image: 'image 10',
          category: 'Category 10',
        ),
        Product(
          id: ProductId(11),
          name: 'Product 11',
          price: 1100,
          description: 'Description 11',
          image: 'image 11',
          category: 'Category 11',
        ),
        Product(
          id: ProductId(12),
          name: 'Product 12',
          price: 1200,
          description: 'Description 12',
          image: 'image 12',
          category: 'Category 12',
        ),
        Product(
          id: ProductId(13),
          name: 'Product 13',
          price: 1300,
          description: 'Description 13',
          image: 'image 13',
          category: 'Category 13',
        ),
        Product(
          id: ProductId(14),
          name: 'Product 14',
          price: 1400,
          description: 'Description 14',
          image: 'image 14',
          category: 'Category 14',
        ),
        Product(
          id: ProductId(15),
          name: 'Product 15',
          price: 1500,
          description: 'Description 15',
          image: 'image 15',
          category: 'Category 15',
        ),
        Product(
          id: ProductId(16),
          name: 'Product 16',
          price: 1600,
          description: 'Description 16',
          image: 'image 16',
          category: 'Category 16',
        ),
        Product(
          id: ProductId(17),
          name: 'Product 17',
          price: 1700,
          description: 'Description 17',
          image: 'image 17',
          category: 'Category 17',
        ),
        Product(
          id: ProductId(18),
          name: 'Product 18',
          price: 1800,
          description: 'Description 18',
          image: 'image 18',
          category: 'Category 18',
        ),
        Product(
          id: ProductId(19),
          name: 'Product 19',
          price: 1900,
          description: 'Description 19',
          image: 'image 19',
          category: 'Category 19',
        ),
        Product(
          id: ProductId(20),
          name: 'Product 20',
          price: 2000,
          description: 'Description 20',
          image: 'image 20',
          category: 'Category 20',
        ),
      ].asMap().values.toList().sublist(startingAt, startingAt + count),
    );
  }

  @override
  Future<int> getTotalRows() {
    return Future.delayed(const Duration(seconds: 2), () => 20);
  }

  @override
  Future<Product> getProductById(ProductId id) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => Product(
        id: id,
        name: 'Product ${id.value}',
        price: 100.0 * id.value,
        description: 'Description ${id.value}',
        image: 'image ${id.value}',
        category: 'Category ${id.value}',
      ),
    );
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) {
    // TODO: Implement actual API call
    return Future.delayed(
      const Duration(seconds: 1),
      () => Product(
        id: ProductId(DateTime.now().millisecondsSinceEpoch),
        name: request.name,
        price: request.price,
        description: request.description,
        image: request.image,
        category: request.category,
      ),
    );
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) {
    // TODO: Implement actual API call
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> deleteProduct(ProductId id) {
    // TODO: Implement actual API call
    return Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProductRemoteDataSourceImpl(apiService: apiService);
}
