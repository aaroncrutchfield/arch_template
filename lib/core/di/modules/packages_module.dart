// coverage:ignore-file
import 'package:analytics/analytics.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:user_repository/user_repository.dart';

@module
abstract class PackagesModule {
  @singleton
  AuthRepository getAuthRepository(FirebaseAuth auth) => AuthRepository(auth);

  @singleton
  Analytics getAnalytics(FirebaseAnalytics analytics) => Analytics(analytics);

  @singleton
  UserRepository getUserRepository(FirebaseFirestore firestore) =>
      UserRepository(firestore);
}
