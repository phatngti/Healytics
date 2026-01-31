import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/location.provider.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/verification_status.provider.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/revision_alert_banner.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_bottom_bar.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_header.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_section_card.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Main screen for providers to view and update their verification status.
///
/// Displays:
/// - Alert banner with admin feedback
/// - Section cards for each verification step
/// - Active form sections for required updates
/// - Fixed bottom bar with resubmit action
class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(verificationStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return statusAsync.when(
      data: (status) => Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: VerificationHeader(
          applicationId: status.applicationId,
          onHelpPressed: () {
            // TODO: Navigate to help center
          },
        ),
        body: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Alert banner
                        if (status.status ==
                                VerificationRevisionStatus.revisionRequested &&
                            status.adminFeedback != null)
                          RevisionAlertBanner(
                            title: status.adminFeedback!,
                            message: status.adminFeedbackDetail ?? '',
                            adminFeedback:
                                'Front ID photo is too dark and blurry.',
                          ),
                        AppDimens.verticalLargeExtra,
                        // Page title
                        Text(
                          'Application Revision',
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        AppDimens.verticalSmall,
                        Text(
                          'Please update the specific sections highlighted below '
                          'to proceed with your registration.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppDimens.verticalLarge,
                        // Section cards
                        _buildSectionList(context, ref, status),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Fixed bottom bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: VerificationBottomBar(
                status: status.status,
                isLoading: statusAsync.isLoading,
                onCancel: () {
                  // TODO: Navigate back or show confirmation
                },
                onResubmit: () {
                  ref
                      .read(verificationStatusProvider.notifier)
                      .resubmitApplication();
                },
              ),
            ),
          ],
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Verification Status')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              AppDimens.verticalMedium,
              Text(
                'Failed to load verification status',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              AppDimens.verticalSmall,
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppDimens.verticalLarge,
              FilledButton.icon(
                onPressed: () => ref.invalidate(verificationStatusProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionList(
    BuildContext context,
    WidgetRef ref,
    ProviderVerificationStatusEntity status,
  ) {
    // Watch location providers for dropdown data
    final provincesAsync = ref.watch(provincesProvider);
    final provinces = provincesAsync.value ?? <LocationEntity>[];

    // Get current province ID to fetch districts
    final currentProvinceId = status.locationDetails?.provinceId.value;
    final districtsAsync = ref.watch(districtsProvider(currentProvinceId));
    final districts = districtsAsync.value ?? <LocationEntity>[];

    // Get current district ID to fetch wards
    final currentDistrictId = status.locationDetails?.districtId.value;
    final wardsAsync = ref.watch(wardsProvider(currentDistrictId));
    final wards = wardsAsync.value ?? <LocationEntity>[];

    return Column(
      children: status.sections
          .map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: VerificationSectionCard(
                section: section,
                verificationStatus: status,
                provinces: provinces,
                districts: districts,
                wards: wards,
              ),
            ),
          )
          .toList(),
    );
  }
}
