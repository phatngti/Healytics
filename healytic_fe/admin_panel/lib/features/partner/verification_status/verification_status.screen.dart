import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/location.provider.dart';
import 'package:admin_panel/features/common/providers/authen_token.provider.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/verification_status.provider.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/revision_alert_banner.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_bottom_bar.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_header.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/verification_section_card.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Main screen for providers to view and update their verification status.
///
/// Displays:
/// - Alert banner with admin feedback
/// - Section cards for each verification step
/// - Active form sections for required updates
/// - Fixed bottom bar with resubmit action
class VerificationStatusScreen extends ConsumerStatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  ConsumerState<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState
    extends ConsumerState<VerificationStatusScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  /// Gets admin feedback from entity fields that have feedback.
  String? _getAdminFeedback(ProviderVerificationStatusEntity status) {
    // Collect all feedback from fields
    final feedbacks = <String>[];

    return feedbacks.isNotEmpty ? feedbacks.first : null;
  }

  /// Extracts initial values from the entity into a map keyed by fieldKey.
  ///
  /// This maps each [VerifiedField.fieldKey] to its corresponding value
  /// across all entity sections (businessInfo, legalRepresentative, kycDocuments).
  Map<String, dynamic> _extractInitialValues(
    ProviderVerificationStatusEntity status,
  ) {
    final initialValues = <String, dynamic>{};

    // Helper to add a verified field's value to the map
    void addField(VerifiedField? field, {List<String>? objectKeys}) {
      if (field == null) return;
      if (objectKeys != null && field.value is Map<String, dynamic>) {
        final valueMap = field.value as Map<String, dynamic>;
        initialValues[field.fieldKey] = {
          for (var key in objectKeys) key: valueMap[key],
        };
      } else {
        initialValues[field.fieldKey] = field.value;
      }
    }

    // Business info fields
    final businessInfo = status.businessInfo;
    addField(businessInfo.brandName);
    addField(businessInfo.taxRegistrationCode);
    addField(businessInfo.serviceTags);
    addField(businessInfo.username);
    addField(businessInfo.email);
    addField(businessInfo.phoneNumber);

    // Address fields
    final address = businessInfo.address;
    if (address != null) {
      addField(address.streetAddress);
      addField(address.ward, objectKeys: ['id', 'name']);
      addField(address.district, objectKeys: ['id', 'name']);
      addField(address.city, objectKeys: ['id', 'name']);
    }

    // Legal representative fields
    final legalRep = status.legalRepresentative;
    if (legalRep != null) {
      addField(legalRep.fullName);
      addField(legalRep.position);
      addField(legalRep.phoneNumber);
      addField(legalRep.idType);
      addField(legalRep.idNumber);
      addField(legalRep.idIssueDate);
    }

    // KYC document fields
    for (final doc in status.kycDocuments) {
      addField(doc);
    }

    return initialValues;
  }

  /// Calculates the difference between initial values and changed values.
  ///
  /// Returns a map containing only the fields that have been modified.
  /// Filters out empty values (empty CustomDropdownItem or empty strings)
  /// to avoid false positives from unmodified form fields.
  Map<String, dynamic> _calculateDiff(
    Map<String, dynamic> initialValues,
    Map<String, dynamic> formValues,
  ) {
    final changedValues = <String, dynamic>{};

    formValues.forEach((key, value) {
      final initialValue = initialValues[key];

      // Skip empty CustomDropdownItem values (user didn't select anything)
      if (value is CustomDropdownItem && value.value.isEmpty) {
        return;
      }

      // Skip empty string values
      if (value is String && value.isEmpty) {
        return;
      }

      // Include if the value is different from initial
      // Also include DocumentUploadResult since those are always new uploads
      // Use listEquals for list comparisons
      bool isEqual;
      if (value is List && initialValue is List) {
        isEqual = listEquals(value, initialValue);
      } else {
        isEqual = value == initialValue;
      }

      if (!isEqual) {
        changedValues[key] = value;
      }
    });

    return changedValues;
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(verificationStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return statusAsync.when(
      data: (status) {
        final adminFeedback = _getAdminFeedback(status);
        final showRevisionBanner =
            status.verificationStatus ==
                VerificationRevisionStatus.requiredResubmit &&
            adminFeedback != null;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: VerificationHeader(
            applicationId: status.id,
            onHelpPressed: () {
              // TODO: Navigate to help center
            },
            onLogout: () async {
              // Clear auth tokens and navigate to login
              await ref.read(authenTokenProvider.notifier).removeToken();
              await Store.delete(StoreKey.accessToken);
              await Store.delete(StoreKey.refreshToken);
              if (context.mounted) {
                context.go('/');
              }
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
                          if (showRevisionBanner)
                            RevisionAlertBanner(
                              title: 'Action Required',
                              message: 'Please update the fields marked below.',
                              adminFeedback: adminFeedback,
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
                          // Section cards wrapped in FormBuilder
                          FormBuilder(
                            key: _formKey,
                            child: _buildSectionList(context, status),
                          ),
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
                  status: status.verificationStatus,
                  isLoading: statusAsync.isLoading,
                  onCancel: () {
                    // Reset form to original values and reload data
                    _formKey.currentState?.reset();
                    ref.invalidate(verificationStatusProvider);
                  },
                  onResubmit: () async {
                    // Save and validate form state
                    _formKey.currentState?.save();
                    final formValues = _formKey.currentState?.value ?? {};
                    // Extract initial values from the entity
                    final initialValues = _extractInitialValues(status);

                    // Calculate the difference (only changed fields)
                    final changedValues = _calculateDiff(
                      initialValues,
                      formValues,
                    );

                    final result = await ref
                        .read(verificationStatusProvider.notifier)
                        .resubmitApplication(formValues: changedValues);

                    if (!context.mounted) return;

                    final colorScheme = Theme.of(context).colorScheme;

                    if (result.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Application resubmitted successfully!',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  result.errorMessage ??
                                      'Failed to resubmit application',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
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
    ProviderVerificationStatusEntity status,
  ) {
    // Watch provinces provider for dropdown data
    // Districts and wards are fetched dynamically by LocationForm
    final provincesAsync = ref.watch(provincesProvider);
    final provinces = provincesAsync.value ?? <LocationEntity>[];

    return Column(
      children: status.sections
          .map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: VerificationSectionCard(
                section: section,
                verificationStatus: status,
                provinces: provinces,
              ),
            ),
          )
          .toList(),
    );
  }
}
