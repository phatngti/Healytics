import 'package:common/widgets/table/table.dart';
import 'package:admin_panel/core/keys/integration_test_keys.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/providers/service_tag.provider.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_function_buttons.widget.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_header_buttons.widget.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_table_columns.widget.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_table_source.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceTagsTable extends ConsumerWidget {
  const ServiceTagsTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableState =
        ref.watch(serviceTagProvider).value ?? const ServiceTagState();
    final queryHash = Object.hash(
      tableState.searchQuery,
      tableState.sortBy,
      tableState.sortAscending,
      tableState.statusFilter,
    );

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(tableState.reloadToken, queryHash),
        columns: ServiceTagTableColumns.columns.dataColumns(context),
        getTotalRows: () =>
            ref.read(serviceTagProvider.notifier).getVisibleTotalRows(),
        getData: (setRowSelection, startingAt, count) =>
            ServiceTagTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: ServiceTagHeaderButtons.buildTableButtons(
          context,
          ref,
          tableState,
        ),
        searchFieldKey: keys.managementTables.serviceTagSearchField,
        onSearchChanged: ref.read(serviceTagProvider.notifier).setSearchQuery,
        functionButtons: ServiceTagFunctionButtons.buildFunctionButtons(
          context,
          ref,
          tableState,
        ),
      ),
    );
  }
}
