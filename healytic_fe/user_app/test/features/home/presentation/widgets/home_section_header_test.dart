import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/home/presentation/widgets/'
    'home_section_header.widget.dart';

void main() {
  testWidgets('renders title and calls view all action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSectionHeader(
            title: 'Recent Activity',
            onViewAll: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Recent Activity'), findsOneWidget);
    expect(find.text('View all'), findsOneWidget);

    await tester.tap(find.text('View all'));

    expect(tapped, isTrue);
  });
}
