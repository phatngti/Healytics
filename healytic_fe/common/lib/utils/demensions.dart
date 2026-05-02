import 'package:flutter/widgets.dart';
import 'package:common/utils/responsive.dart';

/// A class containing predefined constant `SizedBox` widgets, `EdgeInsets`,
/// and `BorderRadius` values for consistent dimensions throughout the app.
///
/// Using `const` values is efficient as it allows Flutter to reuse the same
/// widget instances.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Hello'),
///     AppDimens.verticalMedium, // Reusable SizedBox
///     Container(
///       padding: AppDimens.paddingAllMedium, // Reusable EdgeInsets
///       margin: AppDimens.paddingAllMedium, // EdgeInsets can also be used for margins
///       decoration: BoxDecoration(
///         borderRadius: AppDimens.radiusMedium, // Reusable BorderRadius
///       ),
///       child: Text('World'),
///     ),
///   ],
/// )
/// ```
class AppDimens {
  // Prevent instantiation
  AppDimens._();

  // --- Vertical Spacing ---
  /// SizedBox with a height of 4.0
  static const verticalExtraSmall = SizedBox(height: 4.0);

  /// Alias for [verticalExtraSmall].
  static const verticalXs = verticalExtraSmall;

  /// SizedBox with a height of 8.0
  static const verticalSmall = SizedBox(height: 8.0);

  /// SizedBox with a height of 12.0
  static const verticalMediumSmall = SizedBox(height: 12.0);

  /// SizedBox with a height of 16.0
  static const verticalMedium = SizedBox(height: 16.0);

  /// SizedBox with a height of 24.0
  static const verticalLarge = SizedBox(height: 24.0);

  /// SizedBox with a height of 32.0
  static const verticalLargeExtra = SizedBox(height: 32.0);

  /// SizedBox with a height of 32.0
  static const verticalExtraLarge = SizedBox(height: 32.0);

  // --- Horizontal Spacing ---
  /// SizedBox with a width of 4.0
  static const horizontalExtraSmall = SizedBox(width: 4.0);

  /// Alias for [horizontalExtraSmall].
  static const horizontalXs = horizontalExtraSmall;

  /// SizedBox with a width of 8.0
  static const horizontalSmall = SizedBox(width: 8.0);

  /// SizedBox with a width of 12.0
  static const horizontalMediumSmall = SizedBox(width: 12.0);

  /// SizedBox with a width of 16.0
  static const horizontalMedium = SizedBox(width: 16.0);

  /// SizedBox with a width of 24.0
  static const horizontalLarge = SizedBox(width: 24.0);

  /// SizedBox with a width of 32.0
  static const horizontalLargeExtra = SizedBox(width: 32.0);

  /// SizedBox with a width of 32.0
  static const horizontalExtraLarge = SizedBox(width: 32.0);

  // --- Square Sizing ---
  /// SizedBox with width and height of 4.0
  static const sizeExtraSmall = SizedBox(width: 4.0, height: 4.0);

  /// SizedBox with width and height of 8.0
  static const sizeSmall = SizedBox(width: 8.0, height: 8.0);

  /// SizedBox with width and height of 12.0
  static const sizeMediumSmall = SizedBox(width: 12.0, height: 12.0);

  /// SizedBox with width and height of 16.0
  static const sizeMedium = SizedBox(width: 16.0, height: 16.0);

  /// SizedBox with width and height of 24.0
  static const sizeLarge = SizedBox(width: 24.0, height: 24.0);

  /// SizedBox with width and height of 32.0
  static const sizeExtraLarge = SizedBox(width: 32.0, height: 32.0);

  // --- EdgeInsets ---
  // Note: EdgeInsets can be used for both padding and margin.

  // All
  /// EdgeInsets.all(4.0)
  static const paddingAllExtraSmall = EdgeInsets.all(4.0);

  /// EdgeInsets.all(8.0)
  static const paddingAllSmall = EdgeInsets.all(8.0);

  /// EdgeInsets.all(12.0)
  static const paddingAllMediumSmall = EdgeInsets.all(12.0);

  /// Alias for [paddingAllMediumSmall].
  static const paddingAllSmMd = paddingAllMediumSmall;

  /// EdgeInsets.all(16.0)
  static const paddingAllMedium = EdgeInsets.all(16.0);

  /// EdgeInsets.all(20.0)
  static const paddingAllMediumLarge = EdgeInsets.all(20.0);

  /// EdgeInsets.all(24.0)
  static const paddingAllLarge = EdgeInsets.all(24.0);

  // Symmetric Vertical
  /// EdgeInsets.symmetric(vertical: 4.0)
  static const paddingVerticalExtraSmall = EdgeInsets.symmetric(vertical: 4.0);

  /// EdgeInsets.symmetric(vertical: 8.0)
  static const paddingVerticalSmall = EdgeInsets.symmetric(vertical: 8.0);

  /// EdgeInsets.symmetric(vertical: 12.0)
  static const paddingVerticalMediumSmall = EdgeInsets.symmetric(
    vertical: 12.0,
  );

  /// EdgeInsets.symmetric(vertical: 16.0)
  static const paddingVerticalMedium = EdgeInsets.symmetric(vertical: 16.0);

  /// EdgeInsets.symmetric(vertical: 24.0)
  static const paddingVerticalLarge = EdgeInsets.symmetric(vertical: 24.0);

  // Only Top
  /// EdgeInsets.only(top: 8.0)
  static const paddingTopSmall = EdgeInsets.only(top: 8.0);

  // Symmetric Horizontal
  /// EdgeInsets.symmetric(horizontal: 4.0)
  static const paddingHorizontalExtraSmall = EdgeInsets.symmetric(
    horizontal: 4.0,
  );

  /// EdgeInsets.symmetric(horizontal: 8.0)
  static const paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: 8.0);

  /// EdgeInsets.symmetric(horizontal: 16.0)
  static const paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: 16.0);

  /// EdgeInsets.symmetric(horizontal: 20.0)
  static const paddingHorizontalMediumLarge = EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  /// EdgeInsets.symmetric(horizontal: 24.0)
  static const paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: 24.0);

  // --- BorderRadius ---
  /// BorderRadius.circular(4.0)
  static const radiusExtraSmall = BorderRadius.all(Radius.circular(4.0));

  /// BorderRadius.circular(8.0)
  static const radiusSmall = BorderRadius.all(Radius.circular(8.0));

  /// Alias for [radiusSmall].
  static const radiusSm = radiusSmall;

  /// BorderRadius.circular(12.0)
  static const radiusMediumSmall = BorderRadius.all(Radius.circular(12.0));

  /// BorderRadius.circular(16.0)
  static const radiusMedium = BorderRadius.all(Radius.circular(16.0));

  /// Alias for [radiusMedium].
  static const radiusMd = radiusMedium;

  /// BorderRadius.circular(20.0)
  static const radiusMediumLarge = BorderRadius.all(Radius.circular(20.0));

  /// BorderRadius.circular(24.0)
  static const radiusLarge = BorderRadius.all(Radius.circular(24.0));

  /// BorderRadius.circular(100.0) - Pill/Stadium shape
  static const radiusPill = BorderRadius.all(Radius.circular(100.0));

  // --- Dimensions ---
  static const double sidebarWidth = 250.0;

  // --- Text ---
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;

  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeExtraExtraLarge = 20.0;
  static const double fontSizeExtraExtraExtraLarge = 22.0;
  static const double fontSizeExtraExtraExtraExtraLarge = 24.0;

  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double letterSpacingSmall = 0.5;
  static const double letterSpacingMedium = 1.0;
  static const double letterSpacingLarge = 1.5;

  // --- Responsive Helpers ---
  // These methods return platform-appropriate values based on screen type.
  // Import 'package:common/utils/responsive.dart' to use.

  /// Responsive icon size: mobile 16, tablet 18, web 20.
  static double responsiveIconSize(BuildContext context) =>
      responsive(context, mobile: 16.0, tablet: 18.0, web: 20.0);

  /// Responsive small icon size: mobile 12, tablet 14, web 16.
  static double responsiveIconSizeSmall(BuildContext context) =>
      responsive(context, mobile: 12.0, tablet: 14.0, web: 16.0);

  /// Responsive large icon size: mobile 20, tablet 22, web 24.
  static double responsiveIconSizeLarge(BuildContext context) =>
      responsive(context, mobile: 20.0, tablet: 22.0, web: 24.0);

  /// Responsive padding — scales with screen type.
  static EdgeInsets responsivePadding(BuildContext context) => responsive(
    context,
    mobile: paddingAllSmall,
    tablet: paddingAllMediumSmall,
    web: paddingAllMedium,
  );

  /// Responsive horizontal padding.
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) =>
      responsive(
        context,
        mobile: paddingHorizontalSmall,
        tablet: paddingHorizontalMedium,
        web: paddingHorizontalLarge,
      );

  /// Responsive font size with custom mobile/web values.
  static double responsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double web,
  }) => responsive(context, mobile: mobile, tablet: tablet, web: web);

  /// Responsive border radius — scales with screen type.
  static BorderRadius responsiveRadius(BuildContext context) => responsive(
    context,
    mobile: radiusSmall,
    tablet: radiusMediumSmall,
    web: radiusMedium,
  );

  /// Generic responsive value helper — convenience passthrough.
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T web,
  }) => responsive(context, mobile: mobile, tablet: tablet, web: web);

  // ════════════════════════════════════════════════════════════
  // Raw Spacing Values (static const)
  // ════════════════════════════════════════════════════════════

  /// 2.0 dp spacing
  static const double spaceXxs = 2.0;

  /// 4.0 dp spacing
  static const double spaceXs = 4.0;

  /// 8.0 dp spacing
  static const double spaceSm = 8.0;

  /// 10.0 dp spacing
  static const double spaceSmMd = 10.0;

  /// 12.0 dp spacing
  static const double spaceMd = 12.0;

  /// 14.0 dp spacing
  static const double spaceMdLg = 14.0;

  /// 16.0 dp spacing
  static const double spaceLg = 16.0;

  /// 20.0 dp spacing
  static const double spaceXl = 20.0;

  /// 24.0 dp spacing
  static const double spaceXxl = 24.0;

  /// 32.0 dp spacing
  static const double spaceXxxl = 32.0;

  // ════════════════════════════════════════════════════════════
  // Icon Sizes (static const)
  // ════════════════════════════════════════════════════════════

  /// 14.0 dp icon (smallest inline icons)
  static const double iconXs = 14.0;

  /// 16.0 dp icon
  static const double iconSm = 16.0;

  /// 18.0 dp icon
  static const double iconSmMd = 18.0;

  /// 20.0 dp icon
  static const double iconMd = 20.0;

  /// 24.0 dp icon (standard Material icon)
  static const double iconLg = 24.0;

  /// 26.0 dp icon
  static const double iconXl = 26.0;

  /// 32.0 dp icon
  static const double iconXxl = 32.0;

  // ════════════════════════════════════════════════════════════
  // Touch Targets & Component Sizes (static const)
  // ════════════════════════════════════════════════════════════

  /// Minimum touch area per Material guidelines (48 × 48 dp).
  static const double touchTarget = 48.0;

  /// Small avatar / icon container (32 dp)
  static const double avatarSm = 32.0;

  /// Medium avatar / icon container (48 dp)
  static const double avatarMd = 48.0;

  /// Large avatar / icon container (56 dp)
  static const double avatarLg = 56.0;

  /// Small CTA button (30 dp)
  static const double ctaButtonSm = 30.0;

  /// Medium CTA button / icon container (40 dp)
  static const double ctaButtonMd = 40.0;

  // ════════════════════════════════════════════════════════════
  // Border Widths (static const)
  // ════════════════════════════════════════════════════════════

  /// Standard border width (1.0 dp)
  static const double borderWidth = 1.0;

  /// Thick border width (2.0 dp)
  static const double borderWidthThick = 2.0;

  // ════════════════════════════════════════════════════════════
  // Adaptive Methods (context-aware per MobileSize tier)
  // Values scale across small / medium / large phone tiers.
  // ════════════════════════════════════════════════════════════

  /// Generic adaptive value picker based on [MobileSize] tier.
  static double adaptive(
    BuildContext context, {
    required double small,
    required double medium,
    required double large,
  }) {
    return switch (getMobileSize(context)) {
      MobileSize.small => small,
      MobileSize.medium => medium,
      MobileSize.large => large,
    };
  }

  /// Horizontal page padding: 16 / 20 / 24 dp.
  static double horizontalPadding(BuildContext context) =>
      adaptive(context, small: 16, medium: 20, large: 24);

  /// Section spacing between major content blocks: 16 / 20 / 24 dp.
  static double sectionSpacing(BuildContext context) =>
      adaptive(context, small: 16, medium: 20, large: 24);

  /// Bottom scroll padding for breathing room: 24 / 28 / 32 dp.
  static double bottomScrollPadding(BuildContext context) =>
      adaptive(context, small: 24, medium: 28, large: 32);

  /// Card inner padding: 14 / 16 / 20 dp.
  static double cardPadding(BuildContext context) =>
      adaptive(context, small: 14, medium: 16, large: 20);

  /// Content inner padding (list items, sub-sections): 12 / 14 / 16.
  static double contentPadding(BuildContext context) =>
      adaptive(context, small: 12, medium: 14, large: 16);

  /// Card / container border radius: 16 / 20 / 24 dp.
  static double cardRadius(BuildContext context) =>
      adaptive(context, small: 16, medium: 20, large: 24);

  /// Banner inner padding: 16 / 20 / 24 dp.
  static double bannerPadding(BuildContext context) =>
      adaptive(context, small: 16, medium: 20, large: 24);

  /// Elevated button horizontal padding: 16 / 18 / 20 dp.
  static double buttonPaddingH(BuildContext context) =>
      adaptive(context, small: 16, medium: 18, large: 20);

  /// Elevated button vertical padding: 10 / 11 / 12 dp.
  static double buttonPaddingV(BuildContext context) =>
      adaptive(context, small: 10, medium: 11, large: 12);

  /// Title gap below section headers: 12 / 16 / 20 dp.
  static double titleGap(BuildContext context) =>
      adaptive(context, small: 12, medium: 16, large: 20);

  // ════════════════════════════════════════════════════════════
  // Proportional Helpers (screen-width-fraction)
  // For elements that must scale with viewport width.
  // ════════════════════════════════════════════════════════════

  /// Returns a width as a fraction of the screen width.
  ///
  /// Default 0.65 shows ~1.3–1.5 cards, hinting at scroll.
  static double widthFraction(BuildContext context, {double fraction = 0.65}) {
    return MediaQuery.sizeOf(context).width * fraction;
  }

  /// Returns a proportional height based on [containerWidth].
  ///
  /// Default ratio 0.55 — produces well-proportioned image areas.
  static double heightRatio(double containerWidth, {double ratio = 0.55}) {
    return containerWidth * ratio;
  }

  /// Decorative element size: picks [small] or [large] based on
  /// screen tier (small phones vs. the rest).
  static double decorSize(
    BuildContext context, {
    required double small,
    required double large,
  }) {
    return getMobileSize(context) == MobileSize.small ? small : large;
  }
}

/// Extension methods on `num` (int and double) to easily create `SizedBox`,
/// `EdgeInsets`, and `BorderRadius` for dimensions, padding, and layout.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Hello'),
///     16.verticalSpace, // Creates SizedBox(height: 16)
///     Container(
///       padding: 8.paddingAll, // Creates EdgeInsets.all(8)
///       margin: 8.paddingAll, // Can also be used for margins
///       decoration: BoxDecoration(
///         borderRadius: 12.circularRadius, // Creates BorderRadius.circular(12)
///       ),
///       child: Text('World'),
///     ),
///     10.sizeSquare, // Creates SizedBox(width: 10, height: 10)
///   ],
/// )
/// ```
extension DimenExtensions on num {
  /// Returns a `SizedBox` with a height of this value.
  ///
  /// Example: `16.verticalSpace` -> `SizedBox(height: 16)`
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Returns a `SizedBox` with a width of this value.
  ///
  /// Example: `16.horizontalSpace` -> `SizedBox(width: 16)`
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Returns a `SizedBox` with width and height of this value.
  ///
  /// Example: `16.sizeSquare` -> `SizedBox(width: 16, height: 16)`
  SizedBox get sizeSquare => SizedBox(width: toDouble(), height: toDouble());

  /// Returns an `EdgeInsets.all` with this value.
  ///
  /// Example: `16.paddingAll` -> `EdgeInsets.all(16)`
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Returns an `EdgeInsets.symmetric` with this value for vertical padding.
  ///
  /// Example: `16.paddingVertical` -> `EdgeInsets.symmetric(vertical: 16)`
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Returns an `EdgeInsets.symmetric` with this value for horizontal padding.
  ///
  /// Example: `16.paddingHorizontal` -> `EdgeInsets.symmetric(horizontal: 16)`
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Returns an `EdgeInsets.only` with this value for top padding.
  ///
  /// Example: `16.paddingTop` -> `EdgeInsets.only(top: 16)`
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());

  /// Returns an `EdgeInsets.only` with this value for bottom padding.
  ///
  /// Example: `16.paddingBottom` -> `EdgeInsets.only(bottom: 16)`
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());

  /// Returns an `EdgeInsets.only` with this value for left padding.
  ///
  /// Example: `16.paddingLeft` -> `EdgeInsets.only(left: 16)`
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());

  /// Returns an `EdgeInsets.only` with this value for right padding.
  ///
  /// Example: `16.paddingRight` -> `EdgeInsets.only(right: 16)`
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());

  /// Returns a `BorderRadius.circular` with this value.
  ///
  /// Example: `16.circularRadius` -> `BorderRadius.circular(16)`
  BorderRadius get circularRadius => BorderRadius.circular(toDouble());
}
