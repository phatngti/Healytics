import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/review/presentation/providers/review_facility.provider.dart';
import 'package:user_app/features/review/presentation/providers/review_rating_defaults.dart';
import 'package:user_app/features/review/presentation/providers/review_specialist.provider.dart';
import 'package:user_app/features/review/presentation/providers/review_treatment.provider.dart';

void main() {
  test('all review forms default to five stars', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(reviewTreatmentProvider).rating, defaultReviewRating);
    expect(
      container.read(reviewSpecialistProvider).rating,
      defaultReviewRating,
    );
    expect(container.read(reviewFacilityProvider).rating, defaultReviewRating);
  });
}
