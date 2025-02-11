import 'dart:io';

import 'package:injectable/injectable.dart';

@singleton
class Capability {
  // coverage:ignore-start
  bool requireApnsToken() {
    return Platform.isIOS;
  }
  // coverage:ignore-end
}
