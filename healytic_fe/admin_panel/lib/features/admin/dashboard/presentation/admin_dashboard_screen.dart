import 'package:admin_panel/features/admin/dashboard/presentation/layouts/admin_dashboard_desktop.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/layouts/admin_dashboard_mobile.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/layouts/admin_dashboard_tablet.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard.provider.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminDashboardScreen extends HookConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(adminDashboardProvider);

    return asyncState.when(
      loading: () => const ResponsiveWrapper(
        useLayout: true,
        desktop: _DashboardLoading(),
        tablet: _DashboardLoading(),
        mobile: _DashboardLoading(),
      ),
      error: (error, stackTrace) => ResponsiveWrapper(
        useLayout: true,
        desktop: _DashboardError(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(adminDashboardProvider.notifier).refresh(),
        ),
        tablet: _DashboardError(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(adminDashboardProvider.notifier).refresh(),
        ),
        mobile: _DashboardError(
          error: error,
          stackTrace: stackTrace,
          onRetry: () => ref.read(adminDashboardProvider.notifier).refresh(),
        ),
      ),
      data: (state) => ResponsiveWrapper(
        useLayout: true,
        desktop: AdminDashboardDesktop(state: state),
        tablet: AdminDashboardTablet(state: state),
        mobile: AdminDashboardMobile(state: state),
      ),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });

  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: ErrorCard(
          title: 'Failed to load admin dashboard',
          error: error,
          stackTrace: stackTrace,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
