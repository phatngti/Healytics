import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_section.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_dashboard_alert.entity.freezed.dart';
part 'admin_dashboard_alert.entity.g.dart';

enum AdminDashboardAlertSeverity { success, info, warning, critical }

@freezed
abstract class AdminDashboardAlert with _$AdminDashboardAlert {
  const factory AdminDashboardAlert({
    required String id,
    required String title,
    required String description,
    required AdminDashboardAlertSeverity severity,
    required AdminDashboardSection section,
  }) = _AdminDashboardAlert;

  factory AdminDashboardAlert.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardAlertFromJson(json);
}
