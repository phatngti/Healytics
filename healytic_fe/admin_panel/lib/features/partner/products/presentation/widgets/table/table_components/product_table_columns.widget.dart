import 'package:common/widgets/table/helper.dart';
import 'package:flutter/material.dart';

class ProductTableColumns {
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'ID'},
    {'label': 'Image'},
    {'label': 'Category'},
    {'label': 'Name'},
    {'label': 'Price'},
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
