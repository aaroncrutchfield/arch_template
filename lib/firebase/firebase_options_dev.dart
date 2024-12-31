// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyClFh77QCvCRPXctwhcxuFQqci7iCR1rOQ',
    appId: '1:994143003163:web:623dfd9b34a1afba6f4ebe',
    messagingSenderId: '994143003163',
    projectId: 'apostletec-arch-template',
    authDomain: 'apostletec-arch-template.firebaseapp.com',
    storageBucket: 'apostletec-arch-template.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyFIU0WBOXvICCKjOFVNMsi03UAsA3lVM',
    appId: '1:994143003163:android:adc59180540db7246f4ebe',
    messagingSenderId: '994143003163',
    projectId: 'apostletec-arch-template',
    storageBucket: 'apostletec-arch-template.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuwIPduWT6J3rLzI5piPAs0b_I9qLof90',
    appId: '1:994143003163:ios:647a327bbbded5b26f4ebe',
    messagingSenderId: '994143003163',
    projectId: 'apostletec-arch-template',
    storageBucket: 'apostletec-arch-template.firebasestorage.app',
    iosClientId:
        '994143003163-vejch33lhso3fm9c8vp03b1539ublt8h.apps.googleusercontent.com',
    iosBundleId: 'com.fluttermasterclass.arch-template.dev',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuwIPduWT6J3rLzI5piPAs0b_I9qLof90',
    appId: '1:994143003163:ios:647a327bbbded5b26f4ebe',
    messagingSenderId: '994143003163',
    projectId: 'apostletec-arch-template',
    storageBucket: 'apostletec-arch-template.firebasestorage.app',
    iosClientId:
        '994143003163-vejch33lhso3fm9c8vp03b1539ublt8h.apps.googleusercontent.com',
    iosBundleId: 'com.fluttermasterclass.arch-template.dev',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyClFh77QCvCRPXctwhcxuFQqci7iCR1rOQ',
    appId: '1:994143003163:web:9c317c8b761f8b476f4ebe',
    messagingSenderId: '994143003163',
    projectId: 'apostletec-arch-template',
    authDomain: 'apostletec-arch-template.firebaseapp.com',
    storageBucket: 'apostletec-arch-template.firebasestorage.app',
  );
}
