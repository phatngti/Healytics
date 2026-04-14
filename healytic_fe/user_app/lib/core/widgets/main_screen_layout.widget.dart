import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Standardised layout wrapper for all bottom
/// navigation tab screens.
///
/// Ensures visual consistency across every tab:
/// - Unified `colorScheme.surface` background.
/// - Centred [AppBar] with optional leading,
///   title, and trailing action widgets.
/// - Text-scale clamping (0.8× – 1.3×).
/// - [SafeArea] handling.
/// - Optional [floatingActionButton] slot.
///
/// Set [useAppBar] to `false` for screens that
/// need a fully custom header (e.g. Home).
class MainScreenLayout extends StatelessWidget {
  /// Creates a [MainScreenLayout].
  const MainScreenLayout({
    super.key,
    required this.body,
    this.title,
    this.leading,
    this.actions,
    this.useAppBar = true,
    this.floatingActionButton,
    this.appBar,
  });

  /// The main body content widget.
  final Widget body;

  /// Text shown in the centred [AppBar] title.
  ///
  /// Ignored when [useAppBar] is `false` or
  /// when [appBar] is provided.
  final String? title;

  /// Optional leading widget for the [AppBar].
  ///
  /// Ignored when [useAppBar] is `false` or
  /// when [appBar] is provided.
  final Widget? leading;

  /// Optional trailing action widgets for the
  /// [AppBar].
  ///
  /// Ignored when [useAppBar] is `false` or
  /// when [appBar] is provided.
  final List<Widget>? actions;

  /// Whether to render the standardised [AppBar].
  ///
  /// Set to `false` for screens with fully
  /// custom headers (e.g. Home screen).
  final bool useAppBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional fully custom [PreferredSizeWidget]
  /// app bar. Overrides [title], [leading], and
  /// [actions] when provided.
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _resolveAppBar(context, colorScheme),
      body: SafeArea(
        top: !useAppBar && appBar == null,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
          ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Builds the appropriate [AppBar] based on
  /// the widget configuration.
  PreferredSizeWidget? _resolveAppBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    if (appBar != null) return appBar;
    if (!useAppBar) return null;
    return _StandardAppBar(title: title, leading: leading, actions: actions);
  }
}

/// The standardised app bar used across all
/// navigation tab screens.
///
/// Provides a consistent visual appearance:
/// - Centred title with semi-bold weight.
/// - Subtle bottom border.
/// - Standard icon sizing and spacing.
class _StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _StandardAppBar({this.title, this.leading, this.actions});

  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: title != null
          ? Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: AppDimens.fontWeightSemiBold,
              ),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppDimens.borderWidth),
        child: Container(
          height: AppDimens.borderWidth,
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
