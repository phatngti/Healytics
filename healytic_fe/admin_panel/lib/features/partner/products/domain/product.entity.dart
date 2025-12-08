import 'package:freezed_annotation/freezed_annotation.dart';
part 'product.entity.freezed.dart';
part 'product.entity.g.dart';

@Freezed(toJson: true)
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required int id,
    required String name,
    required double price,
    required String description,
    required String image,
    required String category,
    @Default(false) bool selected,
  }) = _ProductEntity;

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);
}
