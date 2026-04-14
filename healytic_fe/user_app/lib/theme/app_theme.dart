import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color? success;
  final Color? onSuccess;
  final Color? onSuccessContainer;
  final Color? warning;
  final Color? onWarning;
  final Color? onWarningContainer;
  final Color? info;
  final Color? onInfo;
  final Color? onInfoContainer;
  final Color? error;
  final Color? onError;
  final Color? onErrorContainer;

  const SemanticColors({
    required this.success,
    this.onSuccess,
    this.onSuccessContainer,
    required this.warning,
    required this.info,
    this.onWarning,
    this.onWarningContainer,
    this.onInfo,
    this.onInfoContainer,
    required this.error,
    this.onError,
    this.onErrorContainer,
  });

  @override
  SemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? onInfoContainer,
    Color? error,
    Color? onError,
    Color? onErrorContainer,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      onSuccess: onSuccess ?? this.onSuccess,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      onWarning: onWarning ?? this.onWarning,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      onInfo: onInfo ?? this.onInfo,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
    );
  }

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) {
      return this;
    }
    return SemanticColors(
      success: Color.lerp(success, other.success, t),
      warning: Color.lerp(warning, other.warning, t),
      info: Color.lerp(info, other.info, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      ),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      ),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t),
    );
  }
}

class AppTheme {
  AppTheme();

  // Primary font family (replace with your custom font if needed)
  static const String _fontFamily =
      'Roboto'; // Or use GoogleFonts: 'Inter', 'Poppins', etc.

  // Base text theme using Material 3 typography scale
  static TextTheme lightTextTheme =
      const TextTheme(
        // App bar styles
        // largeTitle: TextStyle(
        //   fontFamily: _fontFamily,
        //   fontSize: 34,
        //   fontWeight: FontWeight.bold,
        //   height: 1.29,
        // ),

        // Display styles (large headings)
        displayLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w400,
          height: 1.22,
        ),

        // Headline styles
        headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w400,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w400,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          height: 1.33,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1.50,
        ),
        titleSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
        ),

        // Body text
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
        ),

        // Label styles (buttons, chips, etc.)
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ).apply(
        // Optional: Use Google Fonts or custom font
        bodyColor: Colors.black87,
        displayColor: Colors.black,
      );

  // Dark mode variant
  static TextTheme darkTextTheme = lightTextTheme.apply(
    bodyColor: Colors.white70,
    displayColor: Colors.white,
  );

  ThemeData lightTheme() {
    final base = FlexThemeData.light(
      scheme: FlexScheme.aquaBlue,
      // Input color modifiers.
      useMaterial3ErrorColors: true,
      // Component theme configurations for light mode.
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        useM2StyleDividerInM3: true,
        adaptiveRadius: FlexAdaptive.all(),
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
      ),
      textTheme: lightTextTheme,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surfaceBright.withValues(
        alpha: 0.8,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: base.colorScheme.surfaceBright.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
      ),
      extensions: <ThemeExtension<dynamic>>[
        SemanticColors(
          success: const Color.fromARGB(255, 130, 226, 196),
          onSuccess: Colors.white,
          onSuccessContainer: const Color.fromARGB(255, 81, 223, 88),
          warning: Colors.orange,
          onWarning: Colors.white,
          onWarningContainer: Colors.orange.shade300,
          info: Colors.blue,
          onInfo: Colors.white,
          onInfoContainer: Colors.blue.shade300,
          error: Colors.red,
          onError: Colors.white,
          onErrorContainer: Colors.red.shade300,
        ),
      ],
    );
  }

  ThemeData darkTheme() {
    final base = FlexThemeData.dark(
      colors: FlexColor.schemes[FlexScheme.deepPurple]!.light.defaultError
          .toDark(10, true),
      swapLegacyOnMaterial3: true,
      swapColors: true,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        splashType: FlexSplashType.inkSparkle,
        defaultRadius: 10.0,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
      ),
      textTheme: darkTextTheme,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    );
    return base.copyWith(
      scaffoldBackgroundColor: base.colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: base.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      extensions: <ThemeExtension<dynamic>>[
        SemanticColors(
          success: Colors.green,
          warning: Colors.orange,
          info: Colors.blue,
          error: Colors.red,
        ),
      ],
    );
  }
}
