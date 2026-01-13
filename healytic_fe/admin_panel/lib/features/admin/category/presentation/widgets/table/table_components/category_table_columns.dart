import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:flutter/material.dart';

class CategoryTableColumns {
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'Icon'},
    {'label': 'Category Name'},
    {'label': 'Description'},
    {'label': 'Total Services'},
    {'label': 'Status'},
    {'label': 'Actions'},
  ];

  static TableColumns get columns => TableColumns(
    columns: _columnDefinitions
        .map(
          (column) => TableColumnData(
            label: column['label'].toString(),
            prefixIcon: column['prefixIcon'] as IconData?,
          ),
        )
        .toList(),
  );
}
