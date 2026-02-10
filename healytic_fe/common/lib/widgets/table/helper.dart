import 'package:common/utils/demensions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

/// Describes a single column in an [AppTable].
///
/// Holds the header [label], an optional [prefixIcon], and a [size]
/// hint for the column width.
class TableColumnData {
  /// Creates a [TableColumnData].
  const TableColumnData({
    required this.label,
    this.prefixIcon,
    this.size = ColumnSize.M,
  });

  /// The column header text.
  final String label;

  /// Optional icon displayed before the label text.
  final IconData? prefixIcon;

  /// Column size hint: [ColumnSize.S] (small), [ColumnSize.M] (medium),
  /// or [ColumnSize.L] (large).
  final ColumnSize size;
}

/// A collection of [TableColumnData] that can be converted into
/// [DataColumn2] widgets for use with [AsyncPaginatedDataTable2].
class TableColumns {
  /// Creates a [TableColumns] from a list of column definitions.
  const TableColumns({required this.columns});

  /// The list of column definitions.
  final List<TableColumnData> columns;

  List<DataColumn> dataColumns(BuildContext context) {
    return columns
        .map(
          (column) => DataColumn2(
            size: column.size,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (column.prefixIcon != null) ...[
                  Icon(column.prefixIcon),
                  AppDimens.horizontalSmall,
                ],
                Flexible(
                  child: Text(
                    column.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            headingRowAlignment: MainAxisAlignment.start,
          ),
        )
        .toList();
  }
}

/// Callback type for fetching a page of table rows.
///
/// - [setRowSelection] — Function to toggle row selection state.
/// - [startingAt] — Zero-based index of the first row to fetch.
/// - [count] — Number of rows to fetch.
typedef GetDataCallback =
    Future<List<DataRow>> Function(
      void Function(LocalKey, bool) setRowSelection,
      int startingAt,
      int count,
    );

/// Callback type for setting the selection state of a single row.
typedef SetRowSelectionCallback = void Function(LocalKey, bool);

/// Callback type for action buttons that operate on a selected row (or none).
typedef ActionButtonCallback = void Function(LocalKey?);

/// An [AsyncDataTableSource] that provides paginated data to
/// [AsyncPaginatedDataTable2], with page-level caching.
///
/// Fetches rows via [getData] and caches them by page start index.
/// Call [refreshDatasource] to clear the cache and re-fetch.
class AppDataTableSource extends AsyncDataTableSource {
  /// Async callback returning the total number of rows.
  final Future<int> Function() getTotalRows;

  /// Async callback fetching rows for a given page.
  final GetDataCallback getData;

  /// Page-level cache keyed by the starting row index.
  final Map<int, List<DataRow>> _cachedRows = {};

  /// Creates an [AppDataTableSource].
  AppDataTableSource({required this.getTotalRows, required this.getData});

  bool _mounted = true;

  @override
  // ignore: must_call_super
  void dispose() {
    _mounted = false;
    // super.dispose();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startingAt, int count) async {
    if (!_mounted) return AsyncRowsResponse(0, []);
    if (_cachedRows.containsKey(startingAt)) {
      final cached = _cachedRows[startingAt]!;
      if (cached.length >= count) {
        final totalRows = await getTotalRows();
        if (!_mounted) return AsyncRowsResponse(0, []);
        return AsyncRowsResponse(totalRows, cached.take(count).toList());
      }

      final totalRows = await getTotalRows();
      if (!_mounted) return AsyncRowsResponse(0, []);
      if (cached.length < count && startingAt + cached.length == totalRows) {
        return AsyncRowsResponse(totalRows, cached);
      }
    }

    final totalRows = await getTotalRows();
    if (!_mounted) return AsyncRowsResponse(0, []);
    final rows = await getData(setRowSelection, startingAt, count);
    if (!_mounted) return AsyncRowsResponse(0, []);
    _cachedRows[startingAt] = rows;
    return AsyncRowsResponse(totalRows, rows);
  }

  @override
  void refreshDatasource() {
    _cachedRows.clear();
    super.refreshDatasource();
  }
}
