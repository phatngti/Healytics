import 'package:common/widgets/table/helper.dart';
import 'package:flutter/material.dart';

class ServiceTagTableColumns {
  static const List<Map<String, dynamic>> _columnDefinitions = [
    {'label': 'Tag Name'},
    {'label': 'Description'},
    {'label': 'Color Label'},
    {'label': 'Usage'},
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
