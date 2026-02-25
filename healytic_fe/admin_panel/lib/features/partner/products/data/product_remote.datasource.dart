import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/products/data/data/product_mock_data.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';

import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:flutter/foundation.dart';

part 'product_remote.datasource.g.dart';

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

  Future<List<ServiceTagResponseDto>> getServiceTags();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  ProductsApi get _productsApi => apiService.productsApi;
  PartnerProductsApi get _partnerProductsApi => apiService.partnerProductsApi;
  CategoriesApi get _categoriesApi => apiService.categoriesApi;
  ServiceTagsApi get _serviceTagsApi => apiService.serviceTagsApi;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await _categoriesApi.categoriesControllerFindAll();

    if (response == null) {
      return [];
    }

    return response.map((e) {
      return CategoryEntity(id: e.id, name: e.name, slug: e.slug);
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

    final products = response.map(_mapToProduct).toList();

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

    return _mapToProduct(response);
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) async {
    final typeEnum = _mapProductType(request.productType);

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
      employeeIds: request.staffIds,
      serviceDefinition: serviceDefinition,
      media: request.images
          .asMap()
          .entries
          .map(
            (entry) => CreateProductMediaDto(
              url: entry.value,
              mediaType: CreateProductMediaDtoMediaTypeEnum.image,
              isThumbnail: entry.key == 0,
              sortOrder: entry.key,
            ),
          )
          .toList(),
      facilityImages: request.facilityImages
          .asMap()
          .entries
          .map(
            (entry) => CreateProductFacilityImageDto(
              imageUrl: entry.value.imageUrl,
              label: entry.value.label,
              sortOrder: entry.key,
            ),
          )
          .toList(),
      reviews: request.reviews
          .map(
            (review) => CreateProductReviewDto(
              reviewerName: review.reviewerName,
              avatarUrl: review.avatarUrl,
              rating: review.rating,
              status: review.status,
              date: review.date,
              text: review.text,
              imageUrls: review.imageUrls,
            ),
          )
          .toList(),
    );

    final response = await _partnerProductsApi.partnerProductsControllerCreate(
      dto,
    );

    if (response == null) {
      throw Exception('Failed to create product');
    }

    return _mapToProduct(response);
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) async {
    final dto = UpdateProductDto(
      name: request.name,
      basePrice: request.basePrice,
      description: request.description,
      categoryId: request.category,
      employeeIds: request.staffIds ?? [],
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

    await _partnerProductsApi.partnerProductsControllerUpdate(
      request.id.value.toString(),
      dto,
    );
  }

  @override
  Future<void> deleteProduct(ProductId id) async {
    await _partnerProductsApi.partnerProductsControllerRemove(
      id.value.toString(),
    );
  }

  Product _mapToProduct(ProductResponseDto dto) {
    final service = dto.serviceDefinition;
    final category = dto.category;

    return Product(
      id: ProductId(dto.id),
      name: dto.name,
      description: dto.description?.toString() ?? '',
      basePrice: dto.basePrice.toDouble(),
      salePrice: double.tryParse(dto.salePrice?.toString() ?? ''),
      productType: dto.type.value.toLowerCase(),
      status: dto.status.value.toLowerCase(),
      category: CategoryEntity(
        id: category?.id ?? '',
        name: category?.name ?? '',
        slug: category?.slug ?? '',
      ),
      onlineStore: dto.isVisibleOnline,
      images: dto.media.map((m) => m.url).where((s) => s.isNotEmpty).toList(),

      // Service details
      duration: service?.durationMinutes.toInt(),
      buffer: service?.bufferMinutes?.toInt(),
      capacity: service?.maxCapacity?.toInt(),
      leadTime: service?.minLeadTimeHours?.toInt(),
      staffAllocation: service?.staffAssignmentType?.toLowerCase() ?? 'any',
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

  @override
  Future<List<ServiceTagResponseDto>> getServiceTags() async {
    final response = await _serviceTagsApi.serviceTagsControllerFindActive();
    return response ?? [];
  }
}

class ProductRemoteDataSourceMock implements ProductRemoteDataSource {
  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      count,
      (index) => Product(
        id: ProductId('mock-id-${startingAt + index}'),
        name: 'Mock Product ${startingAt + index}',
        description: 'Description for mock product ${startingAt + index}',
        basePrice: 100.0 + index,
        salePrice: 90.0 + index,
        productType: index % 2 == 0 ? 'service' : 'physical',
        status: 'active',
        category: CategoryEntity(
          id: 'cat-${index % 5}',
          name: 'Category ${index % 5}',
          slug: 'category-${index % 5}',
        ),
        onlineStore: true,
        images: ['https://picsum.photos/200/300?random=${startingAt + index}'],
        costPerItem: index % 2 != 0 ? 50.0 : null,
        duration: index % 2 == 0 ? 60 : null,
        buffer: index % 2 == 0 ? 15 : null,
        capacity: index % 2 == 0 ? 1 : null,
        leadTime: index % 2 == 0 ? 24 : null,
        staffAllocation: 'any',
      ),
    );
  }

  @override
  Future<int> getTotalRows() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 100;
  }

  @override
  Future<Product> getProductById(ProductId id) async {
    await Future.delayed(const Duration(seconds: 1));

    // Return matching mock product or a default one
    final product = productMockData[id.value] ?? productMockDefault;

    // Ensure ID matches requested ID if falling back to default
    if (product.id != id) {
      return product.copyWith(id: id);
    }

    return product;
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return Product(
      id: ProductId('new-mock-id'),
      name: request.name,
      description: request.description,
      basePrice: request.basePrice,
      salePrice: request.salePrice,
      productType: request.productType,
      status: request.status,
      category: const CategoryEntity(
        id: 'cat-new',
        name: 'New Category',
        slug: 'new-category',
      ),
      onlineStore: request.onlineStore,
      images: request.images,
      costPerItem: request.costPerItem,
      duration: request.duration,
      buffer: request.buffer,
      capacity: request.capacity,
      leadTime: request.leadTime,
      staffAllocation: request.staffAllocation,
    );
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock update product: ${request.id}');
  }

  @override
  Future<void> deleteProduct(ProductId id) async {
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Mock delete product: $id');
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.generate(
      5,
      (index) => CategoryEntity(
        id: 'cat-$index',
        name: 'Category $index',
        slug: 'category-$index',
      ),
    );
  }

  @override
  Future<List<ServiceTagResponseDto>> getServiceTags() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ServiceTagResponseDto(
        id: 'tag-1',
        userId: 'mock-user',
        name: 'Relaxation',
        colorValue: '#4CAF50',
        usage: 0,
        isActive: true,
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceTagResponseDto(
        id: 'tag-2',
        userId: 'mock-user',
        name: 'Deep Tissue',
        colorValue: '#2196F3',
        usage: 0,
        isActive: true,
        sortOrder: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceTagResponseDto(
        id: 'tag-3',
        userId: 'mock-user',
        name: 'Premium',
        colorValue: '#FF9800',
        usage: 0,
        isActive: true,
        sortOrder: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return ProductRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return ProductRemoteDataSourceImpl(apiService: apiService);
}
