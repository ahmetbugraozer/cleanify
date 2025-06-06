// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:cleanify/env_config.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: EnvConfig.webApiKey,
    appId: EnvConfig.webAppId,
    messagingSenderId: EnvConfig.messagingSenderId,
    projectId: EnvConfig.projectId,
    authDomain: EnvConfig.webAuthDomain,
    storageBucket: EnvConfig.storageBucket,
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: EnvConfig.androidApiKey,
    appId: EnvConfig.androidAppId,
    messagingSenderId: EnvConfig.messagingSenderId,
    projectId: EnvConfig.projectId,
    storageBucket: EnvConfig.storageBucket,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: EnvConfig.iosApiKey,
    appId: EnvConfig.iosAppId,
    messagingSenderId: EnvConfig.messagingSenderId,
    projectId: EnvConfig.projectId,
    storageBucket: EnvConfig.storageBucket,
    iosBundleId: EnvConfig.iosBundleId,
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: EnvConfig.macosApiKey,
    appId: EnvConfig.macosAppId,
    messagingSenderId: EnvConfig.messagingSenderId,
    projectId: EnvConfig.projectId,
    storageBucket: EnvConfig.storageBucket,
    iosBundleId: EnvConfig.macosBundleId,
  );
}
