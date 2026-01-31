import 'dart:developer' as developer;

import 'package:admin_panel/features/admin/partner_manager/datasource/partner_verification_impl.repository.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'partner_detail.provider.g.dart';

/// Async provider for fetching partner verification detail by ID.
///
/// Uses the family modifier to create a separate provider instance per partner.
/// Data is fetched through the repository following Clean Architecture principles.
///
/// State lifecycle:
/// - `AsyncLoading`: Initial load or refresh in progress.
/// - `AsyncData`: Successfully fetched partner detail.
/// - `AsyncError`: API call failed with error details.
@riverpod
class PartnerDetail extends _$PartnerDetail {
  @override
  Future<PartnerVerificationDetailEntity> build(String partnerId) async {
    return _fetchPartnerDetail(partnerId);
  }

  /// Refreshes the partner detail data from the repository.
  ///
  /// Sets state to loading before fetching and handles errors gracefully.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPartnerDetail(partnerId));
  }

  /// Internal method to fetch partner detail with error handling.
  ///
  /// Logs errors using `dart:developer` for structured debugging.
  Future<PartnerVerificationDetailEntity> _fetchPartnerDetail(String id) async {
    try {
      final repository = ref.read(partnerVerificationRepositoryProvider);
      return await repository.getPartnerDetailById(PartnerVerificationId(id));
    } catch (error, stackTrace) {
      developer.log(
        'Failed to fetch partner detail',
        name: 'PartnerDetail',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
