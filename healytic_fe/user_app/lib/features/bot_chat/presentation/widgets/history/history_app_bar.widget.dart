import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';

/// Custom app bar for the conversation history page.
///
/// Displays a back arrow, centred "Chat History" title, and a
/// search‐toggle icon. When search is active the title is replaced
/// by a [TextField] and the icon switches to a close button.
///
/// Implements [PreferredSizeWidget] so it can be used directly as
/// [Scaffold.appBar].
class HistoryAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Callback invoked whenever the search text changes.
  final ValueChanged<String> onSearchChanged;

  /// External controller for the search field — owned by the page
  /// so it can read/clear the value.
  final TextEditingController searchController;

  const HistoryAppBar({
    super.key,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<HistoryAppBar> createState() => _HistoryAppBarState();
}

class _HistoryAppBarState extends State<HistoryAppBar> {
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        widget.searchController.clear();
        widget.onSearchChanged('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPadding = AppDimens.horizontalPadding(context);

    return SafeArea(
      bottom: false,
      child: Container(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.05),
              width: AppDimens.borderWidth,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: AppDimens.spaceXs,
              offset: Offset(0, AppDimens.spaceXxs),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Back button ──
            AppButton(
              buttonType: ButtonType.text,
              onPressed: () => Navigator.of(context).pop(),
              primaryColor: colorScheme.onSurface,
              customStyle: TextButton.styleFrom(
                padding: EdgeInsets.all(AppDimens.spaceSm),
                minimumSize: Size(AppDimens.touchTarget, AppDimens.touchTarget),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
              ),
              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurface,
                size: AppDimens.iconLg,
              ),
            ),
            SizedBox(width: AppDimens.spaceSm),

            // ── Title or search field ──
            Expanded(
              child: _isSearching
                  ? TextField(
                      controller: widget.searchController,
                      autofocus: true,
                      onChanged: widget.onSearchChanged,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search conversations...',
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppDimens.spaceSm,
                        ),
                      ),
                    )
                  : Text(
                      'Chat History',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: AppDimens.fontWeightSemiBold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            SizedBox(width: AppDimens.spaceSm),

            // ── Search toggle ──
            AppButton(
              buttonType: ButtonType.text,
              onPressed: _toggleSearch,
              primaryColor: colorScheme.primary,
              customStyle: TextButton.styleFrom(
                padding: EdgeInsets.all(AppDimens.spaceSm),
                minimumSize: Size(AppDimens.touchTarget, AppDimens.touchTarget),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
              ),
              child: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: colorScheme.primary,
                size: AppDimens.iconLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
