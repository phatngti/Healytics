// Test driver for running integration tests via `flutter drive` on Chrome.
//
// Run with:
// flutter drive \
//   --driver=integration_test/test_driver/integration_test.dart \
//   --target=integration_test/sign_up_form_integration_test.dart \
//   -d chrome
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
