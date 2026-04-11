import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_alert.entity.freezed.dart';

/// An inventory alert item for the dashboard.
///
/// Represents a low-stock or expiring product that
/// requires partner attention.
@freezed
abstract class InventoryAlert with _$InventoryAlert {
  const factory InventoryAlert({
    required String id,
    required String productName,

    /// e.g., 'low_stock', 'expiring', 'out_of_stock'
    required String alertType,
    required String message,
    required DateTime createdAt,

    /// Severity: 'warning', 'critical', 'info'
    @Default('warning') String severity,
  }) = _InventoryAlert;
}
