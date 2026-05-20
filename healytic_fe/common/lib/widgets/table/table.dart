import 'dart:async';

import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/search_field.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:common/widgets/table/helper.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/utils/responsive.dart';

import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

/// A paginated, async data table with built-in search, action buttons,
/// function buttons, and error/loading states.
///
/// Wraps [AsyncPaginatedDataTable2] and provides a standard table layout
/// with a [TableHeaderWidget] for search and actions, automatic data source
/// caching via [AppDataTableSource], and retry-on-error support.
///
/// The search field is rendered **above** the table in a separate
/// [Column] so that [PaginatedDataTable2]'s internal gesture
/// detectors do not block user input.
///
/// ```dart
/// AppTable(
///   columns: myColumns.dataColumns(context),
///   getTotalRows: () => myRepo.count(),
///   getData: (setSelection, start, count) => myRepo.fetchRows(start, count),
///   onSearchChanged: (query) => /* filter */,
/// )
/// ```
class AppTable extends StatefulWidget {
  /// Creates an [AppTable].
  const AppTable({
    super.key,
    this.functionButtons,
    this.onSearchChanged,
    this.searchFieldKey,
    this.refreshToken,
    this.buttons,
    required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.actions,
    this.defaultRowsPerPage = PaginatedDataTable.defaultRowsPerPage,
    this.actionButtons = false,
    required this.getTotalRows,
    required this.getData,
    this.height,
  });

  /// Optional function buttons shown in the table header (dropdown menus).
  final List<TableFunctionButtonWidget>? functionButtons;

  /// Callback invoked when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Optional key applied to the search [TextField].
  final Key? searchFieldKey;

  /// Optional token that invalidates cached rows without remounting the table.
  final Object? refreshToken;

  /// Optional action buttons displayed in the table header.
  final List<AppButton>? buttons;

  /// Column definitions for the data table.
  final List<DataColumn> columns;

  /// The initial column index used for sorting.
  final int? sortColumnIndex;

  /// Whether sorting is ascending (defaults to `true`).
  final bool sortAscending;

  /// Additional action widgets placed above the table.
  final List<Widget>? actions;

  /// Number of rows per page (defaults to [PaginatedDataTable.defaultRowsPerPage]).
  final int defaultRowsPerPage;

  /// Whether to show action buttons in the header.
  final bool actionButtons;

  /// Async callback that returns the total number of rows.
  final Future<int> Function() getTotalRows;

  /// Async callback that fetches a page of [DataRow] items.
  final GetDataCallback getData;

  /// Optional fixed height for the table container.
  final double? height;

  @override
  State<AppTable> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable>
    with AutomaticKeepAliveClientMixin {
  late int _rowsPerPage;
  late AppDataTableSource _source;
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _rowsPerPage = widget.defaultRowsPerPage;
    _source = AppDataTableSource(
      getTotalRows: widget.getTotalRows,
      getData: widget.getData,
    );
  }

  @override
  void didUpdateWidget(covariant AppTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _source.updateCallbacks(
      getTotalRows: widget.getTotalRows,
      getData: widget.getData,
    );

    if (oldWidget.refreshToken != widget.refreshToken) {
      _source.refreshDatasource();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _source.dispose();
    super.dispose();
  }

  /// Whether the header row has any visible content
  /// (buttons or function buttons).
  bool get _hasHeaderContent =>
      (widget.functionButtons?.isNotEmpty ?? false) ||
      (widget.buttons?.isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    // Create a local copy so we never mutate
    // widget.columns on rebuild.
    final columns = [...widget.columns];
    if (widget.actionButtons) {
      columns.add(
        DataColumn(
          label: Center(
            child: Text(
              'Action',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: AppDimens.paddingAllSmall,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search + buttons row — rendered OUTSIDE
          // PaginatedDataTable2 so TextField receives
          // taps without being blocked by DataTable2's
          // internal gesture detectors.
          _buildSearchRow(context),
          Expanded(child: _buildTable(context, columns)),
        ],
      ),
    );
  }

  /// Builds the search field + action buttons row above
  /// the table. Lives outside [AsyncPaginatedDataTable2]
  /// so taps are never intercepted.
  Widget _buildSearchRow(BuildContext context) {
    if (widget.onSearchChanged == null && !_hasHeaderContent) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: AppDimens.paddingAllSmall,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.onSearchChanged != null)
            SizedBox(
              width: responsive<double>(
                context,
                mobile: 200,
                tablet: 250,
                web: 300,
              ),
              child: AppSearchField(
                fieldKey: widget.searchFieldKey,
                onChanged: widget.onSearchChanged,
              ),
            )
          else
            const SizedBox.shrink(),
          Row(
            children: [
              if (widget.functionButtons != null)
                for (var btn in widget.functionButtons!) ...[
                  AppDimens.horizontalSmall,
                  btn,
                ],
              if (widget.buttons != null)
                for (var btn in widget.buttons!) ...[
                  AppDimens.horizontalSmall,
                  btn,
                ],
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the [AsyncPaginatedDataTable2] without a
  /// header — search is handled by [_buildSearchRow].
  Widget _buildTable(BuildContext context, List<DataColumn> columns) {
    return AsyncPaginatedDataTable2(
      horizontalMargin: 20,
      checkboxHorizontalMargin: 12,
      columnSpacing: 0,
      wrapInCard: false,
      // No header — search + buttons are above.
      actions: widget.actions,
      rowsPerPage: _rowsPerPage,
      availableRowsPerPage: {
        _rowsPerPage,
        widget.defaultRowsPerPage,
        widget.defaultRowsPerPage * 2,
        widget.defaultRowsPerPage * 3,
        widget.defaultRowsPerPage * 4,
      }.toList()..sort(),
      minWidth: responsive<double>(context, mobile: 500, web: 800),
      fit: FlexFit.tight,
      border: TableBorder(
        top: BorderSide(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
        ),
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
        ),
        left: BorderSide(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
        ),
        right: BorderSide(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
        ),
        horizontalInside: BorderSide(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
        ),
        borderRadius: AppDimens.radiusLarge,
      ),
      onRowsPerPageChanged: (value) {
        if (value != null && value != _rowsPerPage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _rowsPerPage = value;
              });
            }
          });
        }
      },
      onPageChanged: (rowIndex) {
        debugPrint('Table page changed to row $rowIndex');
      },
      sortColumnIndex: widget.sortColumnIndex,
      sortAscending: widget.sortAscending,
      sortArrowIcon: Icons.keyboard_arrow_up,
      sortArrowAnimationDuration: const Duration(milliseconds: 0),
      hidePaginator: false,
      columns: columns,
      empty: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          child: const Text('No data'),
        ),
      ),
      loading: _Loading(),
      errorBuilder: (e) =>
          _ErrorAndRetry(e.toString(), () => _source.refreshDatasource()),
      source: _source,
    );
  }
}

/// Displays an error message with a retry button when table data fails to load.
class _ErrorAndRetry extends StatelessWidget {
  /// Creates an [_ErrorAndRetry].
  const _ErrorAndRetry(this.errorMessage, this.retry);

  /// The error message to display.
  final String errorMessage;

  /// Callback invoked when the retry button is tapped.
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Oops! $errorMessage',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: retry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Retry',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// A loading overlay that shows a shade immediately, then reveals
/// a spinner with "Loading.." text after a 500ms delay to avoid flicker.
class _Loading extends StatefulWidget {
  @override
  __LoadingState createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(20),
      // at first show shade, if loading takes longer than 0,5s show spinner
      child: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 500), () => true),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const SizedBox()
              : Center(
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    width: 150,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        Text(
                          'Loading..',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
