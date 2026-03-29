/// Product type classification.
enum ProductType {
  service,
  product;

  /// User-friendly display name.
  String get displayName => switch (this) {
    ProductType.service => 'Service',
    ProductType.product => 'Product',
  };

  /// API value for backend communication.
  String get apiValue => switch (this) {
    ProductType.service => 'service',
    ProductType.product => 'product',
  };

  /// Parse from API value.
  static ProductType? fromApiValue(String? value) {
    if (value == null) return null;
    return switch (value.toLowerCase()) {
      'service' => ProductType.service,
      'product' => ProductType.product,
      _ => null,
    };
  }
}
