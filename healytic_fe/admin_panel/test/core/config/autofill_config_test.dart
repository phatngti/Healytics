import 'package:admin_panel/core/config/app_environment.dart';
import 'package:admin_panel/core/config/autofill_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutofillConfig', () {
    test('enables autofill only for UAT when route flag is set', () {
      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.uat,
          routeAutofill: true,
          storeAutofill: false,
        ),
        isTrue,
      );

      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.dev,
          routeAutofill: true,
          storeAutofill: false,
        ),
        isFalse,
      );

      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.prod,
          routeAutofill: true,
          storeAutofill: false,
        ),
        isFalse,
      );
    });

    test('enables autofill only for UAT when store flag is set', () {
      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.uat,
          routeAutofill: false,
          storeAutofill: true,
        ),
        isTrue,
      );

      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.dev,
          routeAutofill: false,
          storeAutofill: true,
        ),
        isFalse,
      );

      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.prod,
          routeAutofill: false,
          storeAutofill: true,
        ),
        isFalse,
      );
    });

    test('does not enable autofill in UAT without a trigger', () {
      expect(
        AutofillConfig.isEnabledFor(
          environment: AppEnvironment.uat,
          routeAutofill: false,
          storeAutofill: false,
        ),
        isFalse,
      );
    });
  });
}
