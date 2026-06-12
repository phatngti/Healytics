import 'package:flutter/material.dart';

/// Centralized layout constants for the dashboard.
///
/// Consolidates breakpoints, flex ratios, and grid
/// configurations to avoid scattering magic numbers
/// across widget files.
class DashboardLayout {
  DashboardLayout._();

  /// Width threshold for switching to wide
  /// (two-column) layout.
  static const double wideBreakpoint = 900;

  /// Width threshold for single-column quick
  /// action grid.
  static const double singleColumnBreakpoint = 440;

  // --- Flex Ratios ---

  /// Revenue chart flex in wide layout.
  static const int revenueChartFlex = 7;

  /// Quick actions flex in wide layout.
  static const int quickActionsFlex = 3;

  /// Service performance flex in wide layout.
  static const int servicePerformanceFlex = 6;

  /// Employee overview flex in wide layout.
  static const int employeeOverviewFlex = 4;

  /// Staff schedule flex inside the operations
  /// dashboard section.
  static const int operationsScheduleFlex = 5;

  /// Notification center flex inside the
  /// operations dashboard section.
  static const int operationsNotificationFlex = 4;

  /// Width threshold for showing inventory alert
  /// cards in two columns.
  static const double inventoryGridBreakpoint = 720;

  /// Width threshold for showing inventory alert
  /// cards in three columns.
  static const double inventoryGridWideBreakpoint = 1100;

  // --- KPI Grid ---

  /// Columns on wide screens.
  static const int kpiColumnsWide = 4;

  /// Columns on narrow screens.
  static const int kpiColumnsNarrow = 2;

  /// Aspect ratio on wide screens.
  static const double kpiRatioWide = 1.8;

  /// Aspect ratio on narrow screens.
  static const double kpiRatioNarrow = 1.5;

  /// Quick action grid columns on wide.
  static const int actionColumnsWide = 2;

  /// Quick action grid columns on narrow.
  static const int actionColumnsNarrow = 1;
}

/// Dashboard-specific component sizes.
///
/// For values that don't map cleanly to
/// `AppDimens` global constants.
class DashboardSizes {
  DashboardSizes._();

  /// Section header icon container (dp).
  static const double sectionIconContainer = 36;

  /// Notification / inventory icon container (dp).
  static const double iconContainer = 42;

  /// Revenue line chart height (dp).
  static const double chartHeight = 250;

  /// Service performance bar chart height (dp).
  static const double barChartHeight = 220;

  /// Donut chart width and height (dp).
  static const double donutChartSize = 160;

  /// Donut chart center space radius (dp).
  static const double donutCenterRadius = 40;

  /// Donut chart section radius (dp).
  static const double donutSectionRadius = 28;

  /// Legend indicator dot size (dp).
  static const double legendDotSize = 10;

  /// Quick action button fixed height (dp).
  static const double actionButtonHeight = 56;

  /// Schedule timeline color bar width (dp).
  static const double scheduleBarWidth = 6;

  /// Schedule timeline color bar height (dp).
  static const double scheduleBarHeight = 64;

  /// Unread notification dot size (dp).
  static const double unreadDotSize = 8;

  /// Bar chart bar rod width (dp).
  static const double barRodWidth = 20;

  /// Panel shadow blur radius.
  static const double panelBlurRadius = 18;

  /// Panel shadow y-offset.
  static const Offset panelShadowOffset = Offset(0, 8);

  /// Table overhead height for AppTable
  /// (header + paginator + padding).
  static const double tableOverhead = 240;

  /// Table row height.
  static const double tableRowHeight = 56;

  /// Minimum table height when empty.
  static const double tableMinHeight = 320;

  /// Loading/error state padding.
  static const double statePadding = 48;
}

/// Dashboard-specific palette colors.
///
/// Chart and role colors that are unique to
/// the dashboard feature and don't belong in
/// global `SemanticColors`.
class DashboardColors {
  DashboardColors._();

  /// Color palette for employee role distribution
  /// chart slices and schedule bars.
  static const List<Color> roleColors = [
    Color(0xFF4F46E5), // Doctor / Indigo
    Color(0xFF0EA5E9), // Spa Therapist / Sky
    Color(0xFF10B981), // Massage Therapist / Emerald
    Color(0xFFF59E0B), // Receptionist / Amber
    Color(0xFFEF4444), // On Leave / Red
  ];

  /// Star rating fill color.
  static const Color starRating = Color(0xFFFBBF24);

  /// Info / system notification accent.
  static const Color infoBlue = Color(0xFF0EA5E9);

  /// Confirmed status color.
  static const Color confirmed = Color(0xFF16A34A);

  /// Pending / warning status color.
  static const Color pending = Color(0xFFEA8C00);

  /// Role-name to color map for schedule bars.
  static const Map<String, Color> roleColorMap = {
    'Doctor': Color(0xFF4F46E5),
    'Spa Therapist': Color(0xFF0EA5E9),
    'Massage Therapist': Color(0xFF10B981),
  };
}
