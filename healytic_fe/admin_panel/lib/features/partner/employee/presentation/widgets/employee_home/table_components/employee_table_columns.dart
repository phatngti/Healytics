import 'package:common/widgets/table/helper.dart';
import 'package:flutter/material.dart';

class EmployeeTableColumns {
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'ID'},
    {'label': 'Avatar'},
    {'label': 'Full Name'},
    {'label': 'Position'},
    {'label': 'Rating'},
    {'label': 'Review Count'},
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
