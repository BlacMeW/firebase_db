// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB9T_aGQlmTdgeP_gQU44LAENfckXuUoaQ',
    appId: '1:700990837108:web:f2669444cb29df59d39c21',
    messagingSenderId: '700990837108',
    projectId: 'fir-db-81cb1',
    authDomain: 'fir-db-81cb1.firebaseapp.com',
    databaseURL: 'https://fir-db-81cb1-default-rtdb.firebaseio.com',
    storageBucket: 'fir-db-81cb1.firebasestorage.app',
    measurementId: 'G-3E2TVGQBVH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAa-PQmYHh6hk3GzFphtV-QB1ONCb7SxnM',
    appId: '1:700990837108:android:0b2c3960bab9d697d39c21',
    messagingSenderId: '700990837108',
    projectId: 'fir-db-81cb1',
    databaseURL: 'https://fir-db-81cb1-default-rtdb.firebaseio.com',
    storageBucket: 'fir-db-81cb1.firebasestorage.app',
  );

}