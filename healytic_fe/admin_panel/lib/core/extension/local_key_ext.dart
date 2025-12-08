import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension LocalKeyExtension on LocalKey {
  /// Trả về giá trị String sạch của Key
  String toCleanString() {
    // 1. Nếu là ValueKey (thường dùng nhất) -> Lấy giá trị bên trong
    if (this is ValueKey) {
      final value = (this as ValueKey).value;
      return value.toString();
    }

    // 2. Nếu là ObjectKey -> Lấy giá trị object bên trong
    if (this is ObjectKey) {
      final value = (this as ObjectKey).value;
      return value.toString();
    }

    // 3. Nếu là UniqueKey hoặc các loại khác -> Dùng mặc định
    // UniqueKey không lưu giá trị readable, nó chỉ là identity hash
    return toString();
  }
}
