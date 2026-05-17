import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols_map.dart';

/// A selectable Material Symbols icon for service rule icon slugs.
class ServiceRuleIconOption {
  const ServiceRuleIconOption({required this.slug, required this.icon});

  /// The persisted icon slug.
  final String slug;

  /// The icon rendered for the slug.
  final IconData icon;
}

const _legacyIconSlugAliases = <String, String>{
  'clock': 'schedule',
  'shield_check': 'shield',
  'alert_triangle': 'warning',
};

/// All outlined Material Symbols icons available for service rule selection.
final serviceRuleIconOptions =
    materialSymbolsMap.entries
        .where(
          (entry) =>
              !entry.key.endsWith('_rounded') && !entry.key.endsWith('_sharp'),
        )
        .map(
          (entry) => ServiceRuleIconOption(slug: entry.key, icon: entry.value),
        )
        .toList()
      ..sort((a, b) => a.slug.compareTo(b.slug));

/// Normalizes user-entered icon slugs to Material Symbols naming.
String normalizeServiceRuleIconSlug(String slug) {
  return slug.trim().toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');
}

/// Resolves a saved service rule icon slug into an icon, if it exists.
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
  return alias == null ? null : materialSymbolsMap[alias];
}
