import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_app/core/widgets/root_overlay_toast.dart';
import 'package:user_app/router/app_router.dart';

void main() {
  testWidgets('returns false when root overlay is unavailable', (tester) async {
    final shown = RootOverlayToast.show(
      builder: (_) => const SizedBox.shrink(),
    );

    expect(shown, isFalse);
  });

  testWidgets('shows and dismisses a toast through root navigator overlay', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: rootNavigatorKey,
        home: const Scaffold(body: Text('home')),
      ),
    );

    final shown = RootOverlayToast.show(
      duration: const Duration(minutes: 1),
      builder: (dismiss) {
        return Material(
          child: TextButton(
            onPressed: dismiss,
            child: const Text('overlay toast'),
          ),
        );
      },
    );

    expect(shown, isTrue);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.text('overlay toast'), findsOneWidget);

    await tester.tap(find.text('overlay toast'));
    await tester.pump();

    expect(find.text('overlay toast'), findsNothing);
  });
}
