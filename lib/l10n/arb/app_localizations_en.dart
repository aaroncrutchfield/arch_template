import 'app_localizations.dart';
// coverage:ignore-file
// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithGoogleFailed => 'Google Sign In failed';

  @override
  String get signInWithAppleFailed => 'Apple Sign In failed';
}
