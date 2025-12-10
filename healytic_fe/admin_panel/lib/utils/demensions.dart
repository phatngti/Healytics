import 'package:flutter/widgets.dart';

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

  /// SizedBox with a height of 8.0
  static const verticalSmall = SizedBox(height: 8.0);

  /// SizedBox with a height of 12.0
  static const verticalMediumSmall = SizedBox(height: 12.0);

  /// SizedBox with a height of 16.0
  static const verticalMedium = SizedBox(height: 16.0);

  /// SizedBox with a height of 24.0
  static const verticalLarge = SizedBox(height: 24.0);

  /// SizedBox with a height of 32.0
  static const verticalExtraLarge = SizedBox(height: 32.0);

  // --- Horizontal Spacing ---
  /// SizedBox with a width of 4.0
  static const horizontalExtraSmall = SizedBox(width: 4.0);

  /// SizedBox with a width of 8.0
  static const horizontalSmall = SizedBox(width: 8.0);

  /// SizedBox with a width of 12.0
  static const horizontalMediumSmall = SizedBox(width: 12.0);

  /// SizedBox with a width of 16.0
  static const horizontalMedium = SizedBox(width: 16.0);

  /// SizedBox with a width of 24.0
  static const horizontalLarge = SizedBox(width: 24.0);

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

  /// EdgeInsets.all(16.0)
  static const paddingAllMedium = EdgeInsets.all(16.0);

  /// EdgeInsets.all(24.0)
  static const paddingAllLarge = EdgeInsets.all(24.0);

  // Symmetric Vertical
  /// EdgeInsets.symmetric(vertical: 4.0)
  static const paddingVerticalExtraSmall = EdgeInsets.symmetric(vertical: 4.0);

  /// EdgeInsets.symmetric(vertical: 8.0)
  static const paddingVerticalSmall = EdgeInsets.symmetric(vertical: 8.0);

  /// EdgeInsets.symmetric(vertical: 16.0)
  static const paddingVerticalMedium = EdgeInsets.symmetric(vertical: 16.0);

  /// EdgeInsets.symmetric(vertical: 24.0)
  static const paddingVerticalLarge = EdgeInsets.symmetric(vertical: 24.0);

  // Symmetric Horizontal
  /// EdgeInsets.symmetric(horizontal: 4.0)
  static const paddingHorizontalExtraSmall = EdgeInsets.symmetric(
    horizontal: 4.0,
  );

  /// EdgeInsets.symmetric(horizontal: 8.0)
  static const paddingHorizontalSmall = EdgeInsets.symmetric(horizontal: 8.0);

  /// EdgeInsets.symmetric(horizontal: 16.0)
  static const paddingHorizontalMedium = EdgeInsets.symmetric(horizontal: 16.0);

  /// EdgeInsets.symmetric(horizontal: 24.0)
  static const paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: 24.0);

  // --- BorderRadius ---
  /// BorderRadius.circular(4.0)
  static const radiusExtraSmall = BorderRadius.all(Radius.circular(4.0));

  /// BorderRadius.circular(8.0)
  static const radiusSmall = BorderRadius.all(Radius.circular(8.0));

  /// BorderRadius.circular(16.0)
  static const radiusMedium = BorderRadius.all(Radius.circular(16.0));

  /// BorderRadius.circular(24.0)
  static const radiusLarge = BorderRadius.all(Radius.circular(24.0));

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
