import 'package:admin_panel/core/config/app_environment.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';

/// Central gate for sample autofill data.
///
/// UAT is the only environment where these shortcuts are allowed.
abstract final class AutofillConfig {
  static bool isUatAutofillEnabled({required bool routeAutofill}) {
    return isEnabledFor(
      environment: AppEnvironment.fromDartDefine(),
      routeAutofill: routeAutofill,
      storeAutofill: Store.tryGet(StoreKey.autoFill) ?? false,
    );
  }

  static bool isEnabledFor({
    required AppEnvironment environment,
    required bool routeAutofill,
    required bool storeAutofill,
  }) {
    return environment == AppEnvironment.uat &&
        (routeAutofill || storeAutofill);
  }
}
