// coverage:ignore-file
import 'package:analytics/analytics.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module
abstract class PackagesModule {
  @singleton
  AuthRepository getAuthRepository(FirebaseAuth auth) => AuthRepository(auth);

  @singleton
  Analytics getAnalytics(FirebaseAnalytics analytics) => Analytics(analytics);
}
