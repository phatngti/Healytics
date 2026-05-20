import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_floating_header.widget.dart';

void main() {
  testWidgets('floating header invokes share and more callbacks', (
    tester,
  ) async {
    var shareCount = 0;
    var moreCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ClinicFloatingHeader(
            clinicName: 'Healytics Spa',
            logoUrl: null,
            showBlur: ValueNotifier(false),
            onBack: () {},
            onShare: () => shareCount++,
            onMore: () => moreCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Share clinic'));
    await tester.tap(find.bySemanticsLabel('More clinic actions'));

    expect(shareCount, 1);
    expect(moreCount, 1);
  });
}
