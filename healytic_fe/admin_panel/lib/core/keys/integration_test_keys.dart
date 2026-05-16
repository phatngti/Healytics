import 'package:flutter/foundation.dart';

/// Centralized integration test keys for the
/// admin panel. Use [keys] to access all page-
/// specific key groups.
///
/// These keys provide stable widget finders
/// that are immune to text/localization changes.
final keys = IntegrationTestKeys();

/// Root accessor for all integration test keys.
class IntegrationTestKeys {
  final signInPage = SignInPageKeys();
  final sideMenu = SideMenuKeys();
  final dashboard = DashboardKeys();
  final managementTables = ManagementTableKeys();
}

/// Keys for the [SignInScreen].
class SignInPageKeys {
  final emailTextField = const Key('sign_in_email_field');
  final passwordTextField = const Key('sign_in_password_field');
  final loginButton = const Key('sign_in_login_button');
  final forgotPasswordButton = const Key('sign_in_forgot_password_button');
  final joinProviderButton = const Key('sign_in_join_provider_button');
  final roleSwitch = const Key('sign_in_role_switch');
}

/// Keys for the side navigation menu.
class SideMenuKeys {
  final dashboardItem = const Key('side_menu_dashboard');
  final servicesItem = const Key('side_menu_services');
  final employeeItem = const Key('side_menu_employee');
  final serviceTagsItem = const Key('side_menu_service_tags');
  final financeItem = const Key('side_menu_finance');
  final messagesItem = const Key('side_menu_messages');
}

/// Keys for the dashboard screen.
class DashboardKeys {
  final dashboardTitle = const Key('dashboard_title');
}

/// Keys for reusable management table controls.
class ManagementTableKeys {
  final employeeSearchField = const Key('management_employee_search_field');
  final employeeSortButton = const Key('management_employee_sort_button');
  final employeeFilterButton = const Key('management_employee_filter_button');
  final employeeDeleteSelectedButton = const Key(
    'management_employee_delete_selected_button',
  );

  final productSearchField = const Key('management_product_search_field');
  final productSortButton = const Key('management_product_sort_button');
  final productFilterButton = const Key('management_product_filter_button');
  final productDeleteSelectedButton = const Key(
    'management_product_delete_selected_button',
  );

  final serviceTagSearchField = const Key(
    'management_service_tag_search_field',
  );
  final serviceTagSortButton = const Key('management_service_tag_sort_button');
  final serviceTagFilterButton = const Key(
    'management_service_tag_filter_button',
  );
  final serviceTagDeleteSelectedButton = const Key(
    'management_service_tag_delete_selected_button',
  );

  final categorySearchField = const Key('management_category_search_field');
  final categorySortButton = const Key('management_category_sort_button');
  final categoryFilterButton = const Key('management_category_filter_button');
  final categoryDeleteSelectedButton = const Key(
    'management_category_delete_selected_button',
  );

  Key rowDeleteButton(String tableName, String id) {
    return Key('management_${tableName}_row_delete_$id');
  }
}
