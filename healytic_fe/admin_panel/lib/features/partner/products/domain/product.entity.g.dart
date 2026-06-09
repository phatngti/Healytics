// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: ProductId.fromJson(json['id']),
  name: json['name'] as String,
  description: json['description'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  productType: json['productType'] as String? ?? 'service',
  basePrice: (json['basePrice'] as num).toDouble(),
  salePrice: (json['salePrice'] as num?)?.toDouble(),
  costPerItem: (json['costPerItem'] as num?)?.toDouble(),
  sku: json['sku'] as String?,
  barcode: json['barcode'] as String?,
  stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
  status: json['status'] as String? ?? 'draft',
  onlineStore: json['onlineStore'] as bool? ?? true,
  category: CategoryEntity.fromJson(json['category'] as Map<String, dynamic>),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  duration: (json['duration'] as num?)?.toInt(),
  buffer: (json['buffer'] as num?)?.toInt(),
  capacity: (json['capacity'] as num?)?.toInt(),
  leadTime: (json['leadTime'] as num?)?.toInt(),
  staffAllocation: json['staffAllocation'] as String? ?? 'any',
  staffIds:
      (json['staffIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  facilityImages:
      (json['facilityImages'] as List<dynamic>?)
          ?.map((e) => FacilityImageEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  serviceManual: json['serviceManual'] == null
      ? null
      : ServiceManualEntity.fromJson(
          json['serviceManual'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id.toJson(),
  'name': instance.name,
  'description': instance.description,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'productType': instance.productType,
  'basePrice': instance.basePrice,
  'salePrice': instance.salePrice,
  'costPerItem': instance.costPerItem,
  'sku': instance.sku,
  'barcode': instance.barcode,
  'stockQuantity': instance.stockQuantity,
  'status': instance.status,
  'onlineStore': instance.onlineStore,
  'category': instance.category.toJson(),
  'tags': instance.tags,
  'duration': instance.duration,
  'buffer': instance.buffer,
  'capacity': instance.capacity,
  'leadTime': instance.leadTime,
  'staffAllocation': instance.staffAllocation,
  'staffIds': instance.staffIds,
  'images': instance.images,
  'facilityImages': instance.facilityImages.map((e) => e.toJson()).toList(),
  'serviceManual': instance.serviceManual?.toJson(),
};
