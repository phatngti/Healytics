import 'package:web/web.dart'; // Thay thế import dart:html

String? getBrowserItem(String key) {
  // Thay thế [key] bằng .getItem(key)
  return window.localStorage.getItem(key);
}

void setBrowserItem(String key, String value) {
  // Thay thế [key] = value bằng .setItem(key, value)
  window.localStorage.setItem(key, value);
}

void removeBrowserItem(String key) {
  // Thay thế .remove(key) bằng .removeItem(key)
  window.localStorage.removeItem(key);
}
