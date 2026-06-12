import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeCategory {
  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final String? parentName;
  final IconData icon;
  final String categoryType;
  final List<HomeCategory> children;

  const HomeCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    this.parentName,
    this.icon = Symbols.spa,
    this.categoryType = 'primary',
    this.children = const [],
  });
}

class HomeProduct {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String category;
  final String? categoryId;
  final String duration;
  final String price;
  final num priceAmount;
  final String rating;
  final String vendorName;
  final String? clinicId;
  final String location;
  final List<String> staffAvatars;

  const HomeProduct({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.category,
    this.categoryId,
    required this.duration,
    required this.price,
    this.priceAmount = 0,
    this.rating = '4.9',
    this.vendorName = '',
    this.clinicId,
    this.location = '',
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

/// Lightweight specialist entity for the home page
/// featured-specialists section.
class HomeSpecialist {
  /// Unique identifier.
  final String id;

  /// Display name (e.g. "Dr. Anna Nguyen").
  final String name;

  /// Short specialty label (e.g. "Spa Therapist").
  final String specialty;

  /// Optional avatar URL.
  final String? avatarUrl;

  /// Average rating (0.0 – 5.0).
  final double rating;

  /// Number of appointments/services sold.
  final int soldCount;

  /// Associated clinic or facility name.
  final String clinicName;

  const HomeSpecialist({
    required this.id,
    required this.name,
    required this.specialty,
    this.avatarUrl,
    this.rating = 0.0,
    this.soldCount = 0,
    this.clinicName = '',
  });
}
