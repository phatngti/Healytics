import 'package:common/widgets/table/helper.dart';
import 'package:flutter/material.dart';

class CategoryTableColumns {
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'Icon'},
    {'label': 'Category Name'},
    {'label': 'Type'},
    {'label': 'Parent Category'},
    {'label': 'Description'},
    {'label': 'Sub-categories'},
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
