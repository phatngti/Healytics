import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';

import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_openapi/api.dart';

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

  Future<List<CategoryEntity>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  ProductsApi get _productsApi => apiService.productsApi;
  CategoriesApi get _categoriesApi => apiService.categoriesApi;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await _categoriesApi.categoriesControllerFindAll();

    if (response == null) {
      return [];
    }

    return response.map((e) {
      final map = e as Map<String, dynamic>;
      return CategoryEntity.fromJson(map);
    }).toList();
  }

  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    // TODO: Replace 'default' with actual merchantId from auth/store
    final response = await _productsApi.productsControllerFindAll(
      // merchantId: 'default',
    );

    if (response == null) {
      return [];
    }

    final products = response.map((item) {
      return _mapToProduct(item as Map<String, dynamic>);
    }).toList();

    // Local pagination since API doesn't support it yet
    if (startingAt >= products.length) return [];
    int end = startingAt + count;
    if (end > products.length) end = products.length;

    return products.sublist(startingAt, end);
  }

  @override
  Future<int> getTotalRows() async {
    // TODO: Replace 'default' with actual merchantId from auth/store
    final response = await _productsApi.productsControllerFindAll(
      // merchantId: 'default',
    );
    return response?.length ?? 0;
  }

  @override
  Future<Product> getProductById(ProductId id) async {
    final response = await _productsApi.productsControllerFindOne(
      id.value.toString(),
    );

    if (response == null) {
      throw Exception('Product not found');
    }

    return _mapToProduct(response as Map<String, dynamic>);
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) async {
    final typeEnum = _mapProductType(request.productType);

    CreatePhysicalDetailsDto? physicalDetails;
    if (typeEnum == CreateProductDtoTypeEnum.physical) {
      physicalDetails = CreatePhysicalDetailsDto(
        sku: request.sku,
        barcode: request.barcode,
        stockQuantity: request.stockQuantity,
        costPerItem: request.costPerItem,
      );
    }

    CreateServiceDefinitionDto? serviceDefinition;
    if (typeEnum == CreateProductDtoTypeEnum.service) {
      serviceDefinition = CreateServiceDefinitionDto(
        durationMinutes: request.duration ?? 60,
        bufferMinutes: request.buffer,
        maxCapacity: request.capacity,
        minLeadTimeHours: request.leadTime,
        staffAssignmentType: _mapStaffAssignment(request.staffAllocation),
      );
    }

    final dto = CreateProductDto(
      name: request.name,
      description: request.description,
      categoryId: request.category,
      slug: request.name.toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
      type: typeEnum,
      basePrice: request.basePrice,
      salePrice: request.salePrice,
      status: _mapStatus(request.status),
      isVisibleOnline: request.onlineStore,
      vendorName: request.vendor,
      physicalDetails: physicalDetails,
      serviceDefinition: serviceDefinition,
      media: request.images.asMap().entries.map((entry) {
        return CreateProductMediaDto(
          url: entry.value,
          mediaType: CreateProductMediaDtoMediaTypeEnum.image,
          isThumbnail: entry.key == 0,
          sortOrder: entry.key,
        );
      }).toList(),
    );

    final response = await _productsApi.productsControllerCreate(dto);

    if (response == null) {
      throw Exception('Failed to create product');
    }

    return _mapToProduct(response as Map<String, dynamic>);
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) async {
    final dto = UpdateProductDto(
      name: request.name,
      basePrice: request.basePrice,
      description: request.description,
      categoryId: request.category,
      media:
          request.images?.asMap().entries.map((entry) {
            return CreateProductMediaDto(
              url: entry.value,
              mediaType: CreateProductMediaDtoMediaTypeEnum.image,
              isThumbnail: entry.key == 0,
              sortOrder: entry.key,
            );
          }).toList() ??
          [],
    );

    await _productsApi.productsControllerUpdate(
      request.id.value.toString(),
      dto,
    );
  }

  @override
  Future<void> deleteProduct(ProductId id) async {
    await _productsApi.productsControllerRemove(id.value.toString());
  }

  Product _mapToProduct(Map<String, dynamic> json) {
    final physical = json['physicalDetails'] as Map<String, dynamic>?;
    final service = json['serviceDefinition'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;

    return Product(
      id: ProductId(int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      basePrice: double.tryParse(json['basePrice']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['salePrice']?.toString() ?? '0'),
      productType: json['type']?.toString().toLowerCase() ?? 'service',
      status: json['status']?.toString().toLowerCase() ?? 'draft',
      category: CategoryEntity(
        id: category?['id']?.toString() ?? '',
        name: category?['name']?.toString() ?? '',
        slug: category?['slug']?.toString() ?? '',
      ),
      onlineStore: json['isVisibleOnline'] as bool? ?? false,
      vendor: json['vendorName']?.toString(),
      images:
          (json['media'] as List<dynamic>?)
              ?.map((m) => m['url']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],

      // Physical details
      sku: physical?['sku']?.toString(),
      barcode: physical?['barcode']?.toString(),
      stockQuantity: int.tryParse(physical?['stockQuantity']?.toString() ?? ''),
      costPerItem: double.tryParse(physical?['costPerItem']?.toString() ?? ''),

      // Service details
      duration: int.tryParse(service?['durationMinutes']?.toString() ?? ''),
      buffer: int.tryParse(service?['bufferMinutes']?.toString() ?? ''),
      capacity: int.tryParse(service?['maxCapacity']?.toString() ?? ''),
      leadTime: int.tryParse(service?['minLeadTimeHours']?.toString() ?? ''),
      staffAllocation:
          service?['staffAssignmentType']?.toString().toLowerCase() ?? 'any',
    );
  }

  CreateProductDtoTypeEnum _mapProductType(String type) {
    switch (type.toLowerCase()) {
      case 'physical':
        return CreateProductDtoTypeEnum.physical;
      case 'service':
      default:
        return CreateProductDtoTypeEnum.service;
    }
  }

  CreateProductDtoStatusEnum _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return CreateProductDtoStatusEnum.active;
      case 'archived':
        return CreateProductDtoStatusEnum.archived;
      case 'draft':
      default:
        return CreateProductDtoStatusEnum.draft;
    }
  }

  CreateServiceDefinitionDtoStaffAssignmentTypeEnum? _mapStaffAssignment(
    String assignment,
  ) {
    switch (assignment.toLowerCase()) {
      case 'specific':
        return CreateServiceDefinitionDtoStaffAssignmentTypeEnum.specific;
      case 'any':
      default:
        return CreateServiceDefinitionDtoStaffAssignmentTypeEnum.any;
    }
  }
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProductRemoteDataSourceImpl(apiService: apiService);
}
