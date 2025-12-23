import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeCategory {
  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const HomeCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.icon = Symbols.spa,
    this.color = const Color(0xFFEC4899),
    this.bgColor = const Color(0xFFFDF2F8),
    this.borderColor = const Color(0xFFFBCFE8),
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
    this.staffAvatars = const [],
    this.type = 'service',
  });

  final String type;
}
