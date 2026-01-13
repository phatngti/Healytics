import 'package:admin_panel/features/common/widgets/table/table.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_function_buttons.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_header_buttons.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_table_columns.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/table_components/service_tag_table_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceTagsTable extends ConsumerWidget {
  const ServiceTagsTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: AppTable(
        columns: ServiceTagTableColumns.columns.dataColumns(context),
        getTotalRows: () => ServiceTagTableSource.getTotalRows(context, ref),
        getData: (setRowSelection, startingAt, count) =>
            ServiceTagTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: ServiceTagHeaderButtons.buildTableButtons(context),
        onSearchChanged: (value) {
          // TODO: Implement search functionality
        },
        functionButtons: ServiceTagFunctionButtons.buildFunctionButtons(
          context,
        ),
      ),
    );
  }
}
