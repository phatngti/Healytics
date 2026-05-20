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
class PublicProfileEditNotifier extends _$PublicProfileEditNotifier {
  /// Server-confirmed storefront state.
  PublicProfileStorefront? _serverSnapshot;

  /// User's in-progress edits.
  PublicProfileStorefront? _draft;

  @override
  FutureOr<PartnerPublicProfileEntity> build() async {
    final repo = ref.watch(publicProfileRepositoryProvider);
    final entity = await repo.getPublicProfile();
    _serverSnapshot = entity.storefront;
    _draft = entity.storefront;
    return entity;
  }

  /// Whether the user has unsaved changes.
  bool get isDirty =>
      _serverSnapshot != null && _draft != null && _serverSnapshot != _draft;

  /// Current draft storefront state.
  PublicProfileStorefront? get draft => _draft;

  /// Replaces the draft with updated values.
  void updateDraft(PublicProfileStorefront next) {
    _draft = next;
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(storefront: next));
  }

  /// Discards user edits by resetting draft
  /// to the last server snapshot.
  void discard() {
    if (_serverSnapshot == null) return;
    _draft = _serverSnapshot;
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(storefront: _serverSnapshot!));
  }

  /// Saves only the changed fields.
  Future<PartnerPublicProfileEntity> save() async {
    final repo = ref.read(publicProfileRepositoryProvider);

    final request = _buildPartialRequest();
    if (!request.hasChanges) {
      final current = state.asData?.value;
      if (current != null) {
        return current;
      }
    }

    final result = await repo.updatePublicProfile(request);

    if (!ref.mounted) return result;
    _serverSnapshot = result.storefront;
    _draft = result.storefront;
    state = AsyncValue.data(result);
    return result;
  }

  /// Force-refetches from the API.
  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    final repo = ref.read(publicProfileRepositoryProvider);
    final result = await AsyncValue.guard(repo.getPublicProfile);
    if (!ref.mounted) return;
    if (result is AsyncData<PartnerPublicProfileEntity>) {
      _serverSnapshot = result.value.storefront;
      _draft = result.value.storefront;
    }
    state = result;
  }

  /// Builds a request containing only the fields
  /// that differ from the server snapshot.
  PublicProfileUpdatePatch _buildPartialRequest() {
    final snap = _serverSnapshot;
    final d = _draft;
    if (snap == null || d == null) {
      return const PublicProfileUpdatePatch();
    }

    final cover = _blankToNull(d.coverImageUrl);
    final snapCover = _blankToNull(snap.coverImageUrl);
    final logo = _blankToNull(d.logoImageUrl);
    final snapLogo = _blankToNull(snap.logoImageUrl);
    final description = _blankToNull(d.description);
    final snapDescription = _blankToNull(snap.description);
    final gallery = _normalizeUrls(d.gallery);
    final snapGallery = _normalizeUrls(snap.gallery);
    final certifications = _normalizeCertifications(d.certifications);
    final snapCertifications = _normalizeCertifications(snap.certifications);

    final coverChanged = cover != snapCover;
    final logoChanged = logo != snapLogo;
    final descriptionChanged = description != snapDescription;
    final galleryChanged = _listsDiffer(gallery, snapGallery);
    final certsChanged = _certsDiffer(certifications, snapCertifications);

    return PublicProfileUpdatePatch(
      coverImageUrl: cover,
      includeCoverImageUrl: coverChanged,
      logoImageUrl: logo,
      includeLogoImageUrl: logoChanged,
      description: description,
      includeDescription: descriptionChanged,
      gallery: gallery,
      includeGallery: galleryChanged,
      certifications: certifications,
      includeCertifications: certsChanged,
    );
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  List<String> _normalizeUrls(List<String> values) {
    return values
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  List<PublicProfileCertification> _normalizeCertifications(
    List<PublicProfileCertification> values,
  ) {
    return values
        .asMap()
        .entries
        .where((entry) => entry.value.title.trim().isNotEmpty)
        .map(
          (entry) => entry.value.copyWith(
            title: entry.value.title.trim(),
            subtitle: _blankToNull(entry.value.subtitle),
            iconName: entry.value.iconName.trim(),
            sortOrder: entry.key,
          ),
        )
        .toList(growable: false);
  }

  bool _listsDiffer(List<String> a, List<String> b) {
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
