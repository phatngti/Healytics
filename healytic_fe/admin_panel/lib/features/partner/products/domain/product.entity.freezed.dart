// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 ProductId get id;// General Information
 String get name; String get description; String get productType;// Pricing & Inventory
 double get basePrice; double? get salePrice; double? get costPerItem; String? get sku; String? get barcode; int? get stockQuantity;// Visibility
 String get status; bool get onlineStore;// Organization
 CategoryEntity get category; List<String> get tags;// Operations & Scheduling
 int? get duration; int? get buffer; int? get capacity; int? get leadTime; String get staffAllocation; List<String> get staffIds;// Media
 List<String> get images;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.costPerItem, costPerItem) || other.costPerItem == costPerItem)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.onlineStore, onlineStore) || other.onlineStore == onlineStore)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.buffer, buffer) || other.buffer == buffer)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.leadTime, leadTime) || other.leadTime == leadTime)&&(identical(other.staffAllocation, staffAllocation) || other.staffAllocation == staffAllocation)&&const DeepCollectionEquality().equals(other.staffIds, staffIds)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,productType,basePrice,salePrice,costPerItem,sku,barcode,stockQuantity,status,onlineStore,category,const DeepCollectionEquality().hash(tags),duration,buffer,capacity,leadTime,staffAllocation,const DeepCollectionEquality().hash(staffIds),const DeepCollectionEquality().hash(images)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, productType: $productType, basePrice: $basePrice, salePrice: $salePrice, costPerItem: $costPerItem, sku: $sku, barcode: $barcode, stockQuantity: $stockQuantity, status: $status, onlineStore: $onlineStore, category: $category, tags: $tags, duration: $duration, buffer: $buffer, capacity: $capacity, leadTime: $leadTime, staffAllocation: $staffAllocation, staffIds: $staffIds, images: $images)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 ProductId id, String name, String description, String productType, double basePrice, double? salePrice, double? costPerItem, String? sku, String? barcode, int? stockQuantity, String status, bool onlineStore, CategoryEntity category, List<String> tags, int? duration, int? buffer, int? capacity, int? leadTime, String staffAllocation, List<String> staffIds, List<String> images
});


$CategoryEntityCopyWith<$Res> get category;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? productType = null,Object? basePrice = null,Object? salePrice = freezed,Object? costPerItem = freezed,Object? sku = freezed,Object? barcode = freezed,Object? stockQuantity = freezed,Object? status = null,Object? onlineStore = null,Object? category = null,Object? tags = null,Object? duration = freezed,Object? buffer = freezed,Object? capacity = freezed,Object? leadTime = freezed,Object? staffAllocation = null,Object? staffIds = null,Object? images = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ProductId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,costPerItem: freezed == costPerItem ? _self.costPerItem : costPerItem // ignore: cast_nullable_to_non_nullable
as double?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,onlineStore: null == onlineStore ? _self.onlineStore : onlineStore // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryEntity,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,buffer: freezed == buffer ? _self.buffer : buffer // ignore: cast_nullable_to_non_nullable
as int?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,leadTime: freezed == leadTime ? _self.leadTime : leadTime // ignore: cast_nullable_to_non_nullable
as int?,staffAllocation: null == staffAllocation ? _self.staffAllocation : staffAllocation // ignore: cast_nullable_to_non_nullable
as String,staffIds: null == staffIds ? _self.staffIds : staffIds // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryEntityCopyWith<$Res> get category {
  
  return $CategoryEntityCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductId id,  String name,  String description,  String productType,  double basePrice,  double? salePrice,  double? costPerItem,  String? sku,  String? barcode,  int? stockQuantity,  String status,  bool onlineStore,  CategoryEntity category,  List<String> tags,  int? duration,  int? buffer,  int? capacity,  int? leadTime,  String staffAllocation,  List<String> staffIds,  List<String> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.productType,_that.basePrice,_that.salePrice,_that.costPerItem,_that.sku,_that.barcode,_that.stockQuantity,_that.status,_that.onlineStore,_that.category,_that.tags,_that.duration,_that.buffer,_that.capacity,_that.leadTime,_that.staffAllocation,_that.staffIds,_that.images);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductId id,  String name,  String description,  String productType,  double basePrice,  double? salePrice,  double? costPerItem,  String? sku,  String? barcode,  int? stockQuantity,  String status,  bool onlineStore,  CategoryEntity category,  List<String> tags,  int? duration,  int? buffer,  int? capacity,  int? leadTime,  String staffAllocation,  List<String> staffIds,  List<String> images)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.productType,_that.basePrice,_that.salePrice,_that.costPerItem,_that.sku,_that.barcode,_that.stockQuantity,_that.status,_that.onlineStore,_that.category,_that.tags,_that.duration,_that.buffer,_that.capacity,_that.leadTime,_that.staffAllocation,_that.staffIds,_that.images);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductId id,  String name,  String description,  String productType,  double basePrice,  double? salePrice,  double? costPerItem,  String? sku,  String? barcode,  int? stockQuantity,  String status,  bool onlineStore,  CategoryEntity category,  List<String> tags,  int? duration,  int? buffer,  int? capacity,  int? leadTime,  String staffAllocation,  List<String> staffIds,  List<String> images)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.productType,_that.basePrice,_that.salePrice,_that.costPerItem,_that.sku,_that.barcode,_that.stockQuantity,_that.status,_that.onlineStore,_that.category,_that.tags,_that.duration,_that.buffer,_that.capacity,_that.leadTime,_that.staffAllocation,_that.staffIds,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, required this.description, this.productType = 'service', required this.basePrice, this.salePrice, this.costPerItem, this.sku, this.barcode, this.stockQuantity, this.status = 'draft', this.onlineStore = true, required this.category, final  List<String> tags = const [], this.duration, this.buffer, this.capacity, this.leadTime, this.staffAllocation = 'any', final  List<String> staffIds = const [], final  List<String> images = const []}): _tags = tags,_staffIds = staffIds,_images = images;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  ProductId id;
// General Information
@override final  String name;
@override final  String description;
@override@JsonKey() final  String productType;
// Pricing & Inventory
@override final  double basePrice;
@override final  double? salePrice;
@override final  double? costPerItem;
@override final  String? sku;
@override final  String? barcode;
@override final  int? stockQuantity;
// Visibility
@override@JsonKey() final  String status;
@override@JsonKey() final  bool onlineStore;
// Organization
@override final  CategoryEntity category;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

// Operations & Scheduling
@override final  int? duration;
@override final  int? buffer;
@override final  int? capacity;
@override final  int? leadTime;
@override@JsonKey() final  String staffAllocation;
 final  List<String> _staffIds;
@override@JsonKey() List<String> get staffIds {
  if (_staffIds is EqualUnmodifiableListView) return _staffIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staffIds);
}

// Media
 final  List<String> _images;
// Media
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.salePrice, salePrice) || other.salePrice == salePrice)&&(identical(other.costPerItem, costPerItem) || other.costPerItem == costPerItem)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.onlineStore, onlineStore) || other.onlineStore == onlineStore)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.buffer, buffer) || other.buffer == buffer)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.leadTime, leadTime) || other.leadTime == leadTime)&&(identical(other.staffAllocation, staffAllocation) || other.staffAllocation == staffAllocation)&&const DeepCollectionEquality().equals(other._staffIds, _staffIds)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,productType,basePrice,salePrice,costPerItem,sku,barcode,stockQuantity,status,onlineStore,category,const DeepCollectionEquality().hash(_tags),duration,buffer,capacity,leadTime,staffAllocation,const DeepCollectionEquality().hash(_staffIds),const DeepCollectionEquality().hash(_images)]);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, productType: $productType, basePrice: $basePrice, salePrice: $salePrice, costPerItem: $costPerItem, sku: $sku, barcode: $barcode, stockQuantity: $stockQuantity, status: $status, onlineStore: $onlineStore, category: $category, tags: $tags, duration: $duration, buffer: $buffer, capacity: $capacity, leadTime: $leadTime, staffAllocation: $staffAllocation, staffIds: $staffIds, images: $images)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 ProductId id, String name, String description, String productType, double basePrice, double? salePrice, double? costPerItem, String? sku, String? barcode, int? stockQuantity, String status, bool onlineStore, CategoryEntity category, List<String> tags, int? duration, int? buffer, int? capacity, int? leadTime, String staffAllocation, List<String> staffIds, List<String> images
});


@override $CategoryEntityCopyWith<$Res> get category;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? productType = null,Object? basePrice = null,Object? salePrice = freezed,Object? costPerItem = freezed,Object? sku = freezed,Object? barcode = freezed,Object? stockQuantity = freezed,Object? status = null,Object? onlineStore = null,Object? category = null,Object? tags = null,Object? duration = freezed,Object? buffer = freezed,Object? capacity = freezed,Object? leadTime = freezed,Object? staffAllocation = null,Object? staffIds = null,Object? images = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ProductId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,salePrice: freezed == salePrice ? _self.salePrice : salePrice // ignore: cast_nullable_to_non_nullable
as double?,costPerItem: freezed == costPerItem ? _self.costPerItem : costPerItem // ignore: cast_nullable_to_non_nullable
as double?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: freezed == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,onlineStore: null == onlineStore ? _self.onlineStore : onlineStore // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryEntity,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,buffer: freezed == buffer ? _self.buffer : buffer // ignore: cast_nullable_to_non_nullable
as int?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,leadTime: freezed == leadTime ? _self.leadTime : leadTime // ignore: cast_nullable_to_non_nullable
as int?,staffAllocation: null == staffAllocation ? _self.staffAllocation : staffAllocation // ignore: cast_nullable_to_non_nullable
as String,staffIds: null == staffIds ? _self._staffIds : staffIds // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryEntityCopyWith<$Res> get category {
  
  return $CategoryEntityCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
