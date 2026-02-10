---
trigger: always_on
---

# Scope B: UI & Design System

This scope provides guidelines for building consistent, responsive UIs in Flutter projects. Emphasize Material Design principles with custom theming for branding. Use composition for widgets, centralized theming for consistency, and responsive techniques for cross-platform support (mobile, tablet, desktop, web). This helps maintain a professional, user-friendly interface across devices.

## Theming and Colors
- **Centralized Theme:** Define a single `ThemeData` in a dedicated file (e.g., `lib/core/theme/app_theme.dart`). Extend with custom semantics using `ThemeExtension` for non-standard properties (e.g., success/warning colors).
- **Color Scheme:** Generate using `ColorScheme.fromSeed` for harmonious palettes. Support light/dark modes via `theme` and `darkTheme` in `MaterialApp`. Use system mode by default (`ThemeMode.system`).
  ```dart
  // Example
  MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
      textTheme: const TextTheme(displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold)),
    ),
    darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark)),
    home: const MyHomePage(),
  );
  ```
- **Color Usage:** Always source from `Theme.of(context).colorScheme` (e.g., `primary`, `secondary`). For semantics, use extensions (e.g., `Theme.of(context).extension<CustomColors>()!.success`).
- **Best Practices:** 
  - Avoid hardcoded colors; use theme properties.
  - Use `Color.withValues(alpha: 0.5)` instead of the deprecated `withOpacity(0.5)` for color opacity manipulation (Flutter 3.27+).
  - Ensure WCAG compliance: 4.5:1 contrast for normal text, 3:1 for large.
  - Follow 60-30-10 rule: 60% primary/neutral, 30% secondary, 10% accent.
  - Use complementary colors cautiously for accents.
  - Example Palette: Primary #0D47A1, Secondary #1976D2, Accent #FFC107, Neutral #212121, Background #FEFEFE.
- **Typography:** Define `TextTheme` in `ThemeData`. Use sans-serif fonts (e.g., via `google_fonts`). Map styles: headlines for headers, body for content, labels for buttons. Stress font sizes for emphasis (e.g., hero text).
  - Rule: Every `Text` widget must have `style: Theme.of(context).textTheme.bodyMedium` (or similar); use `copyWith` for overrides.
  - Hierarchy: Establish scales (e.g., displayLarge: 57pt bold, bodyMedium: 14pt). Line height: 1.4-1.6x font size. Limit families to 1-2; prioritize legibility.
  - Readability: 45-75 char line length; avoid all caps for long text.
  ```dart
  // Example scale
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
  ),
  ```
- **Component Themes:** Customize via properties like `appBarTheme`, `elevatedButtonTheme`.
- **Design Tokens:** Use `ThemeExtension` for customs.
  ```dart
  @immutable
  class MyColors extends ThemeExtension<MyColors> {
    const MyColors({required this.success, required this.danger});
    // copyWith and lerp implementations...
  }
  ```
- **Styling with WidgetStateProperty:** For state-based styles.
  ```dart
  ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color>((states) => states.contains(WidgetState.pressed) ? Colors.green : Colors.red));
  ```

## Responsive Design and Layout
- **Device Detection:** Use a utility class (e.g., `DeviceUtils`) with `MediaQuery` to classify screens: mobile (<600dp), tablet (600-1200dp), desktop (>1200dp). Ensure responsiveness across platforms.
- **Layout Techniques:**
  - Use `LayoutBuilder` or `MediaQuery` for adaptive UIs (e.g., grid columns: 2 on mobile, 4 on desktop).
  - Flexible Widgets: `Expanded`, `Flexible` for space distribution; `Wrap` for overflow.
  - Scrolling: `SingleChildScrollView` for fixed content; `ListView.builder` for dynamic lists.
  - Stacks: `Positioned` or `Align` for overlays.
  - Advanced: `OverlayPortal` for floating elements.
  ```dart
  // Overlay example
  OverlayPortal(controller: _controller, overlayChildBuilder: (context) => Positioned(...));
  ```
- **Dimensions and Spacing:** Maintain a centralized constants file (e.g., `lib/core/utils/dimensions.dart`) with static values for padding, spacing, radii (e.g., small: 8.0, medium: 16.0).
  - Rule: Use constants exclusively; avoid raw numbers.
- **Visual Enhancements:** 
  - Backgrounds: Subtle textures for premium feel.
  - Shadows: Soft, multi-layered for depth (e.g., cards).
  - Icons/Interactivity: Use icons for navigation; add glow/shadows to buttons/sliders. Buttons: Filled (primary), Outlined (secondary), Text (ghost).
  - UI Design: Intuitive interfaces following modern guidelines; provide navigation controls for multi-page apps.

### Mobile Responsive Guide (Multi Screen Size)
This subsection provides specific rules for handling the variety of mobile phone screen sizes (small phones like iPhone SE to large phones like iPhone 16 Pro Max / Samsung Ultra).

- **Mobile Breakpoints:** Classify mobile screens into sub-tiers for fine-grained adaptation:
  | Tier           | Width (dp)  | Example Devices                         |
  |----------------|-------------|-----------------------------------------|
  | `smallMobile`  | < 360       | iPhone SE (320), Galaxy S4 (360)        |
  | `mobile`       | 360 – 399   | Pixel 5 (393), iPhone 13 Mini (375)     |
  | `largeMobile`  | 400 – 599   | iPhone 16 Pro Max (430), Galaxy Ultra   |
  ```dart
  // Recommended helper — place in lib/core/utils/responsive.dart
  enum MobileSize { small, medium, large }

  MobileSize getMobileSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return MobileSize.small;
    if (width < 400) return MobileSize.medium;
    return MobileSize.large;
  }
  ```

- **Proportional Sizing Strategy:** Prefer relative/proportional dimensions over fixed pixel values for elements that must scale across phone sizes.
  - Use `MediaQuery.sizeOf(context).width` fractions for widget widths (e.g., card width = `screenWidth * 0.7`).
  - Use `FractionallySizedBox` for percentage-based container widths.
  - Keep fixed sizes only for small, invariant elements (icons, avatar circles, minimum touch targets of 48dp).
  ```dart
  // Card width that adapts to screen
  final screenWidth = MediaQuery.sizeOf(context).width;
  final cardWidth = screenWidth * 0.68; // ~68% of screen

  // FractionallySizedBox for responsive containers
  FractionallySizedBox(
    widthFactor: 0.9,
    child: MyCard(),
  );
  ```

- **Adaptive Padding & Spacing:** Scale horizontal padding based on screen width to prevent content from feeling cramped on small screens or too narrow on large ones.
  ```dart
  // Adaptive horizontal padding
  double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 16.0;
    if (width < 400) return 20.0;
    return 24.0;
  }
  ```

- **Text Scaling Safety:** Respect the user's system text scale factor but cap it to prevent overflow.
  ```dart
  // Clamp text scale to prevent layout breaks
  MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: MediaQuery.of(context).textScaler
          .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
    ),
    child: child,
  );
  ```
  - Always test with text scale 0.85× (small) and 1.3× (large).
  - Use `maxLines` + `overflow: TextOverflow.ellipsis` on all user-facing text.

- **Adaptive Grid & List Rules:**
  - **Grid columns:** Use `LayoutBuilder` to pick column count: 2 columns for `< 400dp`, 3 for `≥ 400dp` mobile.
  - **Horizontal lists:** Calculate item width proportionally (e.g., `screenWidth * 0.65`) so 1.3–1.5 items are visible, hinting at scroll.
  - **Grid aspect ratios:** Adjust `childAspectRatio` per tier to prevent overflow: taller ratios on narrow screens, wider on large.
  ```dart
  // Adaptive grid
  LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 400 ? 2 : 3;
      final ratio = constraints.maxWidth < 400 ? 0.55 : 0.65;
      return GridView.count(
        crossAxisCount: columns,
        childAspectRatio: ratio,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: items,
      );
    },
  );
  ```

- **Safe Touch Targets:** All interactive elements must have a minimum touch area of **48 × 48 dp** (Material guidelines). Use `SizedBox`, `ConstrainedBox`, or `IconButton` padding to enforce this, even if the visual element is smaller.

- **Image & Media Scaling:**
  - Use `BoxFit.cover` for hero/banner images to avoid letterboxing on different aspect ratios.
  - Provide `errorBuilder` and `loadingBuilder` on all `Image.network` calls.
  - Set image container heights proportionally (e.g., `screenWidth * 0.4`) rather than fixed pixels for cards.

- **Avoiding Common Overflow Issues:**
  - Wrap long text in `Flexible` or `Expanded` inside `Row` widgets.
  - Use `Flexible(child: SizedBox())` instead of bare `SizedBox(height: n)` for spacing in tight `Column` layouts.
  - Prefer `ConstrainedBox(constraints: BoxConstraints(maxHeight: ...))` over fixed `SizedBox(height: ...)` for containers whose content varies.
  - Always test on the **smallest supported device** (320dp width) to catch overflow early.

- **Testing Matrix:** Every screen/widget must be verified on at least:
  1. **Small phone:** 320dp width (e.g., iPhone SE simulator)
  2. **Standard phone:** 375–393dp width (e.g., iPhone 14 / Pixel 5)
  3. **Large phone:** 428–430dp width (e.g., iPhone 16 Pro Max)
  - Use Flutter DevTools or `MediaQuery` overrides in tests to simulate sizes.

## Widget Composition and Components
- **Composition Over Inheritance:** Build UIs from small, reusable widgets. Prefer private widget classes over helper methods. Break large `build()` into sub-widgets; use `const` constructors.
- **Immutability:** Widgets (esp. `StatelessWidget`) are immutable; rebuild tree on changes.
- **Performance:** Lazy loading for lists; offload to isolates via `compute()`. Avoid expensive ops in `build()`.
- **Forms and Inputs:** Use `flutter_form_builder` for complex forms. Configure `textCapitalization`, `keyboardType`; apply theme decorations.

## Assets and Images
- **Declaration:** List in `pubspec.yaml` under `assets:` (e.g., `- assets/images/`).
- **Usage:** `Image.asset` for locals; `Image.network` with loading/error builders for remotes. Use `cached_network_image` for caching. `ImageIcon` for customs.
  ```dart
  Image.network('https://example.com/image.png', errorBuilder: (context, error, stackTrace) => Icon(Icons.error));
  ```
- **Guidelines:** Ensure relevance, proper sizing, and licensing. Provide placeholders.

## Accessibility
- **Features:** High contrast, dynamic text scaling, semantic labels via `Semantics`.
- **Testing:** Use screen readers (TalkBack/VoiceOver); aim for inclusive design.

Adopt this design system to create polished, adaptable UIs. Review theme files first when joining a project to align with established styles.
