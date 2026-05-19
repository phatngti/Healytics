import 'package:flutter/material.dart';

/// Theme extension providing semantic colour pairs for booking
/// status badges. Each pair consists of a background and foreground
/// colour that together satisfy WCAG 1.4.3 (≥ 4.5:1 contrast).
///
/// Mapping:
/// - `finished` → success (bg + fg)
/// - `canceled` → error (bg + fg)
/// - `onProcess` → info (bg + fg)
/// - `waiting` → warning (bg + fg)
@immutable
class BookingStatusColors extends ThemeExtension<BookingStatusColors> {
  const BookingStatusColors({
    required this.successBg,
    required this.successFg,
    required this.errorBg,
    required this.errorFg,
    required this.infoBg,
    required this.infoFg,
    required this.warningBg,
    required this.warningFg,
  });

  /// Background colour for the success (finished) status.
  final Color successBg;

  /// Foreground colour for the success (finished) status.
  final Color successFg;

  /// Background colour for the error (canceled) status.
  final Color errorBg;

  /// Foreground colour for the error (canceled) status.
  final Color errorFg;

  /// Background colour for the info (onProcess) status.
  final Color infoBg;

  /// Foreground colour for the info (onProcess) status.
  final Color infoFg;

  /// Background colour for the warning (waiting) status.
  final Color warningBg;

  /// Foreground colour for the warning (waiting) status.
  final Color warningFg;

  /// Light theme instance with WCAG ≥ 4.5:1 contrast.
  static const light = BookingStatusColors(
    // Success: dark green text on light green background
    // Contrast ratio ≈ 7.0:1
    successBg: Color(0xFFE8F5E9),
    successFg: Color(0xFF1B5E20),
    // Error: dark red text on light red background
    // Contrast ratio ≈ 5.75:1
    errorBg: Color(0xFFFFEBEE),
    errorFg: Color(0xFFB71C1C),
    // Info: dark blue text on light blue background
    // Contrast ratio ≈ 7.56:1
    infoBg: Color(0xFFE3F2FD),
    infoFg: Color(0xFF0D47A1),
    // Warning: deep orange text on light amber background
    // Contrast ratio ≈ 5.27:1
    warningBg: Color(0xFFFFF8E1),
    warningFg: Color(0xFFBF360C),
  );

  /// Dark theme instance with WCAG ≥ 4.5:1 contrast.
  static const dark = BookingStatusColors(
    // Success: light green text on dark green background
    // Contrast ratio ≈ 5.85:1
    successBg: Color(0xFF1B5E20),
    successFg: Color(0xFFC8E6C9),
    // Error: light red text on dark red background
    // Contrast ratio ≈ 4.67:1
    errorBg: Color(0xFFB71C1C),
    errorFg: Color(0xFFFFCDD2),
    // Info: light blue text on dark blue background
    // Contrast ratio ≈ 6.15:1
    infoBg: Color(0xFF0D47A1),
    infoFg: Color(0xFFBBDEFB),
    // Warning: light amber text on dark orange-brown background
    // Contrast ratio ≈ 9.43:1
    warningBg: Color(0xFF612E00),
    warningFg: Color(0xFFFFECB3),
  );

  @override
  BookingStatusColors copyWith({
    Color? successBg,
    Color? successFg,
    Color? errorBg,
    Color? errorFg,
    Color? infoBg,
    Color? infoFg,
    Color? warningBg,
    Color? warningFg,
  }) {
    return BookingStatusColors(
      successBg: successBg ?? this.successBg,
      successFg: successFg ?? this.successFg,
      errorBg: errorBg ?? this.errorBg,
      errorFg: errorFg ?? this.errorFg,
      infoBg: infoBg ?? this.infoBg,
      infoFg: infoFg ?? this.infoFg,
      warningBg: warningBg ?? this.warningBg,
      warningFg: warningFg ?? this.warningFg,
    );
  }

  @override
  BookingStatusColors lerp(
    ThemeExtension<BookingStatusColors>? other,
    double t,
  ) {
    if (other is! BookingStatusColors) {
      return this;
    }
    return BookingStatusColors(
      successBg: Color.lerp(successBg, other.successBg, t)!,
      successFg: Color.lerp(successFg, other.successFg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      errorFg: Color.lerp(errorFg, other.errorFg, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      infoFg: Color.lerp(infoFg, other.infoFg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningFg: Color.lerp(warningFg, other.warningFg, t)!,
    );
  }
}
