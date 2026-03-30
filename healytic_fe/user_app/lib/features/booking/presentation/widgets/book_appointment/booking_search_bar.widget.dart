import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import '../../../domain/entities/booking.entity.dart';
import '../../providers/booking.provider.dart';

/// A search bar that queries the backend for
/// services and specialists, then shows results
/// in a two-section dropdown popup.
class BookingSearchBar extends ConsumerStatefulWidget {
  const BookingSearchBar({
    super.key,
    this.onServiceSelected,
    this.onSpecialistSelected,
    this.hintText =
        'Search services or'
        ' specialists...',
  });

  /// Called when the user taps a service result.
  final ValueChanged<BookingService>? onServiceSelected;

  /// Called when the user taps a specialist result.
  final ValueChanged<BookingSpecialist>? onSpecialistSelected;

  /// Placeholder text shown when the field is
  /// empty.
  final String hintText;

  @override
  ConsumerState<BookingSearchBar> createState() => _BookingSearchBarState();
}

class _BookingSearchBarState extends ConsumerState<BookingSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  BookingSearchResult _results = const BookingSearchResult();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) _removeOverlay();
  }

  Future<void> _onQueryChanged(String query) async {
    final normalised = query.trim();
    if (normalised.isEmpty) {
      _removeOverlay();
      setState(() {
        _results = const BookingSearchResult();
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    _showOverlay();

    final result = await ref.read(searchBookingProvider(normalised).future);

    if (!mounted) return;
    setState(() {
      _results = result;
      _isLoading = false;
    });
    _showOverlay();
  }

  void _onServiceTapped(BookingService service) {
    _controller.clear();
    _removeOverlay();
    _focusNode.unfocus();
    setState(() {
      _results = const BookingSearchResult();
    });
    widget.onServiceSelected?.call(service);
  }

  void _onSpecialistTapped(BookingSpecialist specialist) {
    _controller.clear();
    _removeOverlay();
    _focusNode.unfocus();
    setState(() {
      _results = const BookingSearchResult();
    });
    widget.onSpecialistSelected?.call(specialist);
  }

  // ── Overlay management ────────────────────────

  void _showOverlay() {
    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => _SearchResultsOverlay(
        link: _layerLink,
        width: size.width,
        results: _results,
        isLoading: _isLoading,
        onServiceTap: _onServiceTapped,
        onSpecialistTap: _onSpecialistTapped,
        onDismiss: _removeOverlay,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  // ── Build ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        // height: 48,
        decoration: BoxDecoration(
          color: _focusNode.hasFocus
              ? colorScheme.surface
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _focusNode.hasFocus
                ? colorScheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onQueryChanged,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Icon(
                Symbols.search,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    icon: const Icon(Symbols.cancel, size: 18),
                    onPressed: () {
                      _controller.clear();
                      _removeOverlay();
                      setState(() {
                        _results = const BookingSearchResult();
                      });
                    },
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 42),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.only(top: 12),
          ),
        ),
      ),
    );
  }
}

// ─── Overlay dropdown ───────────────────────────

/// Floating dropdown with two scrollable sections:
/// **Specialists** and **Services**.
class _SearchResultsOverlay extends StatefulWidget {
  const _SearchResultsOverlay({
    required this.link,
    required this.width,
    required this.results,
    required this.isLoading,
    required this.onServiceTap,
    required this.onSpecialistTap,
    required this.onDismiss,
  });

  final LayerLink link;
  final double width;
  final BookingSearchResult results;
  final bool isLoading;
  final ValueChanged<BookingService> onServiceTap;
  final ValueChanged<BookingSpecialist> onSpecialistTap;
  final VoidCallback onDismiss;

  @override
  State<_SearchResultsOverlay> createState() => _SearchResultsOverlayState();
}

class _SearchResultsOverlayState extends State<_SearchResultsOverlay> {
  // 0 = Services, 1 = Specialists
  int _selectedTabIndex = 0;

  // Track selected card locally before hitting continue
  dynamic _selectedItem;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxHeight = screenHeight * 0.5;

    return Stack(
      children: [
        // Dismiss tap-away barrier.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onDismiss,
          ),
        ),

        // Popup content.
        CompositedTransformFollower(
          link: widget.link,
          offset: const Offset(0, 60),
          showWhenUnlinked: false,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.width,
                maxHeight: maxHeight,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabs(context, colorScheme),
                    Flexible(child: _buildBody(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs(BuildContext context, ColorScheme colorScheme) {
    final backgroundColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.3,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        AppDimens.spaceLg,
        AppDimens.spaceLg,
        0,
      ),
      color: Colors.white,
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabButton(
                backgroundColor: backgroundColor,
                title: 'Services',
                isSelected: _selectedTabIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 0;
                    if (_selectedItem is BookingSpecialist) {
                      _selectedItem = null; // Clear if switching tabs
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: _TabButton(
                backgroundColor: backgroundColor,
                title: 'Specialists',
                isSelected: _selectedTabIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedTabIndex = 1;
                    if (_selectedItem is BookingService) {
                      _selectedItem = null; // Clear if switching tabs
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.isLoading) {
      return Padding(
        padding: EdgeInsets.all(AppDimens.spaceLg),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (widget.results.isEmpty) return _EmptyState();

    final specs = widget.results.specialists;
    final svcs = widget.results.services;

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceSmMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Services Tab ──────────
            if (_selectedTabIndex == 0 && svcs.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: svcs.length,
                itemBuilder: (_, i) {
                  final service = svcs[i];
                  return _ServiceTile(
                    service: service,
                    isSelected: _selectedItem == service,
                    onTap: () {
                      setState(() => _selectedItem = service);
                      widget.onServiceTap(service);
                    },
                  );
                },
              ),

            if (_selectedTabIndex == 0 && svcs.isEmpty)
              Padding(
                padding: EdgeInsets.all(AppDimens.spaceLg),
                child: Center(child: Text('No services found')),
              ),

            // ── Specialists Tab ────────────
            if (_selectedTabIndex == 1 && specs.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: specs.length,
                itemBuilder: (_, i) {
                  final spec = specs[i];
                  return _SpecialistTile(
                    specialist: spec,
                    isSelected: _selectedItem == spec,
                    onTap: () {
                      setState(() => _selectedItem = spec);
                      widget.onSpecialistTap(spec);
                    },
                  );
                },
              ),

            if (_selectedTabIndex == 1 && specs.isEmpty)
              Padding(
                padding: EdgeInsets.all(AppDimens.spaceLg),
                child: Center(child: Text('No specialists found')),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared sub-widgets ─────────────────────────

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.backgroundColor,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final Color backgroundColor;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : backgroundColor,
          borderRadius: isSelected ? BorderRadius.circular(8) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// "No results" placeholder.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(AppDimens.spaceLg),
      child: Row(
        children: [
          Icon(
            Symbols.search_off,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: AppDimens.iconMd,
          ),
          SizedBox(width: AppDimens.spaceSm),
          Text(
            'No results found',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single specialist result row.
class _SpecialistTile extends StatelessWidget {
  const _SpecialistTile({
    required this.specialist,
    required this.isSelected,
    required this.onTap,
  });

  final BookingSpecialist specialist;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppDimens.spaceSm),
        padding: EdgeInsets.all(AppDimens.spaceLg),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.person,
                size: 24,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: AppDimens.spaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    specialist.specialty,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Symbols.radio_button_checked
                  : Symbols.radio_button_unchecked,
              size: 24,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  final BookingService service;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppDimens.spaceSm),
        padding: EdgeInsets.all(AppDimens.spaceLg),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.health_and_safety,
                size: 24,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: AppDimens.spaceLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimens.spaceXxs),
                  Text(
                    service.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
