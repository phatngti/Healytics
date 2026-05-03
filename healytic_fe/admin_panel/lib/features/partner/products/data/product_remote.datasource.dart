import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/products/data/data/product_mock_data.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';

import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:flutter/foundation.dart';

part 'product_remote.datasource.g.dart';

/// Contract for product remote data operations.
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

/// Real implementation using the Partner Products API.
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  PartnerHealthServicesApi get _partnerHealthServicesApi =>
      apiService.partnerHealthServicesApi;
  CategoriesApi get _categoriesApi => apiService.categoriesApi;
  PartnerServiceTagsApi get _serviceTagsApi => apiService.serviceTagsApi;

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
    final response = await _partnerHealthServicesApi
        .partnerHealthServiceControllerFindAll();

    if (response == null) {
      return [];
    }

    final products = response.map(_mapToProduct).toList();

    // Local pagination since API doesn't support it
    if (startingAt >= products.length) return [];
    int end = startingAt + count;
    if (end > products.length) end = products.length;

    return products.sublist(startingAt, end);
  }

  @override
  Future<int> getTotalRows() async {
    final response = await _partnerHealthServicesApi
        .partnerHealthServiceControllerFindAll();
    return response?.length ?? 0;
  }

  @override
  Future<Product> getProductById(ProductId id) async {
    final response = await _partnerHealthServicesApi
        .partnerHealthServiceControllerFindAll();

    if (response == null) {
      throw Exception('Product not found');
    }

    final match = response.where((dto) => dto.id == id.value.toString());

    if (match.isEmpty) {
      throw Exception('Product not found');
    }

    return _mapToProduct(match.first);
  }

  @override
  Future<Product> createProduct(CreateProductRequest request) async {
    final typeEnum = _mapProductType(request.productType);

    CreatePartnerHealthServiceDefinitionDto? productDefinition;
    if (typeEnum == HealthServiceType.service) {
      productDefinition = CreatePartnerHealthServiceDefinitionDto(
        durationMinutes: request.duration ?? 60,
        bufferMinutes: request.buffer,
        maxCapacity: request.capacity,
        minLeadTimeHours: request.leadTime,
        staffAssignmentType: _mapStaffAssignment(request.staffAllocation),
      );
    }

    final dto = CreatePartnerHealthServiceDto(
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
      productDefinition: productDefinition,
      media: request.images
          .asMap()
          .entries
          .map(
            (entry) => CreatePartnerHealthServiceMediaDto(
              url: entry.value,
              mediaType: CreatePartnerHealthServiceMediaDtoMediaTypeEnum.image,
              isThumbnail: entry.key == 0,
              sortOrder: entry.key,
            ),
          )
          .toList(),
      facilityImages: request.facilityImages
          .asMap()
          .entries
          .map(
            (entry) => CreatePartnerHealthServiceFacilityImageDto(
              imageUrl: entry.value.imageUrl,
              label: entry.value.label,
              sortOrder: entry.key,
            ),
          )
          .toList(),
      serviceManual: _mapServiceManual(request.serviceManual),
    );

    final response = await _partnerHealthServicesApi
        .partnerHealthServiceControllerCreate(dto);

    if (response == null) {
      throw Exception('Failed to create product');
    }

    return _mapToProduct(response);
  }

  @override
  Future<void> updateProduct(UpdateProductRequest request) async {
    final dto = UpdatePartnerHealthServiceDto(
      name: request.name,
      basePrice: request.basePrice,
      description: request.description,
      categoryId: request.category,
      employeeIds: request.staffIds ?? [],
      media:
          request.images?.asMap().entries.map((entry) {
            return CreatePartnerHealthServiceMediaDto(
              url: entry.value,
              mediaType: CreatePartnerHealthServiceMediaDtoMediaTypeEnum.image,
              isThumbnail: entry.key == 0,
              sortOrder: entry.key,
            );
          }).toList() ??
          [],
      serviceManual: _mapServiceManual(request.serviceManual),
    );

    await _partnerHealthServicesApi.partnerHealthServiceControllerUpdate(
      request.id.value.toString(),
      dto,
    );
  }

  @override
  Future<void> deleteProduct(ProductId id) async {
    await _partnerHealthServicesApi.partnerHealthServiceControllerRemove(
      id.value.toString(),
    );
  }

  /// Maps a [PartnerProductResponseDto] to the
  /// domain [Product] entity.
  Product _mapToProduct(PartnerHealthServiceResponseDto dto) {
    final service = dto.productDefinition;
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

      // Service Manual
      serviceManual: _mapServiceManualFromDto(dto.serviceManual),
    );
  }

  HealthServiceType _mapProductType(String type) {
    switch (type.toLowerCase()) {
      case 'service':
      default:
        return HealthServiceType.service;
    }
  }

  CreatePartnerHealthServiceDtoStatusEnum _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return CreatePartnerHealthServiceDtoStatusEnum.active;
      case 'archived':
        return CreatePartnerHealthServiceDtoStatusEnum.archived;
      case 'draft':
      default:
        return CreatePartnerHealthServiceDtoStatusEnum.draft;
    }
  }

  // ignore: lines_longer_than_80_chars
  CreatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum?
  _mapStaffAssignment(String assignment) {
    switch (assignment.toLowerCase()) {
      case 'specific':
        return CreatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum
            .specific;
      case 'any':
      default:
        return CreatePartnerHealthServiceDefinitionDtoStaffAssignmentTypeEnum
            .any;
    }
  }

  /// Maps a domain [ServiceManualEntity] to the
  /// OpenAPI [ServiceManualInputDto].
  ServiceManualInputDto? _mapServiceManual(ServiceManualEntity? manual) {
    if (manual == null) return null;
    return ServiceManualInputDto(
      preServiceGuidelines: manual.preServiceGuidelines,
      serviceRules: manual.serviceRules
          .map(
            (r) => ServiceRuleInputDto(
              iconSlug: r.iconSlug,
              title: r.title,
              description: r.description,
            ),
          )
          .toList(),
      procedureSteps: manual.procedureSteps
          .asMap()
          .entries
          .map(
            (e) => ProcedureStepInputDto(
              stepNumber: e.key + 1,
              title: e.value.title,
              description: e.value.description,
            ),
          )
          .toList(),
    );
  }

  /// Maps a [PartnerServiceManualDto] from the API
  /// response to the domain [ServiceManualEntity].
  ServiceManualEntity? _mapServiceManualFromDto(PartnerServiceManualDto? dto) {
    if (dto == null) return null;
    return ServiceManualEntity(
      preServiceGuidelines: dto.preServiceGuidelines,
      serviceRules: dto.serviceRules
          .map(
            (r) => ServiceRuleEntity(
              iconSlug: r.iconSlug,
              title: r.title,
              description: r.description,
            ),
          )
          .toList(),
      procedureSteps: dto.procedureSteps
          .map(
            (s) => ProcedureStepEntity(
              stepNumber: s.stepNumber.toInt(),
              title: s.title,
              description: s.description,
            ),
          )
          .toList(),
    );
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
        description:
            'Description for mock product '
            '${startingAt + index}',
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
        images: [
          'https://picsum.photos/200/300'
              '?random=${startingAt + index}',
        ],
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

    final product = productMockData[id.value] ?? productMockDefault;

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
