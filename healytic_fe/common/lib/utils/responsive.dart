import 'package:flutter/widgets.dart';

// =============================================================================
// Platform-Aware Responsive System
// =============================================================================

/// Top-level screen type classification.
///
/// | Type    | Width (dp)   | Typical Targets                        |
/// |---------|-------------|----------------------------------------|
/// | mobile  | < 600       | Phones (portrait & landscape)           |
/// | tablet  | 600 – 1023  | Tablets, large foldables                |
/// | web     | ≥ 1024      | Desktops, web browsers, large tablets   |
enum ScreenType { mobile, tablet, web }

/// Classifies the current screen width into a [ScreenType].
///
/// ```dart
/// final type = getScreenType(context);
/// ```
ScreenType getScreenType(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return ScreenType.mobile;
  if (width < 1024) return ScreenType.tablet;
  return ScreenType.web;
}

/// Returns a value based on the current [ScreenType].
///
/// [tablet] falls back to [mobile] when not provided.
///
/// ```dart
/// final padding = responsive<double>(context,
///   mobile: 16.0,
///   tablet: 20.0,
///   web: 24.0,
/// );
/// ```
T responsive<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  required T web,
}) {
  return switch (getScreenType(context)) {
    ScreenType.mobile => mobile,
    ScreenType.tablet => tablet ?? mobile,
    ScreenType.web => web,
  };
}

/// Whether the screen is classified as mobile (< 600dp).
bool isMobile(BuildContext context) =>
    getScreenType(context) == ScreenType.mobile;

/// Whether the screen is classified as tablet (600–1023dp).
bool isTablet(BuildContext context) =>
    getScreenType(context) == ScreenType.tablet;

/// Whether the screen is classified as web/desktop (≥ 1024dp).
bool isWeb(BuildContext context) => getScreenType(context) == ScreenType.web;

/// Returns the current screen width in logical pixels.
double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

/// Returns the current screen height in logical pixels.
double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

// =============================================================================
// Mobile-Specific Responsive Helpers (Backward Compatible)
// =============================================================================

/// Mobile screen size tiers for fine-grained responsive adaptation.
///
/// | Tier     | Width (dp)  | Example Devices                       |
/// |----------|-------------|---------------------------------------|
/// | small    | < 360       | iPhone SE (320), Galaxy S4            |
/// | medium   | 360 – 399   | Pixel 5 (393), iPhone 13 Mini (375)   |
/// | large    | ≥ 400       | iPhone 16 Pro Max (430), Galaxy Ultra |
enum MobileSize { small, medium, large }

/// Classifies the current screen width into a [MobileSize] tier.
///
/// ```dart
/// final size = getMobileSize(context);
/// ```
MobileSize getMobileSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 360) return MobileSize.small;
  if (width < 400) return MobileSize.medium;
  return MobileSize.large;
}

/// Returns adaptive horizontal padding based on screen width.
///
/// - Small phones (< 360dp): 16.0
/// - Standard phones (360–399dp): 20.0
/// - Large phones (≥ 400dp): 24.0
///
/// ```dart
/// Padding(
///   padding: EdgeInsets.symmetric(
///     horizontal: getHorizontalPadding(context),
///   ),
///   child: child,
/// )
/// ```
double getHorizontalPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 360) return 16.0;
  if (width < 400) return 20.0;
  return 24.0;
}

/// Returns adaptive vertical spacing value based on screen width.
///
/// Useful for section gaps that should shrink on smaller screens.
/// - Small phones: returns [small]
/// - Standard phones: returns [medium]
/// - Large phones: returns [large]
double getAdaptiveSpacing(
  BuildContext context, {
  required double small,
  required double medium,
  required double large,
}) {
  final mobileSize = getMobileSize(context);
  return switch (mobileSize) {
    MobileSize.small => small,
    MobileSize.medium => medium,
    MobileSize.large => large,
  };
}
