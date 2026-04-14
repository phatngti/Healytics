import 'package:admin_panel/features/admin/system_notification/presentation/providers/notification_campaign.provider.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_composer_builder.widget.dart';
import 'package:admin_panel/features/admin/system_notification/presentation/widgets/notification_composer_summary.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Desktop layout for composing a new notification
/// campaign.
///
/// Delegates all form sections and summary panels to
/// extracted widget files.
class NotificationCampaignComposerDesktop extends ConsumerWidget {
  const NotificationCampaignComposerDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final composerState = ref.watch(notificationCampaignComposerProvider);
    final composerNotifier = ref.read(
      notificationCampaignComposerProvider.notifier,
    );
    final capabilitiesAsync = ref.watch(notificationCapabilitiesProvider);
    final segmentsAsync = ref.watch(notificationSegmentsProvider);

    return capabilitiesAsync.when(
      data: (capability) => segmentsAsync.when(
        data: (segments) => SingleChildScrollView(
          child: Padding(
            padding: AppDimens.paddingAllMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NotificationComposerHeader(),
                AppDimens.verticalLarge,
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 1180;
                    final left = NotificationComposerBuilder(
                      state: composerState,
                      notifier: composerNotifier,
                      capability: capability,
                      segments: segments,
                    );
                    final right = NotificationComposerSummary(
                      state: composerState,
                      capability: capability,
                    );

                    if (isNarrow) {
                      return Column(
                        children: [left, AppDimens.verticalLarge, right],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: left),
                        AppDimens.horizontalLarge,
                        SizedBox(width: 360, child: right),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Text('Failed to load segments: $error'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load capabilities: $error'),
    );
  }
}
