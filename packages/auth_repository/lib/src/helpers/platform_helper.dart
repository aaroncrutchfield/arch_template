import 'package:flutter/foundation.dart';

/// Helper class to abstract platform-specific checks
class PlatformHelper {
  /// Returns true if the app is running on web
  bool get isWeb => kIsWeb;
}
