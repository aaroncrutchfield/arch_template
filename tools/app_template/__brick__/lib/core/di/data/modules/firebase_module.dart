// coverage:ignore-file
import 'package:{{project_name.snakeCase}}/core/di/data/injectable/annotations.dart';
import 'package:{{project_name.snakeCase}}/firebase/firebase_options_dev.dart'
    as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
}
