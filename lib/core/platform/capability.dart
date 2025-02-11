import 'dart:io';

import 'package:injectable/injectable.dart';

@singleton
class Capability {
  bool requireApnsToken() {
    return Platform.isIOS;
  }
}
