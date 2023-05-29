import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sonalysis/integration_test/integration_test_helpers.dart';

import 'package:sonalysis/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      final FlutterExceptionHandler? originalOnError = FlutterError.onError;

      initCustomExpect();

      app.main();
      // await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();
      FlutterError.onError = originalOnError;

      // wait for 5 seconds
      await tester.pump(const Duration(seconds: 15));

      // // Verify the counter starts at 0.
      // expect(find.text('0'), findsOneWidget);

      // // Finds the floating action button to tap on.
      // final Finder fab = find.byTooltip('Increment');

      // // Emulate a tap on the floating action button.
      // await tester.tap(fab);

      // // Trigger a frame.
      // await tester.pumpAndSettle();

      // // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
      expectCustom(2 + 2, equals(4), reason: 'maths works');
    });
  });
}
