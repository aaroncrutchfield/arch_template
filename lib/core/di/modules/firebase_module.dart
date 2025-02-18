// coverage:ignore-file
import 'package:arch_template/core/di/data/injectable/annotations.dart';
import 'package:arch_template/firebase/firebase_options_dev.dart' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @development
  @singleton
  FirebaseOptions getDevOptions() => dev.DefaultFirebaseOptions.currentPlatform;

  @production
  @singleton
  FirebaseOptions getProdOptions() => throw UnimplementedError();

  @staging
  @singleton
  FirebaseOptions getStagingOptions() => throw UnimplementedError();

  @singleton
  @development
  @staging
  @production
  @preResolve
  Future<FirebaseApp> getFirebase(FirebaseOptions options) =>
      Firebase.initializeApp(options: options);

  @singleton
  FirebaseAuth getFirebaseAuth(FirebaseApp app) =>
      FirebaseAuth.instanceFor(app: app);

  @singleton
  FirebaseAnalytics getFirebaseAnalytics(FirebaseApp app) =>
      FirebaseAnalytics.instanceFor(app: app);

  @singleton
  FirebaseAnalyticsObserver getFirebaseAnalyticsObserver(
    FirebaseAnalytics analytics,
  ) =>
      FirebaseAnalyticsObserver(analytics: analytics);

  @singleton
  FirebaseMessaging getFirebaseMessaging(FirebaseApp app) =>
      FirebaseMessaging.instance;

  @singleton
  FirebaseCrashlytics getFirebaseCrashlytics(FirebaseApp app) =>
      FirebaseCrashlytics.instance;

  @singleton
  FirebaseFirestore getFirebaseFirestore(FirebaseApp app) =>
      FirebaseFirestore.instanceFor(app: app);
}
