// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: ProductId.fromJson(json['id']),
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String,
  image: json['image'] as String,
  category: json['category'] as String,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id.toJson(),
  'name': instance.name,
  'price': instance.price,
  'description': instance.description,
  'image': instance.image,
  'category': instance.category,
};
