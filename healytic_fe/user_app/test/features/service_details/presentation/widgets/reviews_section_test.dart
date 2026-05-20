import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_app/features/service_details/presentation/widgets/service_details/reviews_section.widget.dart';

void main() {
  testWidgets('view more can use a specialist reviews action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewsSection(
            reviews: [
              ReviewEntity(
                reviewerName: 'Test User',
                avatarUrl: '',
                rating: 5,
                date: DateTime(2026, 5, 8),
                text: 'Review Specialist',
              ),
            ],
            rating: 4.9,
            serviceId: 'employee-1',
            onViewMoreTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.textContaining('View More'));

    expect(tapped, isTrue);
  });
}
