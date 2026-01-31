import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_function_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_header_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_columns.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_source.dart';
import 'package:admin_panel/features/common/widgets/table/table.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Table widget for displaying partner verification requests
class PartnerVerificationTable extends HookConsumerWidget {
  const PartnerVerificationTable({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: AppTable(
        columns: PartnerTableColumns.columns.dataColumns(context),
        getTotalRows: () => PartnerTableSource.getTotalRows(ref),
        getData: (setRowSelection, startingAt, count) =>
            PartnerTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
            ),
        defaultRowsPerPage: 10,
        buttons: PartnerHeaderButtons.buildTableButtons(context),
        onSearchChanged: (value) {
          // TODO: Implement search functionality
        },
        functionButtons: PartnerFunctionButtons.buildFunctionButtons(context),
      ),
    );
  }
}
