import 'package:flutter/material.dart';

class NameAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double? fontSize;

  const NameAvatar({
    super.key,
    required this.name,
    this.radius = 24.0,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _getAvatarColor(name),
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize ?? (radius * 0.8), // Auto-scale font
          color: Colors.white,
        ),
      ),
    );
  }

  // Logic to extract initials
  String _getInitials(String name) {
    if (name.isEmpty) return "?";

    // Clean the string and split by space
    List<String> nameParts = name.trim().split(RegExp(r'\s+'));

    String firstLetter = nameParts.first[0].toUpperCase();

    // If there is a last name, add its initial
    if (nameParts.length > 1) {
      String lastLetter = nameParts.last[0].toUpperCase();
      return firstLetter + lastLetter;
    }

    return firstLetter;
  }

  // Logic to generate a consistent color based on the name string
  Color _getAvatarColor(String name) {
    // Use the hash of the name to pick a color from a predefined list
    // This ensures "John" always gets the same color.
    final int hash = name.hashCode;
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash % colors.length];
  }
}
