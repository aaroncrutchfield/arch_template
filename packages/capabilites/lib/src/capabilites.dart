import 'dart:io';

/// {@template capabilites}
/// A package for capabilites
/// {@endtemplate}
class Capabilites {
  /// {@macro capabilites}
  const Capabilites();

  /// Whether the app requires an APNS token
  bool requireApnsToken() {
    return Platform.isIOS;
  }
}
