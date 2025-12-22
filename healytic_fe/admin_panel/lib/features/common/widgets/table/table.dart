import 'dart:async';

import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/table/header.dart';
import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/features/common/widgets/table/helper.dart';
import 'package:admin_panel/utils/demensions.dart';

import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class AppTable extends StatefulWidget {
  const AppTable({
    super.key,
    this.functionButtons,
    this.onSearchChanged,
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

  final List<TableFunctionButtonWidget>? functionButtons;
  final ValueChanged<String>? onSearchChanged;
  final List<AppButton>? buttons;
  final List<DataColumn> columns;
  final int? sortColumnIndex;
  final bool sortAscending;
  final List<Widget>? actions;
  final int defaultRowsPerPage;
  final bool actionButtons;
  final Future<int> Function() getTotalRows;
  final GetDataCallback getData;
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
    // Recreate source if callbacks changed
    if (oldWidget.getTotalRows != widget.getTotalRows ||
        oldWidget.getData != widget.getData) {
      _source.dispose();
      _source = AppDataTableSource(
        getTotalRows: widget.getTotalRows,
        getData: widget.getData,
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    // Last ppage example uses extra API call to get the number of items in datasource
    final columns = widget.columns;
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
      child: AsyncPaginatedDataTable2(
        horizontalMargin: 20,
        checkboxHorizontalMargin: 12,
        columnSpacing: 0,
        wrapInCard: false,
        header: TableHeaderWidget(
          functionButtons: widget.functionButtons,
          onSearchChanged: widget.onSearchChanged,
          buttons: widget.buttons,
        ),
        actions: widget.actions,
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: {
          _rowsPerPage,
          widget.defaultRowsPerPage,
          widget.defaultRowsPerPage * 2,
          widget.defaultRowsPerPage * 3,
          widget.defaultRowsPerPage * 4,
        }.toList()..sort(),
        // autoRowsToHeight: true,
        minWidth: 800,
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
          // verticalInside: BorderSide(color: Colors.grey[500]!),
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
                  print('Row per page changed to $value');
                });
              }
            });
          }
        },
        onPageChanged: (rowIndex) {
          print(rowIndex / widget.defaultRowsPerPage);
        },
        sortColumnIndex: widget.sortColumnIndex,
        sortAscending: widget.sortAscending,
        sortArrowIcon: Icons.keyboard_arrow_up,
        sortArrowAnimationDuration: const Duration(milliseconds: 0),
        onSelectAll: (select) => (),

        hidePaginator: false,
        columns: widget.columns,
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
      ),
    );
  }
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
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
