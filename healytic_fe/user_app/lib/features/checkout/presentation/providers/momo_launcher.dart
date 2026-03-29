import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

/// Opens the MoMo wallet app via native deep link,
/// falling back to the web [payUrl] if the deep link
/// cannot be launched (e.g. MoMo not installed).
///
/// Returns `true` if a URL was launched successfully.
Future<bool> launchMoMoPayment({
  String? deeplink,
  String? payUrl,
}) async {
  // Prefer the native deeplink to open MoMo app directly.
  if (deeplink != null && deeplink.isNotEmpty) {
    final uri = Uri.tryParse(deeplink);
    if (uri != null && await canLaunchUrl(uri)) {
      return launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // Fallback: open the web payment page.
  if (payUrl != null && payUrl.isNotEmpty) {
    final uri = Uri.tryParse(payUrl);
    if (uri != null) {
      return launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  log(
    'launchMoMoPayment: no valid URL to launch',
    name: 'MoMoLauncher',
  );
  return false;
}
