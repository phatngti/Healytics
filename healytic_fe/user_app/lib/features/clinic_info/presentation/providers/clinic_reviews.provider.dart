import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/clinic_info/data/provider/clinic_info.provider.dart';
import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';

part 'clinic_reviews.provider.g.dart';

// ── 1. Filter State ─────────────────────────────────

/// Tracks the active review filter pill ID.
/// Defaults to `'all'`.
@riverpod
class ClinicReviewFilterNotifier
    extends _$ClinicReviewFilterNotifier {
  @override
  String build() => 'all';

  /// Selects a filter pill by its ID.
  void select(String filterId) =>
      state = filterId;
}

// ── 2. Accumulated Reviews (pagination) ─────────────

/// Holds the accumulated list of reviews across
/// all loaded pages, plus pagination metadata.
class ClinicReviewsAccumulated {
  const ClinicReviewsAccumulated({
    required this.summary,
    required this.filters,
    required this.reviews,
    required this.hasMore,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  final ClinicReviewSummary summary;
  final List<ClinicReviewFilter> filters;
  final List<ClinicReviewEntity> reviews;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  /// Creates a copy with updated fields.
  ClinicReviewsAccumulated copyWith({
    ClinicReviewSummary? summary,
    List<ClinicReviewFilter>? filters,
    List<ClinicReviewEntity>? reviews,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return ClinicReviewsAccumulated(
      summary: summary ?? this.summary,
      filters: filters ?? this.filters,
      reviews: reviews ?? this.reviews,
      hasMore: hasMore ?? this.hasMore,
      currentPage:
          currentPage ?? this.currentPage,
      isLoadingMore:
          isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// ── 3. Paginated Reviews Provider ───────────────────

/// Manages paginated review loading with server-side
/// filtering.
///
/// Watches the active filter pill. When the filter
/// changes, reloads from page 1 using server-side
/// params (`starCount`, `hasMedia`).
@riverpod
class ClinicReviewsPaginated
    extends _$ClinicReviewsPaginated {
  @override
  Future<ClinicReviewsAccumulated> build({
    required String clinicId,
  }) async {
    final filterId = ref.watch(
      clinicReviewFilterProvider,
    );

    final repo = ref.read(
      clinicInfoRepositoryProvider,
    );

    // Resolve filter params from the selected
    // filter ID. On initial load, filters are not
    // yet known, so only handle well-known IDs.
    final params = _resolveFilterParams(filterId);

    final data = await repo.getClinicReviews(
      clinicId,
      starCount: params.starCount,
      hasMedia: params.hasMedia,
    );

    return ClinicReviewsAccumulated(
      summary: data.summary,
      filters: data.filters,
      reviews: data.reviews,
      hasMore: data.hasMore,
      currentPage: 1,
    );
  }

  /// Loads the next page and appends to the list.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true),
    );

    final filterId = ref.read(
      clinicReviewFilterProvider,
    );
    final params = _resolveFilterParams(filterId);

    final nextPage = current.currentPage + 1;
    final repo = ref.read(
      clinicInfoRepositoryProvider,
    );
    final data = await repo.getClinicReviews(
      clinicId,
      page: nextPage,
      starCount: params.starCount,
      hasMedia: params.hasMedia,
    );

    state = AsyncData(
      current.copyWith(
        reviews: [
          ...current.reviews,
          ...data.reviews,
        ],
        hasMore: data.hasMore,
        currentPage: nextPage,
        isLoadingMore: false,
      ),
    );
  }

  /// Resolves filter pill ID to server-side query
  /// params. Accepts both legacy formats (`5star`,
  /// `media`) and backend-canonical formats
  /// (`5-star`, `with-media`).
  _ReviewFilterParams _resolveFilterParams(
    String filterId,
  ) {
    if (filterId == 'all') {
      return const _ReviewFilterParams();
    }
    if (filterId == 'media' ||
        filterId == 'with-media') {
      return const _ReviewFilterParams(
        hasMedia: true,
      );
    }
    final starMatch =
        RegExp(r'^(\d)-?star$').firstMatch(filterId);
    if (starMatch != null) {
      return _ReviewFilterParams(
        starCount: int.parse(starMatch.group(1)!),
      );
    }
    return const _ReviewFilterParams();
  }
}

/// Internal helper to hold resolved filter params.
class _ReviewFilterParams {
  const _ReviewFilterParams({
    this.starCount,
    this.hasMedia,
  });

  final int? starCount;
  final bool? hasMedia;
}
