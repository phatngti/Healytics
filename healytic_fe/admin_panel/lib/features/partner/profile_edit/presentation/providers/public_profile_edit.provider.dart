import 'dart:async';

import 'package:admin_panel/features/partner/profile_edit/data/provider/public_profile.provider.dart';
import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'public_profile_edit.provider.g.dart';

/// Manages the public profile edit page state.
///
/// Implements the snapshot/draft dirty-checking
/// state machine:
/// - `build()` → GET → ready_clean
/// - field mutation → ready_dirty
/// - save → PUT → ready_clean
/// - discard → reset draft to snapshot
@riverpod
class PublicProfileEditNotifier
    extends _$PublicProfileEditNotifier {
  /// Server-confirmed storefront state.
  PublicProfileStorefront? _serverSnapshot;

  /// User's in-progress edits.
  PublicProfileStorefront? _draft;

  @override
  FutureOr<PartnerPublicProfileEntity>
      build() async {
    final repo = ref.watch(
      publicProfileRepositoryProvider,
    );
    final entity = await repo.getPublicProfile();
    _serverSnapshot = entity.storefront;
    _draft = entity.storefront;
    return entity;
  }

  /// Whether the user has unsaved changes.
  bool get isDirty =>
      _serverSnapshot != null &&
      _draft != null &&
      _serverSnapshot != _draft;

  /// Current draft storefront state.
  PublicProfileStorefront? get draft => _draft;

  /// Replaces the draft with updated values.
  void updateDraft(PublicProfileStorefront next) {
    _draft = next;
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(storefront: next),
    );
  }

  /// Discards user edits by resetting draft
  /// to the last server snapshot.
  void discard() {
    if (_serverSnapshot == null) return;
    _draft = _serverSnapshot;
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        storefront: _serverSnapshot!,
      ),
    );
  }

  /// Saves only the changed fields.
  Future<PartnerPublicProfileEntity> save() async {
    final repo = ref.read(
      publicProfileRepositoryProvider,
    );

    final request = _buildPartialRequest();
    final result =
        await repo.updatePublicProfile(request);

    if (!ref.mounted) return result;
    _serverSnapshot = result.storefront;
    _draft = result.storefront;
    state = AsyncValue.data(result);
    return result;
  }

  /// Force-refetches from the API.
  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    final repo = ref.read(
      publicProfileRepositoryProvider,
    );
    final result = await AsyncValue.guard(
      repo.getPublicProfile,
    );
    if (!ref.mounted) return;
    if (result is AsyncData<
        PartnerPublicProfileEntity>) {
      _serverSnapshot = result.value.storefront;
      _draft = result.value.storefront;
    }
    state = result;
  }

  /// Builds a request containing only the fields
  /// that differ from the server snapshot.
  PublicProfileUpdateRequest
      _buildPartialRequest() {
    final snap = _serverSnapshot;
    final d = _draft;
    if (snap == null || d == null) {
      return const PublicProfileUpdateRequest();
    }

    return PublicProfileUpdateRequest(
      coverImageUrl:
          d.coverImageUrl != snap.coverImageUrl
              ? d.coverImageUrl
              : null,
      logoImageUrl:
          d.logoImageUrl != snap.logoImageUrl
              ? d.logoImageUrl
              : null,
      description:
          d.description != snap.description
              ? d.description
              : null,
      gallery: _listsDiffer(d.gallery, snap.gallery)
          ? d.gallery
          : null,
      certifications:
          _certsDiffer(d.certifications,
                  snap.certifications)
              ? d.certifications
              : null,
    );
  }

  bool _listsDiffer(
    List<String> a,
    List<String> b,
  ) {
    if (a.length != b.length) return true;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return true;
    }
    return false;
  }

  bool _certsDiffer(
    List<PublicProfileCertification> a,
    List<PublicProfileCertification> b,
  ) {
    if (a.length != b.length) return true;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return true;
    }
    return false;
  }
}
