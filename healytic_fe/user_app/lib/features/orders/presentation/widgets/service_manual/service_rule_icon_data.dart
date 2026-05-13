import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols_map.dart';

const _legacyIconSlugAliases = <String, String>{
  'clock': 'schedule',
  'shield_check': 'shield',
  'alert_triangle': 'warning',
};

/// Normalizes user-entered icon slugs to
/// Material Symbols naming convention.
String normalizeServiceRuleIconSlug(String slug) {
  return slug
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[\s-]+'), '_');
}

/// Resolves a saved service rule icon slug into
/// an [IconData], with legacy-alias fallback.
///
/// Returns `null` when the slug cannot be mapped.
IconData? serviceRuleIconData(String slug) {
  final normalized = normalizeServiceRuleIconSlug(slug);
  if (normalized.isEmpty) {
    return null;
  }

  final icon = materialSymbolsMap[normalized];
  if (icon != null) {
    return icon;
  }

  final alias = _legacyIconSlugAliases[normalized];
  return alias == null
      ? null
      : materialSymbolsMap[alias];
}
