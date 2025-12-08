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
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (column.prefixIcon != null) ...[
                  Icon(column.prefixIcon),
                  AppDimens.horizontalSmall,
                ],
                Text(
                  column.label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            headingRowAlignment: MainAxisAlignment.center,
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

  @override
  Future<AsyncRowsResponse> getRows(int startingAt, int count) async {
    if (_cachedRows.containsKey(startingAt)) {
      final cached = _cachedRows[startingAt]!;
      if (cached.length >= count) {
        final totalRows = await getTotalRows();
        return AsyncRowsResponse(totalRows, cached.take(count).toList());
      }

      final totalRows = await getTotalRows();
      if (cached.length < count && startingAt + cached.length == totalRows) {
        return AsyncRowsResponse(totalRows, cached);
      }
    }

    final totalRows = await getTotalRows();
    final rows = await getData(setRowSelection, startingAt, count);
    _cachedRows[startingAt] = rows;
    return AsyncRowsResponse(totalRows, rows);
  }

  @override
  void refreshDatasource() {
    _cachedRows.clear();
    super.refreshDatasource();
  }
}
