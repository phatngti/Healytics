import 'package:admin_panel/features/partner/profile_completion/data/provider/profile_completion.provider.dart';
import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_completion.provider.g.dart';

/// Manages the profile completion state for the
/// presentation layer. Delegates all data operations
/// to the [ProfileCompletionRepository].
@riverpod
class ProfileCompletionNotifier extends _$ProfileCompletionNotifier {
  @override
  FutureOr<PartnerProfileCompletionEntity> build() async {
    // Use ref.watch so this notifier properly
    // depends on the repository provider and
    // rebuilds when it changes.
    final repo = ref.watch(profileCompletionRepositoryProvider);
    return repo.getProfileCompletion();
  }

  /// Saves the current form state as a draft.
  Future<PartnerProfileCompletionEntity> saveDraft(
    PartnerProfileCompletionUpdateRequest request,
  ) async {
    // Cache repo before the async gap to avoid
    // accessing ref after potential disposal.
    final repo = ref.read(profileCompletionRepositoryProvider);
    final result = await repo.updateProfileCompletion(request);
    if (!ref.mounted) return result;
    state = AsyncValue.data(result);
    return result;
  }

  /// Validates and completes the profile, triggering
  /// a session refresh to update partner flags.
  Future<PartnerProfileCompletionEntity> completeProfile(
    PartnerProfileCompletionUpdateRequest request,
  ) async {
    // Cache repo before the async gap to avoid
    // accessing ref after potential disposal.
    final repo = ref.read(profileCompletionRepositoryProvider);
    final result = await repo.completeProfile(request);
    if (!ref.mounted) return result;
    state = AsyncValue.data(result);
    return result;
  }

  /// Force-refetches completion data from the API.
  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    final repo = ref.read(profileCompletionRepositoryProvider);
    state = await AsyncValue.guard(repo.getProfileCompletion);
  }
}
