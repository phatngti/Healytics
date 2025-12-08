import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:package_info_plus/package_info_plus.dart';

Future<String> getUserAgentString() async {
  final packageInfo = await PackageInfo.fromPlatform();
  String platform;
  if (kIsWeb) {
    platform = 'Web';
  } else if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  } else {
    platform = 'Unknown';
  }
  return 'Play_${platform}_${packageInfo.version}';
}
