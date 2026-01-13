import 'package:admin_panel/utils/demensions.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class TableColumnData {
  const TableColumnData({required this.label, this.prefixIcon});

  final String label;
  final IconData? prefixIcon;
}

class TableColumns {
  const TableColumns({required this.columns});

  final List<TableColumnData> columns;

  List<DataColumn> dataColumns(BuildContext context) {
    return columns
        .map(
          (column) => DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.0),
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

typedef GetDataCallback =
    Future<List<DataRow>> Function(
      void Function(LocalKey, bool) setRowSelection,
      int startingAt,
      int count,
    );

typedef SetRowSelectionCallback = void Function(LocalKey, bool);
typedef ActionButtonCallback = void Function(LocalKey?);

class AppDataTableSource extends AsyncDataTableSource {
  final Future<int> Function() getTotalRows;
  final GetDataCallback getData;

  final Map<int, List<DataRow>> _cachedRows = {};

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
