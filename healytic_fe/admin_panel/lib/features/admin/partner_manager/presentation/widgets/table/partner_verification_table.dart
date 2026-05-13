import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager_state.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_function_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_header_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_columns.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_source.dart';
import 'package:common/widgets/table/table.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Table widget for displaying partner verification
/// requests. Receives workspace state and search
/// callback from the parent layout.
class PartnerVerificationTable
    extends HookConsumerWidget {
  const PartnerVerificationTable({
    super.key,
    required this.height,
    required this.state,
    required this.onSearchChanged,
  });

  final double height;
  final PartnerManagerState state;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: AppTable(
        columns: PartnerTableColumns
            .columns
            .dataColumns(context),
        getTotalRows: () =>
            PartnerTableSource.getTotalRows(
              ref,
              state,
            ),
        getData: (
          setRowSelection,
          startingAt,
          count,
        ) =>
            PartnerTableSource.getData(
              context,
              ref,
              setRowSelection,
              startingAt,
              count,
              state,
            ),
        defaultRowsPerPage: 10,
        buttons: PartnerHeaderButtons.buildTableButtons(
          context,
        ),
        onSearchChanged: onSearchChanged,
        functionButtons:
            PartnerFunctionButtons
                .buildFunctionButtons(context),
      ),
    );
  }
}
