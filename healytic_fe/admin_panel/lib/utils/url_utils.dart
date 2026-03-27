import 'package:admin_panel/core/entities/store.entity.dart' show Store;
import 'package:admin_panel/core/models/store.model.dart';

/// Formats a file key to a full R2 public URL.
///
/// Returns null if the [key] is null or empty.
/// Otherwise, returns the full URL by prepending the R2 public base URL.
String? formatR2Url(String? key) {
  if (key == null || key.isEmpty) return null;
  final baseUrl = Store.get<String>(StoreKey.r2PublicBaseUrl);
  return '$baseUrl/$key';
}
