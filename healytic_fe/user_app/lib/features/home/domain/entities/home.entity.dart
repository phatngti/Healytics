import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeCategory {
  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final String categoryType;

  const HomeCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.icon = Symbols.spa,
    this.categoryType = 'primary',
  });
}

class HomeProduct {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String category;
  final String duration;
  final String price;
  final String rating;
  final String vendorName;
  final List<String> staffAvatars;

  const HomeProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.category,
    required this.duration,
    required this.price,
    this.rating = '4.9',
    this.vendorName = '',
    this.staffAvatars = const [],
    this.type = 'service',
  });

  final String type;
}

class ServiceTag {
  final String id;
  final String name;
  final String? description;
  final int colorValue;
  final int usage;
  final bool isActive;
  final int sortOrder;

  const ServiceTag({
    required this.id,
    required this.name,
    this.description,
    required this.colorValue,
    required this.usage,
    this.isActive = true,
    this.sortOrder = 0,
  });

  Color get color => Color(colorValue);
  IconData get icon => _getIconForTag(name);

  static IconData _getIconForTag(String tagName) {
    final normalized = tagName.toLowerCase();

    if (normalized.contains('massage')) return Symbols.spa;
    if (normalized.contains('facial')) {
      return Symbols.face_retouching_natural;
    }
    if (normalized.contains('aromatherapy')) return Symbols.local_florist;
    if (normalized.contains('yoga')) return Symbols.self_improvement;
    if (normalized.contains('meditation')) return Symbols.psychiatry;
    if (normalized.contains('therapy')) return Symbols.healing;
    if (normalized.contains('fitness')) return Symbols.fitness_center;
    if (normalized.contains('wellness')) return Symbols.ecg_heart;
    if (normalized.contains('stone')) return Symbols.background_dot_large;
    if (normalized.contains('sports')) return Symbols.sports;

    return Symbols.category;
  }
}
