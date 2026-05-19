import 'package:flutter/material.dart';

import '../../../../common/widgets/responsive/responsive.dart';
import '../widgets/bookings_dashboard.widget.dart';

/// Route-level widget for the partner bookings page.
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrapper(
      useLayout: true,
      desktop: _ClampedTextScaleScope(child: BookingsDashboard()),
      tablet: _ClampedTextScaleScope(child: BookingsDashboard()),
      mobile: _ClampedTextScaleScope(child: BookingsDashboard()),
    );
  }
}

/// Clamps the inherited [MediaQuery] text scaler to the
/// range `[0.8, 1.3]` so descendant widgets never receive
/// an extreme scale factor that would break the grid layout.
///
/// Uses [MediaQuery.textScalerOf] to read the current scaler
/// and [TextScaler.clamp] to enforce bounds before injecting
/// the clamped value back into the subtree.
class _ClampedTextScaleScope extends StatelessWidget {
  const _ClampedTextScaleScope({required this.child});

  final Widget child;

  /// Minimum text scale factor allowed.
  static const double _minScale = 0.8;

  /// Maximum text scale factor allowed.
  static const double _maxScale = 1.3;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final clamped = scaler.clamp(
      minScaleFactor: _minScale,
      maxScaleFactor: _maxScale,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clamped),
      child: child,
    );
  }
}
