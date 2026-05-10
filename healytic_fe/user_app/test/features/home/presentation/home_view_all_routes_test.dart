import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/router/routes.dart';

void main() {
  test('home view all routes expose expected locations', () {
    expect(const HomeRecommendationsRoute().location, '/home/recommendations');
    expect(const HomeRecentActivityRoute().location, '/home/recent-activity');
    expect(const HomeSpecialistsRoute().location, '/home/specialists');
    expect(
      const HomePremiumTreatmentsRoute().location,
      '/home/premium-treatments',
    );
  });
}
