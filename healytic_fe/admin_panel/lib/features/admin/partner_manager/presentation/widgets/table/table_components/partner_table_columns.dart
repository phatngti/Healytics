import 'package:common/widgets/table/helper.dart';
import 'package:data_table_2/data_table_2.dart';

/// Column definitions for the partner verification table
class PartnerTableColumns {
  /// Column sizes optimized based on content length:
  /// - Provider Details: L (wide - contains avatar, name, and ID)
  /// - Business Type: M (medium - business type chip from API)
  /// - Submitted: M (medium - date and relative time)
  /// - Status: S (small - status chip)
  /// - Actions: S (small - action icons)
  static const List<TableColumnData> _columnDefinitions = [
    TableColumnData(label: 'Provider Details', size: ColumnSize.L),
    TableColumnData(label: 'Business Type', size: ColumnSize.M),
    TableColumnData(label: 'Submitted', size: ColumnSize.M),
    TableColumnData(label: 'Status', size: ColumnSize.S),
    TableColumnData(label: 'Actions', size: ColumnSize.S),
  ];

  static TableColumns get columns => TableColumns(columns: _columnDefinitions);
}
