import 'package:admin_panel/features/admin/partner_manager/presentation/providers/partner_manager.provider.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_function_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_header_buttons.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_columns.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/table/table_components/partner_table_source.dart';
import 'package:common/widgets/table/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _defaultRowsPerPage = 10;

/// Table widget for displaying partner verification
/// requests. Receives workspace state and search
/// callback from the parent layout.
class PartnerVerificationTable extends HookConsumerWidget {
  const PartnerVerificationTable({
    super.key,
    required this.height,
    required this.onSearchChanged,
  });

  final double height;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(partnerManagerWorkspaceProvider);
    final queryHash = Object.hash(
      state.scope,
      state.searchQuery,
      state.statusFilter,
      state.sortBy,
      state.sortAsc,
    );
    final pageCache = useMemoized(
      () => PartnerTablePageCache(
        ref: ref,
        state: state,
        prefetchCount: _defaultRowsPerPage,
      ),
      [
        state.scope,
        state.searchQuery,
        state.statusFilter,
        state.sortBy,
        state.sortAsc,
        state.reloadToken,
      ],
    );

    return SizedBox(
      height: height,
      child: AppTable(
        refreshToken: Object.hash(state.reloadToken, queryHash),
        columns: PartnerTableColumns.columns.dataColumns(context),
        getTotalRows: pageCache.getTotalRows,
        getData: (setRowSelection, startingAt, count) =>
            pageCache.getData(context, setRowSelection, startingAt, count),
        defaultRowsPerPage: _defaultRowsPerPage,
        buttons: PartnerHeaderButtons.buildTableButtons(context),
        onSearchChanged: onSearchChanged,
        functionButtons: PartnerFunctionButtons.buildFunctionButtons(context),
      ),
    );
  }
}
