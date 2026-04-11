import 'dart:developer' as developer;

import 'package:admin_openapi/api.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/features/partner/verification_status/data/verification_status_impl.repository.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/document_verification_section.widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_status.provider.g.dart';

/// Provider for the current verification status.
///
/// Fetches the provider's verification status from the repository
/// and provides methods for resubmitting applications.
@riverpod
class VerificationStatus extends _$VerificationStatus {
  @override
  Future<ProviderVerificationStatusEntity> build() async {
    await _refreshAuthTokens();
    final repository = ref.watch(verificationStatusRepositoryProvider);
    final status = await repository.getVerificationStatus();

    // Sync local verified flag so the router can
    // redirect away from this page when approved.
    final isVerified =
        status.verificationStatus == VerificationRevisionStatus.approved;
    UserRoleHelper.setPartnerVerified(isVerified);

    return status;
  }

  /// Calls `POST /auth/partner/refresh` to obtain fresh
  /// tokens before fetching the verification status.
  Future<void> _refreshAuthTokens() async {
    final refreshToken = Store.tryGet(StoreKey.refreshToken);
    if (refreshToken == null) return;

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.authenticateApi
          .authControllerRefreshPartner(
            RefreshTokenRequestDto(refreshToken: refreshToken),
          );
      if (response != null) {
        await apiService.setAccessToken(response.accessToken);
        await Store.put(StoreKey.refreshToken, response.refreshToken);
        UserRoleHelper.syncPartnerFlagsFromAccessToken(response.accessToken);
      }
    } catch (e) {
      developer.log('Token refresh failed: $e', name: 'VerificationStatus');
    }
  }

  /// Resubmits the application after making requested revisions.
  ///
  /// Accepts [formValues] from FormBuilder containing all edited fields
  /// and uploaded documents. Returns a record with success status and
  /// optional error message.
  Future<({bool success, String? errorMessage})> resubmitApplication({
    required Map<String, dynamic> formValues,
  }) async {
    final previousState = state;
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(verificationStatusRepositoryProvider);

      // Extract edits (String/List values) and uploads (DocumentUploadResult values)
      final edits = <String, dynamic>{};
      final uploads = <DocumentUploadResult>[];

      formValues.forEach((key, value) {
        if (value is String && value.isNotEmpty) {
          edits[key] = value;
        } else if (value is List) {
          edits[key] = value;
        } else if (value is DocumentUploadResult) {
          uploads.add(value);
        }
      });

      // Call the repository to update the partner profile
      await repository.resubmitApplication(uploads: uploads, edits: edits);

      // Refresh the verification status
      ref.invalidateSelf();

      return (success: true, errorMessage: null);
    } catch (e) {
      // Restore previous state on error
      state = previousState;
      return (success: false, errorMessage: e.toString());
    }
  }
}
