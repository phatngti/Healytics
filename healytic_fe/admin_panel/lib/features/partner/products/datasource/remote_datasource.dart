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
          basePrice: 100,
          description: 'Description 1',
          category: 'Category 1',
        ),
        Product(
          id: ProductId(2),
          name: 'Product 2',
          basePrice: 200,
          description: 'Description 2',
          category: 'Category 2',
        ),
        Product(
          id: ProductId(3),
          name: 'Product 3',
          basePrice: 300,
          description: 'Description 3',
          category: 'Category 3',
        ),
        Product(
          id: ProductId(4),
          name: 'Product 4',
          basePrice: 400,
          description: 'Description 4',
          category: 'Category 4',
        ),
        Product(
          id: ProductId(5),
          name: 'Product 5',
          basePrice: 500,
          description: 'Description 5',
          category: 'Category 5',
        ),
        Product(
          id: ProductId(6),
          name: 'Product 6',
          basePrice: 600,
          description: 'Description 6',
          category: 'Category 6',
        ),
        Product(
          id: ProductId(7),
          name: 'Product 7',
          basePrice: 700,
          description: 'Description 7',
          category: 'Category 7',
        ),
        Product(
          id: ProductId(8),
          name: 'Product 8',
          basePrice: 800,
          description: 'Description 8',
          category: 'Category 8',
        ),
        Product(
          id: ProductId(9),
          name: 'Product 9',
          basePrice: 900,
          description: 'Description 9',
          category: 'Category 9',
        ),
        Product(
          id: ProductId(10),
          name: 'Product 10',
          basePrice: 1000,
          description: 'Description 10',
          category: 'Category 10',
        ),
        Product(
          id: ProductId(11),
          name: 'Product 11',
          basePrice: 1100,
          description: 'Description 11',
          category: 'Category 11',
        ),
        Product(
          id: ProductId(12),
          name: 'Product 12',
          basePrice: 1200,
          description: 'Description 12',
          category: 'Category 12',
        ),
        Product(
          id: ProductId(13),
          name: 'Product 13',
          basePrice: 1300,
          description: 'Description 13',
          category: 'Category 13',
        ),
        Product(
          id: ProductId(14),
          name: 'Product 14',
          basePrice: 1400,
          description: 'Description 14',
          category: 'Category 14',
        ),
        Product(
          id: ProductId(15),
          name: 'Product 15',
          basePrice: 1500,
          description: 'Description 15',
          category: 'Category 15',
        ),
        Product(
          id: ProductId(16),
          name: 'Product 16',
          basePrice: 1600,
          description: 'Description 16',
          category: 'Category 16',
        ),
        Product(
          id: ProductId(17),
          name: 'Product 17',
          basePrice: 1700,
          description: 'Description 17',
          category: 'Category 17',
        ),
        Product(
          id: ProductId(18),
          name: 'Product 18',
          basePrice: 1800,
          description: 'Description 18',
          category: 'Category 18',
        ),
        Product(
          id: ProductId(19),
          name: 'Product 19',
          basePrice: 1900,
          description: 'Description 19',
          category: 'Category 19',
        ),
        Product(
          id: ProductId(20),
          name: 'Product 20',
          basePrice: 2000,
          description: 'Description 20',
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
        basePrice: 100.0 * id.value,
        description: 'Description ${id.value}',
        category: 'Category ${id.value}',
      ),
    );
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) {
    // print request
    print(request);
    // TODO: Implement actual API call
    return Future.delayed(
      const Duration(seconds: 1),
      () => Product(
        id: ProductId(DateTime.now().millisecondsSinceEpoch),
        name: request.name,
        basePrice: request.basePrice,
        salePrice: request.salePrice,
        costPerItem: request.costPerItem,
        sku: request.sku,
        barcode: request.barcode,
        stockQuantity: request.stockQuantity,
        status: request.status,
        onlineStore: request.onlineStore,
        description: request.description,
        productType: request.productType,
        category: request.category,
        tags: request.tags,
        vendor: request.vendor,
        duration: request.duration,
        buffer: request.buffer,
        capacity: request.capacity,
        leadTime: request.leadTime,
        staffAllocation: request.staffAllocation,
        staffIds: request.staffIds,
        images: request.images,
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
